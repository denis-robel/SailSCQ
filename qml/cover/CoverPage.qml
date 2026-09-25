// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/Strings.js" as Strings

CoverBackground {
    id: cover

    readonly property var session: appWindow.currentSession
    readonly property bool connected: session !== null && session.connected

    // Sound mode (Normal / Transparenz / Geräuschunterdrückung), if the device has one
    readonly property string soundModeId: "ambientSoundMode"
    readonly property bool hasSoundMode: connected && session.settingDef(soundModeId) !== null
    readonly property bool switching: hasSoundMode && !!session.pending[soundModeId]

    readonly property var batteries: connected
                                     ? session.findValues(/^batteryLevel|^caseBatteryLevel/) : []

    readonly property bool shown: status === Cover.Active

    // Connect / refresh when the cover becomes visible on the home screen,
    // then at most once a minute while it stays visible (every CLI call
    // opens a Bluetooth connection, so no faster polling).
    function freshen() {
        if (shown && session)
            session.ensureFresh(55000)
    }
    onShownChanged: freshen()
    onSessionChanged: freshen()

    Timer {
        interval: 60000
        repeat: true
        running: cover.shown && cover.session !== null
        onTriggered: cover.freshen()
    }

    Column {
        anchors {
            left: parent.left; right: parent.right
            top: parent.top; topMargin: Theme.paddingLarge
            margins: Theme.paddingMedium
        }
        spacing: Theme.paddingSmall

        DeviceTile {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: cover.session !== null
            width: Theme.itemSizeMedium
            modelId: cover.session ? cover.session.modelId : ""
            color: "transparent"
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: cover.session === null
            source: "image://theme/icon-m-headphone"
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: cover.session ? cover.session.title : "SailSCQ"
            font.pixelSize: Theme.fontSizeSmall
            truncationMode: TruncationMode.Fade
        }

        // current sound mode, large and in the highlight color
        Label {
            visible: cover.hasSoundMode
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeMedium
            text: !cover.hasSoundMode ? ""
                  : cover.switching ? qsTr("Switching…")
                  : cover.session.localizedValue(cover.soundModeId)
            opacity: cover.switching ? 0.6 : 1.0
        }

        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            wrapMode: Text.Wrap
            text: {
                if (!cover.session)
                    return qsTr("Soundcore manager")
                if (!cover.connected)
                    return cover.session.busy ? qsTr("Connecting…") : qsTr("Not connected")
                return ""
            }
            visible: text.length > 0
        }

        // battery levels in one compact line: "L 80 %  R 75 %  Hülle 60 %"
        Label {
            visible: cover.batteries.length > 0
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: {
                var parts = []
                for (var i = 0; i < cover.batteries.length; i++) {
                    var b = cover.batteries[i]
                    var p = Strings.batteryPercent(b.value)
                    if (p < 0) continue
                    var abbr = b.settingId === "batteryLevelLeft" ? qsTr("L")
                              : b.settingId === "batteryLevelRight" ? qsTr("R")
                              : b.settingId === "caseBatteryLevel" ? qsTr("Case")
                              : b.settingId === "batteryLevel" ? qsTr("Battery")
                              : ""
                    parts.push((abbr ? abbr + " " : "") + p + " %")
                }
                return parts.join("  ")
            }
        }
    }

    // Two actions: refresh (left) and next sound mode (right)
    CoverActionList {
        enabled: cover.hasSoundMode

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: cover.session.refreshValues()
        }
        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: cover.session.cycleSelect(cover.soundModeId)
        }
    }

    // Devices without sound modes (e.g. speakers): only refresh
    CoverActionList {
        enabled: cover.connected && !cover.hasSoundMode

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: cover.session.refreshValues()
        }
    }
}
