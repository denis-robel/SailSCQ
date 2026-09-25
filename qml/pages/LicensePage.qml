// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0

// Full text of the GNU GPL v3 (installed as /usr/share/harbour-sailscq/LICENSE).
Page {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: qsTr("License")
                description: "GNU GPL v3"
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.highlightColor
                textFormat: Text.PlainText
                text: licenseText.length > 0 ? licenseText
                                             : "https://www.gnu.org/licenses/gpl-3.0.html"
            }
        }

        VerticalScrollDecorator { }
    }
}
