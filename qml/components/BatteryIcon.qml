// SPDX-FileCopyrightText: 2026 Denis Robel
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import Sailfish.Silica 1.0

// Battery graphic: body with terminal, filled according to the level.
// Devices that report few steps (e.g. 5) get one segment per step.
// While charging a bolt is shown and the next segment pulses.
Item {
    id: battery

    property int level: 0        // reported level, e.g. 4
    property int steps: 5        // number of levels the device reports, e.g. 5
    property int percent: 0      // 0..100
    property bool charging: false

    readonly property bool segmented: steps > 1 && steps <= 10
    readonly property color fillColor: percent <= 20 ? Theme.errorColor : Theme.highlightColor
    readonly property real stroke: Math.max(2, Math.round(Theme.paddingSmall / 2))

    width: Theme.itemSizeMedium * 1.2
    height: Math.round(width * 0.46)

    // ---- body ------------------------------------------------------------
    Rectangle {
        id: body
        width: parent.width - nub.width - battery.stroke
        height: parent.height
        radius: height * 0.2
        color: Theme.rgba(Theme.primaryColor, 0.06)
        border.width: battery.stroke
        border.color: Theme.rgba(Theme.primaryColor, 0.75)

        Item {
            id: inner
            anchors.fill: parent
            anchors.margins: battery.stroke * 2

            // one block per reported step
            Row {
                visible: battery.segmented
                anchors.fill: parent
                spacing: battery.stroke

                Repeater {
                    model: battery.segmented ? battery.steps : 0
                    Rectangle {
                        id: segment
                        readonly property bool filled: index < battery.level
                        readonly property bool next: battery.charging && index === battery.level
                        width: (inner.width - (battery.steps - 1) * battery.stroke) / battery.steps
                        height: inner.height
                        radius: Math.min(width, height) * 0.2
                        color: filled || next ? battery.fillColor : Theme.rgba(Theme.primaryColor, 0.12)

                        // the segment that is being charged pulses
                        SequentialAnimation on opacity {
                            running: segment.next && Qt.application.active
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.15; to: 0.9; duration: 900; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 0.9; to: 0.15; duration: 900; easing.type: Easing.InOutQuad }
                            onRunningChanged: if (!running) segment.opacity = 1.0
                        }
                    }
                }
            }

            // continuous fill for devices with fine-grained levels (e.g. 100 steps)
            Rectangle {
                visible: !battery.segmented
                width: inner.width * Math.max(0, Math.min(100, battery.percent)) / 100
                height: inner.height
                radius: Math.min(width, height) * 0.2
                color: battery.fillColor
            }
        }

        // ---- charging bolt -----------------------------------------------
        Canvas {
            id: bolt
            visible: battery.charging
            anchors.centerIn: parent
            height: parent.height * 0.82
            width: height * 0.62

            property color fill: Theme.primaryColor
            property color outline: Theme.rgba(Theme.overlayBackgroundColor || "#000000", 0.85)
            onFillChanged: requestPaint()
            onOutlineChanged: requestPaint()
            onVisibleChanged: if (visible) requestPaint()
            onWidthChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.reset()
                ctx.beginPath()
                ctx.moveTo(w * 0.62, 0)
                ctx.lineTo(w * 0.08, h * 0.56)
                ctx.lineTo(w * 0.46, h * 0.56)
                ctx.lineTo(w * 0.34, h)
                ctx.lineTo(w * 0.92, h * 0.40)
                ctx.lineTo(w * 0.54, h * 0.40)
                ctx.closePath()
                ctx.lineJoin = "round"
                ctx.lineWidth = Math.max(2, w * 0.1)
                ctx.strokeStyle = outline
                ctx.stroke()
                ctx.fillStyle = fill
                ctx.fill()
            }
        }
    }

    // ---- terminal ----------------------------------------------------------
    Rectangle {
        id: nub
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        width: battery.stroke * 2
        height: parent.height * 0.38
        radius: width / 2
        color: Theme.rgba(Theme.primaryColor, 0.75)
    }
}
