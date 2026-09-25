// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/Strings.js" as Strings

// Step 1: choose the headphones from the phone's paired Bluetooth devices
// (or enter the MAC address manually). Step 2 is ModelSelectionPage.
Page {
    id: page

    property var btDevices: []

    function refresh() {
        btDevices = bluetooth.pairedDevices()
    }

    function isValidMac(mac) {
        return /^([0-9A-F]{2}:){5}[0-9A-F]{2}$/.test(mac)
    }

    function next(mac, name) {
        pageStack.push(Qt.resolvedUrl("ModelSelectionPage.qml"), {
            macAddress: mac,
            bluetoothName: name || "",
            demo: demoSwitch.checked
        })
    }

    Component.onCompleted: refresh()

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: page.refresh()
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: qsTr("Add device")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Pair the headphones in the Bluetooth settings first, then choose them here.")
            }

            SectionHeader { text: qsTr("Paired Bluetooth devices") }

            Repeater {
                model: page.btDevices
                ListItem {
                    id: btItem
                    contentHeight: Theme.itemSizeLarge
                    onClicked: page.next(modelData.address, modelData.name)

                    DeviceTile {
                        id: btTile
                        x: Theme.horizontalPageMargin
                        anchors.verticalCenter: parent.verticalCenter
                        // earbuds/headphones/speaker icon if the name matches a supported model
                        modelId: Strings.guessModel(modelData.name, appWindow.modelNames)
                        highlighted: btItem.highlighted
                    }

                    Column {
                        anchors {
                            left: btTile.right; leftMargin: Theme.paddingLarge
                            right: parent.right; rightMargin: Theme.horizontalPageMargin
                            verticalCenter: parent.verticalCenter
                        }
                        Label {
                            width: parent.width
                            text: modelData.name || modelData.address
                            truncationMode: TruncationMode.Fade
                            color: btItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }
                        Label {
                            text: modelData.address + (modelData.connected ? " · " + qsTr("connected") : "")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: btItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        }
                    }
                }
            }

            Label {
                visible: page.btDevices.length === 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                text: qsTr("No paired Bluetooth devices found.")
            }

            SectionHeader { text: qsTr("Enter manually") }

            TextField {
                id: macField
                width: parent.width
                label: qsTr("MAC address")
                placeholderText: "AA:BB:CC:DD:EE:FF"
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhUppercaseOnly
                validator: RegExpValidator { regExp: /^[0-9A-Fa-f:]{0,17}$/ }
                errorHighlight: text.length > 0 && !page.isValidMac(text.toUpperCase())
                EnterKey.enabled: page.isValidMac(text.toUpperCase())
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: page.next(text.toUpperCase(), "")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Next")
                enabled: page.isValidMac(macField.text.toUpperCase())
                onClicked: page.next(macField.text.toUpperCase(), "")
            }

            SectionHeader { text: qsTr("Options") }

            TextSwitch {
                id: demoSwitch
                text: qsTr("Demo mode")
                description: qsTr("Simulated device, no headphones needed. Useful for testing the app.")
            }
        }

        VerticalScrollDecorator { }
    }
}
