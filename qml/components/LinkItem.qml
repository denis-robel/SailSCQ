// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0

// Full-width row with a label; opens `url` in the browser if set,
// otherwise just emits clicked().
BackgroundItem {
    id: item

    property alias text: label.text
    property string url

    width: parent ? parent.width : Screen.width
    height: Math.max(Theme.itemSizeSmall, label.height + 2 * Theme.paddingMedium)
    onClicked: if (url.length > 0) Qt.openUrlExternally(url)

    Label {
        id: label
        anchors {
            left: parent.left; leftMargin: Theme.horizontalPageMargin
            right: icon.left; rightMargin: Theme.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        wrapMode: Text.Wrap
        color: item.highlighted ? Theme.highlightColor : Theme.primaryColor
    }

    Icon {
        id: icon
        anchors {
            right: parent.right; rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }
        source: item.url.length > 0 ? "image://theme/icon-m-link" : "image://theme/icon-m-right"
        highlighted: item.highlighted
    }
}
