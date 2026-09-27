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
            // Devices with few steps (e.g. 5) get a segmented bar, so it is
            // visible that "80 %" means "level 4 of 5".
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: modelData.steps <= 10
                spacing: Math.max(2, Theme.paddingSmall / 2)
                Repeater {
                    model: modelData.steps <= 10 ? modelData.steps : 0
                    Rectangle {
                        width: (Theme.itemSizeSmall - (modelData.steps - 1) * parent.spacing) / modelData.steps
                        height: Theme.paddingSmall
                        radius: height / 2
                        color: index < modelData.level
                               ? (modelData.percent <= 20 ? Theme.errorColor : Theme.highlightColor)
                               : Theme.rgba(Theme.primaryColor, 0.2)
                    }
                }
            }
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: modelData.steps > 10
                width: Theme.itemSizeSmall
                height: Theme.paddingSmall
                radius: height / 2
                color: Theme.rgba(Theme.primaryColor, 0.2)
                Rectangle {
                    width: parent.width * modelData.percent / 100
                    height: parent.height
                    radius: parent.radius
                    color: modelData.percent <= 20 ? Theme.errorColor : Theme.highlightColor
                }
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
