// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "Strings.js" as Strings

// Battery levels of the device (left / right / case, or a single battery).
Row {
    id: row

    property var session

    readonly property var entries: {
        if (!session) return []
        var v = session.values
        var defs = [
            { id: "batteryLevelLeft",  charging: "isChargingLeft",  label: qsTr("Left") },
            { id: "batteryLevelRight", charging: "isChargingRight", label: qsTr("Right") },
            { id: "batteryLevel",      charging: "isCharging",      label: qsTr("Battery") },
            { id: "caseBatteryLevel",  charging: "",                label: qsTr("Case") }
        ]
        var result = []
        for (var i = 0; i < defs.length; i++) {
            var p = Strings.batteryPercent(v[defs[i].id])
            if (p < 0) continue
            var lv = Strings.batteryLevel(v[defs[i].id])
            result.push({
                label: defs[i].label,
                percent: p,
                level: lv.level,
                steps: lv.max,
                charging: defs[i].charging.length > 0 && Strings.yesNo(v[defs[i].charging]) === true
            })
        }
        return result
    }

    visible: entries.length > 0
    x: Theme.horizontalPageMargin
    width: parent ? parent.width - 2 * Theme.horizontalPageMargin : 0
    height: visible ? implicitHeight : 0

    Repeater {
        model: row.entries

        Column {
            width: row.width / Math.max(1, row.entries.length)
            spacing: Theme.paddingSmall

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: modelData.percent + " %"
                font.pixelSize: Theme.fontSizeLarge
                font.family: Theme.fontFamilyHeading
            }
            BatteryIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                level: modelData.level
                steps: modelData.steps
                percent: modelData.percent
                charging: modelData.charging
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: modelData.charging ? qsTr("%1 · charging").arg(modelData.label) : modelData.label
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
            }
        }
    }
}
