// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/Strings.js" as Strings

// Connects to one device: illustration, battery levels and setting categories.
Page {
    id: page

    property string macAddress
    property string modelId

    // Opened automatically at app start. If the device cannot be reached,
    // go back to the device list instead of showing the error here.
    property bool autoOpened: false
    property bool _fallbackPending: false

    function fallbackToList() {
        if (pageStack.busy) {
            _fallbackPending = true    // wait until the push animation is done
            return
        }
        _fallbackPending = false
        appWindow.autoConnectFailed(deviceSession.title, deviceSession.error)
        pageStack.pop(pageStack.find(function(p) { return p.objectName === "deviceSelectionPage" }))
    }

    Connections {
        target: deviceSession
        onErrorChanged: {
            if (page.autoOpened && deviceSession.error.length > 0 && !deviceSession.connected)
                page.fallbackToList()
        }
        onConnectedChanged: {
            // once connected, later errors are shown on this page as usual
            if (deviceSession.connected)
                page.autoOpened = false
        }
    }

    // Re-read values (battery, sound mode, ...) every 2 minutes while the app is
    // in the foreground. Every read opens a Bluetooth connection, so not faster.
    // In the background the cover takes care of this.
    Timer {
        interval: 120000
        repeat: true
        running: Qt.application.active && deviceSession.connected
        onTriggered: deviceSession.ensureFresh(110000)
    }

    // back in the foreground: refresh right away if the values are older than a minute
    Connections {
        target: Qt.application
        onActiveChanged: {
            if (Qt.application.active && deviceSession.connected)
                deviceSession.ensureFresh(60000)
        }
    }

    Connections {
        target: pageStack
        onBusyChanged: {
            if (!pageStack.busy && page._fallbackPending)
                page.fallbackToList()
        }
    }

    DeviceSession {
        id: deviceSession
        macAddress: page.macAddress
        modelId: page.modelId
        title: appWindow.modelName(page.modelId)
    }

    Component.onCompleted: {
        appWindow.rememberDevice(page.macAddress, page.modelId)
        appWindow.pageSession = deviceSession
        deviceSession.reload()
    }
    Component.onDestruction: {
        if (appWindow.pageSession === deviceSession)
            appWindow.pageSession = null
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: deviceSession.connected ? deviceSession.categories : []

        PullDownMenu {
            busy: deviceSession.busy
            MenuItem {
                text: qsTr("Reconnect")
                onClicked: deviceSession.reload()
            }
            MenuItem {
                text: qsTr("Refresh values")
                enabled: deviceSession.connected
                onClicked: deviceSession.refreshValues()
            }
        }

        header: Column {
            width: listView.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: deviceSession.title
                description: page.macAddress
            }

            WarningBanner {
                text: deviceSession.warning
                onDismissed: deviceSession.warning = ""
            }

            DeviceTile {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeHuge * 1.4
                large: true
                modelId: page.modelId
                opacity: deviceSession.connected ? 1.0 : 0.5
                Behavior on opacity { FadeAnimation { } }
            }

            BatteryRow {
                session: deviceSession
            }

            // when the values were read (they are not live, every read needs a connection)
            Label {
                visible: deviceSession.connected && deviceSession.lastUpdate > 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: deviceSession.busy ? qsTr("Updating…")
                                         : qsTr("As of %1").arg(Qt.formatTime(new Date(deviceSession.lastUpdate), "hh:mm"))
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
            }

            // ---- connecting ---------------------------------------------
            Column {
                visible: deviceSession.loading && !deviceSession.connected
                width: parent.width
                spacing: Theme.paddingLarge

                BusyIndicator {
                    anchors.horizontalCenter: parent.horizontalCenter
                    size: BusyIndicatorSize.Medium
                    running: parent.visible
                }
                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    text: qsTr("Connecting to %1").arg(deviceSession.title)
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Cancel")
                    onClicked: {
                        deviceSession.abort()
                        pageStack.pop()
                    }
                }
            }

            // ---- connection failed --------------------------------------
            Column {
                visible: !deviceSession.loading && !deviceSession.connected && deviceSession.error.length > 0
                         && !page.autoOpened
                width: parent.width
                spacing: Theme.paddingMedium

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeLarge
                    text: qsTr("Could not connect")
                }
                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    color: Theme.secondaryHighlightColor
                    text: qsTr("Make sure the headphones are switched on and connected via Bluetooth. Pull down to try again.")
                }
                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * Theme.horizontalPageMargin
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    color: Theme.errorColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: deviceSession.error
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Retry")
                    onClicked: deviceSession.reload()
                }
            }

            SectionHeader {
                visible: deviceSession.connected && deviceSession.categories.length > 0
                text: qsTr("Settings")
            }
        }

        delegate: ListItem {
            id: item
            contentHeight: Theme.itemSizeSmall
            onClicked: pageStack.push(Qt.resolvedUrl("CategoryPage.qml"), {
                session: deviceSession,
                categoryId: modelData.categoryId
            })

            Label {
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 2 * Theme.horizontalPageMargin - arrow.width
                text: Strings.name(modelData.categoryId)
                truncationMode: TruncationMode.Fade
                color: item.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            Icon {
                id: arrow
                anchors {
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                source: "image://theme/icon-m-right"
                highlighted: item.highlighted
            }
        }

        VerticalScrollDecorator { }
    }
}
