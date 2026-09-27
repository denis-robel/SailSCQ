// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0

// Small wrapper around the C++ "openscq30" backend: runs one CLI call at a
// time and delivers only its own results.
Item {
    id: root

    property bool running: false
    property int _requestId: -1

    signal finished(bool success, var json, string output, string errorOutput)

    function run(args) {
        cancel()
        running = true
        _requestId = openscq30.run(args)
    }

    // Drops a queued request / ignores the result of a running one.
    function cancel() {
        if (_requestId >= 0)
            openscq30.cancel(_requestId)
        _requestId = -1
        running = false
    }

    // Kills a running request (e.g. user cancels connecting).
    function abort() {
        if (_requestId >= 0)
            openscq30.abort(_requestId)
        _requestId = -1
        running = false
    }

    // "Error: device not found" -> "device not found"
    function cleanError(text) {
        return String(text || "").replace(/^Error:\s*/, "").trim()
    }

    Connections {
        target: openscq30
        onFinished: {
            if (requestId !== root._requestId)
                return
            root._requestId = -1
            root.running = false
            root.finished(success, json, output, root.cleanError(errorOutput))
        }
    }

    Component.onDestruction: cancel()
}
