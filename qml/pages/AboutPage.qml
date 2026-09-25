// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

// About SailSCQ: version, bundled OpenSCQ30 CLI, credits, license, links.
Page {
    id: page

    property string cliVersion: ""

    Component.onCompleted: versionCli.run(["--version"])

    CliRunner {
        id: versionCli
        // output: "openscq30 2.12.0"
        onFinished: if (success) page.cliVersion = output.trim().replace(/^openscq30\s*/, "")
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: qsTr("About SailSCQ") }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                height: width
                sourceSize.width: width
                sourceSize.height: height
                source: "/usr/share/icons/hicolor/172x172/apps/harbour-sailscq.png"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "SailSCQ"
                font.pixelSize: Theme.fontSizeExtraLarge
                font.family: Theme.fontFamilyHeading
                color: Theme.highlightColor
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Version %1").arg(appVersion)
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: qsTr("Control Soundcore headphones, earbuds and speakers: sound modes, noise canceling, equalizer, button configuration, battery levels and more.")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: qsTr("Unofficial app. Not affiliated with Anker or Soundcore.")
            }

            SectionHeader { text: qsTr("OpenSCQ30") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("SailSCQ is a user interface for OpenSCQ30 by Kyle Scheuing. The OpenSCQ30 command line tool, which talks to the headphones, is included in the app unchanged.")
            }

            DetailItem {
                label: qsTr("Included version")
                value: page.cliVersion.length > 0 ? page.cliVersion : "–"
            }

            LinkItem {
                text: qsTr("OpenSCQ30 on GitHub")
                url: "https://github.com/Oppzippy/OpenSCQ30"
            }

            SectionHeader { text: qsTr("License") }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("SailSCQ and OpenSCQ30 are free software under the GNU General Public License, version 3 or later. You may use, share and change them under its terms.")
            }

            LinkItem {
                text: qsTr("GNU General Public License v3")
                onClicked: pageStack.push(Qt.resolvedUrl("LicensePage.qml"))
            }

            LinkItem {
                visible: appWindow.sourceUrl.length > 0
                text: qsTr("Source code of SailSCQ")
                url: appWindow.sourceUrl
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: "© 2026 Denis"
                topPadding: Theme.paddingLarge
            }
        }

        VerticalScrollDecorator { }
    }
}
