// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import "Strings.js" as Strings

// Holds everything we know about one connected device:
//   categories: output of `openscq30 device list-settings --json`
//               [{ categoryId, settings: [{ settingId, type, setting }] }]
//   values:     settingId -> current value (already unwrapped)
//
// Every CLI call builds its own Bluetooth connection (a few seconds), so we
// combine as much as possible into one call: a set is always followed by
// --get for all readable settings in the same invocation.
Item {
    id: session

    property string macAddress
    property string modelId
    property string title

    property var categories: []
    property var values: ({})
    property var pending: ({})       // settingId -> true while being written

    property bool loading: false     // connecting / loading structure
    property double lastUpdate: 0    // Date.now() of the last successful value read
    property bool connected: false
    property string error: ""        // fatal (could not connect)
    property string warning: ""      // non fatal (a single set/get failed)

    property var _requests: ({})     // requestId -> { kind, settingId, reloadStructure }
    // Settings the device currently does not provide (e.g. battery of an earbud
    // lying in the case). The CLI stops at the first such --get, so they are skipped.
    property var _skip: ({})
    property int _requestCount: 0
    readonly property bool busy: _requestCount > 0

    signal valuesUpdated()

    // Another device: forget everything about the previous one.
    onMacAddressChanged: {
        abort()
        categories = []
        values = ({})
        _skip = ({})
        connected = false
        error = ""
        warning = ""
        lastUpdate = 0
    }

    // Connects if needed, otherwise re-reads values if they are older than maxAgeMs.
    function ensureFresh(maxAgeMs) {
        if (!macAddress || busy)
            return
        if (!connected)
            reload()
        else if (Date.now() - lastUpdate > maxAgeMs)
            refreshValues()
    }

    // ---- public API -------------------------------------------------------

    function reload() {
        error = ""
        _skip = ({})
        loading = true
        _send(["device", "--mac-address", macAddress, "list-settings", "--json"],
              { kind: "structure" }, 60000)
    }

    function refreshValues(retries) {
        if (!retries)
            _skip = ({})    // user refresh: try everything again
        var ids = readableIds()
        if (ids.length === 0) {
            loading = false
            return
        }
        var args = ["device", "--mac-address", macAddress, "setting"]
        for (var i = 0; i < ids.length; i++)
            args.push("--get", ids[i])
        args.push("--json")
        _send(args, { kind: "values", retries: retries || 0 })
    }

    // value is the string representation the CLI expects (see `openscq30 device setting --help`).
    // reloadStructure: the set changes which settings/options exist (e.g. adding an
    // equalizer profile), so list-settings has to be run again afterwards.
    function setValue(settingId, value, reloadStructure) {
        var args = ["device", "--mac-address", macAddress, "setting",
                    "--set", settingId + "=" + value]
        if (!reloadStructure) {
            var ids = readableIds()
            for (var i = 0; i < ids.length; i++)
                args.push("--get", ids[i])
        }
        args.push("--json")

        var p = _copy(pending)
        p[settingId] = true
        pending = p
        warning = ""
        _send(args, { kind: "set", settingId: settingId, reloadStructure: !!reloadStructure })
    }

    // Stops all running/queued requests of this device (e.g. "cancel connecting").
    function abort() {
        for (var id in _requests)
            openscq30.abort(parseInt(id))
        _requests = ({})
        _requestCount = 0
        pending = ({})
        loading = false
    }

    // Definition of one setting from list-settings ({ settingId, type, setting }) or null.
    function settingDef(settingId) {
        for (var c = 0; c < categories.length; c++) {
            var settings = categories[c].settings || []
            for (var s = 0; s < settings.length; s++)
                if (settings[s].settingId === settingId)
                    return settings[s]
        }
        return null
    }

    // Localized text of a select's current value, e.g. "Geräuschunterdrückung".
    function localizedValue(settingId) {
        var def = settingDef(settingId)
        var v = values[settingId]
        if (!def || !def.setting || !def.setting.options)
            return v === undefined || v === null ? "" : String(v)
        var i = def.setting.options.indexOf(v)
        var lo = def.setting.localizedOptions || []
        return i >= 0 && lo[i] ? Strings.translateText(lo[i]) : (v === undefined || v === null ? "" : String(v))
    }

    // The setting the cover button switches: "ambientSoundMode" (most models),
    // "listeningMode" (Sleep A30), otherwise the first select in the
    // "soundModes" category so that future models work too. "" if none.
    function soundModeSettingId() {
        var candidates = ["ambientSoundMode", "listeningMode"]
        for (var i = 0; i < candidates.length; i++) {
            var def = settingDef(candidates[i])
            if (def && def.type === "select")
                return candidates[i]
        }
        var cat = category("soundModes")
        var settings = cat && cat.settings ? cat.settings : []
        for (var j = 0; j < settings.length; j++)
            if (settings[j].type === "select")
                return settings[j].settingId
        return ""
    }

    // Switches a select setting to its next option (wraps around).
    // Used by the cover action to cycle through the sound modes.
    function cycleSelect(settingId) {
        var def = settingDef(settingId)
        if (!def || def.type !== "select" || !def.setting || !def.setting.options)
            return false
        var options = def.setting.options
        if (options.length === 0 || pending[settingId])
            return false
        var i = options.indexOf(values[settingId])
        setValue(settingId, options[(i + 1) % options.length])
        return true
    }

    function category(categoryId) {
        for (var i = 0; i < categories.length; i++)
            if (categories[i].categoryId === categoryId)
                return categories[i]
        return null
    }

    function readableIds() {
        var ids = []
        for (var c = 0; c < categories.length; c++) {
            var settings = categories[c].settings || []
            for (var s = 0; s < settings.length; s++) {
                var t = settings[s].type
                if (t !== "action" && t !== "importString" && !_skip[settings[s].settingId])
                    ids.push(settings[s].settingId)
            }
        }
        return ids
    }

    // Finds the first readable value whose id matches the regexp (used by the cover).
    function findValues(regexp) {
        var result = []
        var ids = readableIds()
        for (var i = 0; i < ids.length; i++)
            if (regexp.test(ids[i]) && values[ids[i]] !== undefined)
                result.push({ settingId: ids[i], value: values[ids[i]] })
        return result
    }

    // ---- internals --------------------------------------------------------

    function _copy(obj) {
        var r = {}
        for (var k in obj)
            r[k] = obj[k]
        return r
    }

    function _send(args, info, timeout) {
        var id = openscq30.run(args, timeout || 45000)
        var r = _copy(_requests)
        r[id] = info
        _requests = r
        _requestCount = Object.keys(r).length
    }

    function _merge(list) {
        if (!list || list.length === undefined)
            return
        var v = _copy(values)
        for (var i = 0; i < list.length; i++) {
            var item = list[i]
            if (!item || !item.settingId)
                continue
            // Values are serialized as { "type": "...", "value": ... }
            var raw = item.value
            v[item.settingId] = (raw !== null && typeof raw === "object" && raw.hasOwnProperty("value"))
                    ? raw.value : raw
        }
        values = v
        valuesUpdated()
    }

    // "SoundcoreA3947 does not use setting id batteryLevelLeft." -> "batteryLevelLeft"
    function _unavailableSetting(message) {
        var m = /setting id (\w+)/.exec(message)
        return m ? m[1] : ""
    }

    function _skipSetting(id) {
        var k = _copy(_skip)
        k[id] = true
        _skip = k
        if (values[id] !== undefined) {
            var v = _copy(values)
            delete v[id]
            values = v
            valuesUpdated()
        }
    }

    function _clean(text) {
        return String(text || "").replace(/^Error:\s*/, "").trim()
    }

    Connections {
        target: openscq30
        onFinished: {
            var info = session._requests[requestId]
            if (!info)
                return
            var r = session._copy(session._requests)
            delete r[requestId]
            session._requests = r
            session._requestCount = Object.keys(r).length

            var message = session._clean(errorOutput)

            if (info.kind === "structure") {
                if (success && json && json.length !== undefined) {
                    session.categories = json
                    session.connected = true
                    session.refreshValues()
                } else {
                    session.loading = false
                    session.connected = false
                    session.error = message || qsTr("Unknown error")
                }
            } else if (info.kind === "values") {
                session._merge(json)
                var missing = success ? "" : session._unavailableSetting(message)
                if (missing && !session._skip[missing] && info.retries < 10) {
                    // skip it and read the remaining values again
                    session._skipSetting(missing)
                    session.refreshValues(info.retries + 1)
                    return
                }
                session.loading = false
                session.lastUpdate = Date.now()
                if (!success)
                    session.warning = message
            } else if (info.kind === "set") {
                session._merge(json)
                var p = session._copy(session.pending)
                delete p[info.settingId]
                session.pending = p
                var unavailable = success ? "" : session._unavailableSetting(message)
                if (unavailable && unavailable !== info.settingId) {
                    // the set worked, only a following --get failed
                    session._skipSetting(unavailable)
                    session.refreshValues(1)
                } else if (!success) {
                    session.warning = message
                    // re-read the real state so the UI does not show the failed value
                    session.refreshValues()
                } else if (info.reloadStructure) {
                    session.reload()
                }
            }
        }
    }

    Component.onDestruction: {
        for (var id in _requests)
            openscq30.cancel(parseInt(id))
    }
}
