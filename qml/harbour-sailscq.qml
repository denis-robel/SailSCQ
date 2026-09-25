// SPDX-FileCopyrightText: 2026 Denis
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "components"

ApplicationWindow {
    id: appWindow

    // Address of the SailSCQ source code (shown on the About page, hidden while empty).
    // TODO: set to your repository, e.g. "https://github.com/<name>/sailscq"
    readonly property string sourceUrl: ""

    // model id -> English model name, filled from `openscq30 list-models --json`
    property var modelNames: ({})

    // Last opened device, remembered across app starts (used by the cover).
    property string lastMacAddress: openscq30.loadSetting("lastDevice/macAddress", "")
    property string lastModelId: openscq30.loadSetting("lastDevice/modelId", "")

    // Session of an open DevicePage; takes precedence over the background session.
    property var pageSession: null

    // Session the cover shows and controls.
    readonly property var currentSession: pageSession ? pageSession
                                        : (lastMacAddress.length > 0 ? backgroundSession : null)

    // Set once the last device was opened automatically at start.
    property bool autoOpenDone: false

    signal pairedDevicesChanged()
    // The automatically opened device could not be reached.
    signal autoConnectFailed(string title, string error)

    function modelName(modelId) {
        return modelNames[modelId] || modelId
    }

    function rememberDevice(macAddress, modelId) {
        lastMacAddress = macAddress
        lastModelId = modelId
        openscq30.saveSetting("lastDevice/macAddress", macAddress)
        openscq30.saveSetting("lastDevice/modelId", modelId)
    }

    function forgetDevice(macAddress) {
        if (macAddress !== lastMacAddress)
            return
        rememberDevice("", "")
    }

    // Used by the cover while no DevicePage is open. It only connects when
    // the cover is shown (see CoverPage), not at app start.
    DeviceSession {
        id: backgroundSession
        macAddress: appWindow.lastMacAddress
        modelId: appWindow.lastModelId
        title: appWindow.modelName(appWindow.lastModelId)
    }

    initialPage: Component { DeviceSelectionPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
