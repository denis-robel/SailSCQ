// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

// List of devices paired with openscq30 (`openscq30 paired-devices list --json`).
Page {
    id: page
    objectName: "deviceSelectionPage"

    property var devices: []
    property string errorText: ""
    property string infoText: ""

    // At app start, open the last used device right away (the list stays
    // below it, so "back" leads here).
    onStatusChanged: {
        if (status !== PageStatus.Active || appWindow.autoOpenDone)
            return
        appWindow.autoOpenDone = true
        if (appWindow.lastMacAddress.length > 0 && openscq30.binaryAvailable) {
            pageStack.push(Qt.resolvedUrl("DevicePage.qml"), {
                macAddress: appWindow.lastMacAddress,
                modelId: appWindow.lastModelId,
                autoOpened: true
            }, PageStackAction.Immediate)
        }
    }

    function loadDevices() {
        errorText = ""
        listCli.run(["paired-devices", "list", "--json"])
    }

    Component.onCompleted: {
        if (!openscq30.binaryAvailable) {
            errorText = qsTr("openscq30 not found at %1").arg(openscq30.binaryPath)
            return
        }
        modelsCli.run(["list-models", "--json"])
        loadDevices()
    }

    Connections {
        target: appWindow
        onPairedDevicesChanged: page.loadDevices()
        onAutoConnectFailed: {
            page.infoText = qsTr("%1 is not available. Make sure the headphones are switched on and connected via Bluetooth, then choose the device again.").arg(title)
        }
    }

    CliRunner {
        id: modelsCli
        onFinished: {
            if (!success || !json)
                return
            var names = {}
            for (var i = 0; i < json.length; i++)
                names[json[i].model] = json[i].name
            appWindow.modelNames = names
        }
    }

    CliRunner {
        id: listCli
        onFinished: {
            if (success && json && json.length !== undefined)
                page.devices = json
            else
                page.errorText = qsTr("Could not load devices: %1").arg(errorOutput)
        }
    }

    CliRunner {
        id: removeCli
        onFinished: {
            if (!success)
                page.errorText = qsTr("Could not remove device: %1").arg(errorOutput)
            page.loadDevices()
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: page.devices

        PullDownMenu {
            busy: listCli.running || removeCli.running
            MenuItem {
                text: qsTr("About SailSCQ")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Supported devices")
                onClicked: pageStack.push(Qt.resolvedUrl("SupportedDevicesPage.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: page.loadDevices()
            }
            MenuItem {
                text: qsTr("Add device")
                onClicked: pageStack.push(Qt.resolvedUrl("AddDevicePage.qml"))
            }
        }

        header: Column {
            width: listView.width

            PageHeader {
                title: "SailSCQ"
                description: qsTr("Soundcore device manager")
            }

            WarningBanner {
                text: page.infoText
                onDismissed: page.infoText = ""
            }

            Label {
                visible: page.errorText.length > 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: page.errorText
                color: Theme.errorColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                bottomPadding: Theme.paddingLarge
            }
        }

        delegate: ListItem {
            id: item
            contentHeight: Theme.itemSizeLarge
            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Remove")
                    onClicked: {
                        var mac = modelData.macAddress
                        item.remorseDelete(function() {
                            appWindow.forgetDevice(mac)
                            removeCli.run(["paired-devices", "remove", "--mac-address", mac])
                        })
                    }
                }
            }

            onClicked: {
                page.infoText = ""
                pageStack.push(Qt.resolvedUrl("DevicePage.qml"), {
                    macAddress: modelData.macAddress,
                    modelId: modelData.model
                })
            }

            DeviceTile {
                id: icon
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                modelId: modelData.model
                highlighted: item.highlighted
            }

            Column {
                anchors {
                    left: icon.right; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    width: parent.width
                    text: appWindow.modelName(modelData.model)
                    truncationMode: TruncationMode.Fade
                    color: item.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    width: parent.width
                    text: modelData.macAddress + (modelData.isDemo ? " · " + qsTr("Demo") : "")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: item.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
            }
        }

        // Empty list (first start): illustration + hint, as in the mockup
        Column {
            visible: listView.count === 0 && !listCli.running
            anchors.centerIn: parent
            width: parent.width - 2 * Theme.horizontalPageMargin
            spacing: Theme.paddingLarge

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.itemSizeHuge
                height: width
                sourceSize.width: width
                sourceSize.height: height
                source: Qt.resolvedUrl("../../images/inear.png")
                opacity: 0.55
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("No devices")
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: Theme.fontFamilyHeading
                color: Theme.secondaryHighlightColor
                wrapMode: Text.Wrap
            }
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Pull down to add your Soundcore device")
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.secondaryColor
                wrapMode: Text.Wrap
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: listCli.running && listView.count === 0
        }

        VerticalScrollDecorator { }
    }
}
