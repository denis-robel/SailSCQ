// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "Strings.js" as Strings

// Equalizer with one slider per band.
// params: { bandHz: [...], fractionDigits, min, max }
// Values are integers; with fractionDigits = 1, 134 means 13.4 dB.
// Changes are collected locally and written with one CLI call ("Apply"),
// because every write needs a new Bluetooth connection.
Column {
    id: eq

    property var session
    property string settingId
    property var params: ({})
    property var value
    property bool pending: false

    property var edited: []
    property bool dirty: false

    readonly property var bands: params.bandHz || []
    readonly property int fractionDigits: params.fractionDigits || 0
    readonly property real divisor: Math.pow(10, fractionDigits)

    width: parent ? parent.width : Screen.width

    function sync() {
        if (dirty)
            return
        var v = []
        for (var i = 0; i < bands.length; i++)
            v.push(value && value.length > i ? value[i] : 0)
        edited = v
    }

    function setBand(index, bandValue) {
        var v = edited.slice()
        v[index] = Math.round(bandValue)
        edited = v
        dirty = true
    }

    function formatHz(hz) {
        return hz >= 1000 ? (hz / 1000) + " kHz" : hz + " Hz"
    }

    function formatDb(raw) {
        var db = raw / divisor
        return (db > 0 ? "+" : "") + db.toFixed(fractionDigits) + " dB"
    }

    onValueChanged: sync()
    Component.onCompleted: sync()

    SectionHeader { text: Strings.name(eq.settingId) }

    Repeater {
        model: eq.bands.length
        Slider {
            id: bandSlider
            width: eq.width
            label: eq.formatHz(eq.bands[index])
            minimumValue: eq.params.min !== undefined ? eq.params.min : -120
            maximumValue: eq.params.max !== undefined ? eq.params.max : 120
            stepSize: 1
            function sync() {
                if (!down && eq.edited.length > index)
                    value = eq.edited[index]
            }
            Component.onCompleted: sync()
            Connections { target: eq; onEditedChanged: bandSlider.sync() }
            valueText: eq.formatDb(value)
            enabled: !eq.pending
            onDownChanged: if (!down) eq.setBand(index, value)
            onValueChanged: if (down) eq.setBand(index, value)
        }
    }

    ButtonLayout {
        width: parent.width

        Button {
            text: qsTr("Reset")
            enabled: eq.dirty && !eq.pending
            onClicked: {
                eq.dirty = false
                eq.sync()
            }
        }
        Button {
            text: eq.pending ? qsTr("Applying…") : qsTr("Apply")
            enabled: eq.dirty && !eq.pending
            onClicked: {
                eq.session.setValue(eq.settingId, eq.edited.join(","))
                eq.dirty = false
            }
        }
    }

    Item { width: 1; height: Theme.paddingLarge }
}
