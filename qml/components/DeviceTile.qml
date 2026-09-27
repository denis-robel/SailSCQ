// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "Strings.js" as Strings

// Rounded tile with the illustration of a device's form factor
// (earbuds, over-ear headphones, speaker).
// Without modelId a generic Bluetooth icon is shown.
Rectangle {
    id: tile

    property string modelId
    property bool large: false
    property bool highlighted: false

    width: Theme.itemSizeMedium
    height: width
    radius: large ? width / 2 : Theme.paddingMedium
    color: Theme.rgba(Theme.highlightColor, large ? 0.08 : 0.10)

    // Colored illustration (gradient glass look from the mockup), so it is
    // shown as is instead of being tinted with the ambience color.
    Image {
        anchors.centerIn: parent
        visible: tile.modelId.length > 0
        width: parent.width * (tile.large ? 0.74 : 0.72)
        height: width
        sourceSize.width: Math.round(width)
        sourceSize.height: Math.round(height)
        fillMode: Image.PreserveAspectFit
        smooth: true
        opacity: tile.highlighted ? 0.75 : 1.0
        source: visible ? Qt.resolvedUrl("../../images/" + Strings.deviceImage(tile.modelId, tile.large) + ".png") : ""
    }

    Icon {
        anchors.centerIn: parent
        visible: tile.modelId.length === 0
        source: "image://theme/icon-m-bluetooth"
        highlighted: tile.highlighted
    }
}
