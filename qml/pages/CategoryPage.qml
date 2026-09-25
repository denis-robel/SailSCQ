// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/Strings.js" as Strings

// Shows all settings of one category with generic controls (SettingItem).
Page {
    id: page

    property var session
    property string categoryId

    readonly property var category: session ? session.category(categoryId) : null
    readonly property var settings: category && category.settings ? category.settings : []

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        PullDownMenu {
            busy: page.session.busy
            MenuItem {
                text: qsTr("Refresh")
                onClicked: page.session.refreshValues()
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                title: Strings.name(page.categoryId)
                description: page.session.title
            }

            WarningBanner {
                text: page.session.warning
                onDismissed: page.session.warning = ""
            }

            BusyIndicator {
                visible: running
                running: page.session.loading
                anchors.horizontalCenter: parent.horizontalCenter
                size: BusyIndicatorSize.Medium
            }

            Repeater {
                model: page.session.loading ? [] : page.settings
                SettingItem {
                    width: column.width
                    session: page.session
                    setting: modelData
                }
            }
        }

        ViewPlaceholder {
            enabled: !page.session.loading && page.settings.length === 0
            text: page.session.connected ? qsTr("No settings available") : qsTr("Not connected")
        }

        VerticalScrollDecorator { }
    }
}
