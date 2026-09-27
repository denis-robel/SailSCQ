// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

// Step 2: choose the device model and register the device with
// `openscq30 paired-devices add --mac-address … --model … [--demo]`.
Page {
    id: page

    property string macAddress
    property string bluetoothName
    property bool demo: false

    property var models: []          // [{ model, name }]
    property string searchText: ""
    property string errorText: ""

    // Models whose name matches the Bluetooth name are shown first.
    function isSuggested(m) {
        if (!bluetoothName) return false
        var bt = bluetoothName.toLowerCase()
        var name = String(m.name).toLowerCase()
        return bt.indexOf(name) >= 0 || name.indexOf(bt) >= 0
    }

    function filtered() {
        var q = searchText.trim().toLowerCase()
        var suggested = [], rest = []
        for (var i = 0; i < models.length; i++) {
            var m = models[i]
            if (q.length > 0
                    && String(m.name).toLowerCase().indexOf(q) < 0
                    && String(m.model).toLowerCase().indexOf(q) < 0)
                continue
            if (isSuggested(m)) suggested.push(m)
            else rest.push(m)
        }
        return suggested.concat(rest)
    }

    function add(modelId) {
        errorText = ""
        var args = ["paired-devices", "add", "--mac-address", macAddress, "--model", modelId]
        if (demo)
            args.push("--demo")
        addCli.run(args)
    }

    Component.onCompleted: modelsCli.run(["list-models", "--json"])

    CliRunner {
        id: modelsCli
        onFinished: {
            if (success && json && json.length !== undefined)
                page.models = json
            else
                page.errorText = errorOutput
        }
    }

    CliRunner {
        id: addCli
        onFinished: {
            if (success) {
                appWindow.pairedDevicesChanged()
                pageStack.pop(pageStack.find(function(p) {
                    return p.objectName === "deviceSelectionPage"
                }))
            } else {
                page.errorText = qsTr("Could not add device: %1").arg(errorOutput)
            }
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        model: page.filtered()
        currentIndex: -1

        header: Column {
            width: listView.width

            PageHeader {
                title: qsTr("Select model")
                description: page.bluetoothName ? page.bluetoothName + " · " + page.macAddress
                                                : page.macAddress
            }

            SearchField {
                width: parent.width
                placeholderText: qsTr("Search model")
                onTextChanged: page.searchText = text
            }

            Label {
                visible: page.errorText.length > 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: page.errorText
                color: Theme.errorColor
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
            }
        }

        delegate: ListItem {
            id: item
            contentHeight: Theme.itemSizeLarge
            enabled: !addCli.running
            onClicked: page.add(modelData.model)

            DeviceTile {
                id: tile
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                modelId: modelData.model
                highlighted: item.highlighted || page.isSuggested(modelData)
            }

            Column {
                anchors {
                    left: tile.right; leftMargin: Theme.paddingLarge
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    width: parent.width
                    text: modelData.name
                    truncationMode: TruncationMode.Fade
                    color: item.highlighted || page.isSuggested(modelData)
                           ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    text: modelData.model + (page.isSuggested(modelData) ? " · " + qsTr("suggested") : "")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: modelsCli.running || addCli.running
        }

        VerticalScrollDecorator { }
    }
}
