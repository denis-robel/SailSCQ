// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0

// Dismissable warning shown at the top of a page.
BackgroundItem {
    id: banner

    property string text

    signal dismissed()

    visible: text.length > 0
    width: parent ? parent.width : Screen.width
    height: visible ? label.height + 2 * Theme.paddingMedium : 0
    onClicked: dismissed()

    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(Theme.errorColor, 0.15)
    }

    Label {
        id: label
        x: Theme.horizontalPageMargin
        y: Theme.paddingMedium
        width: parent.width - 2 * Theme.horizontalPageMargin - closeIcon.width
        text: banner.text
        wrapMode: Text.Wrap
        color: Theme.errorColor
        font.pixelSize: Theme.fontSizeSmall
    }

    Icon {
        id: closeIcon
        anchors {
            right: parent.right; rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }
        source: "image://theme/icon-s-clear-opaque-cross"
    }
}
