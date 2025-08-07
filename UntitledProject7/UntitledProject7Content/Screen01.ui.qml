
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtMultimedia
import UntitledProject7

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height
    color: "#F0F0F3" // very light grey

    // Margins & sizing
    property real margin: width * 0.05
    property real spacing: height * 0.025
    property real safeMargin: height * 0.05
    property real buttonHeight: height * 0.12
    property real buttonFontSize: buttonHeight * 0.45
    property real buttonWidth: (width - 2 * margin - 2 * spacing) / 3
    property real panelRadius: margin * 0.5
    property real buttonCorner: buttonHeight * 0.2

    // === Top panels with manual shadow ===
    GridLayout {
        id: topGrid
        anchors {
            top: parent.top
            topMargin: margin + safeMargin
            left: parent.left
            leftMargin: margin
            right: parent.right
            rightMargin: margin
            bottom: buttonRow.top
            bottomMargin: margin
        }
        columns: 1
        rows: 2
        rowSpacing: spacing

        Item {
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            // shadow
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: panelRadius
                color: "#40000000"
            }
            // panel
            Rectangle {
                anchors.fill: parent
                radius: panelRadius
                color: "#FFFFFF"
            }
        }
        Item {
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: panelRadius
                color: "#40000000"
            }
            Rectangle {
                id: timelinePanel
                anchors.fill: parent
                radius: panelRadius
                color: "#FFFFFF"

                property real loopDuration: 5000
                property real playheadX: (width * ((Date.now() - startTime) % loopDuration) / loopDuration)
                property double startTime: Date.now()
                property var events: []

                Timer {
                    id: playheadTimer
                    interval: 16
                    repeat: true
                    running: false
                    onTriggered: timelinePanel.playheadX = (timelinePanel.width * ((Date.now() - timelinePanel.startTime) % timelinePanel.loopDuration) / timelinePanel.loopDuration)
                }

                Rectangle {
                    id: playhead
                    width: 3
                    radius: 1.5
                    color: "#FF5252"
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    x: timelinePanel.playheadX - width/2
                }


                Repeater {
                    id: eventRepeater
                    model: timelinePanel.events.length
                    Rectangle {
                        width: 8
                        radius: 4
                        height: parent.height
                        color: "#884CAF50"
                        x: timelinePanel.width * (timelinePanel.events[index] / timelinePanel.loopDuration) - width/2
                    }
                }

                SoundEffect {
                    id: hiHat
                    source: Qt.resolvedUrl("sounds/hihat.wav")
                }

                function scheduleHitAtCurrentPosition() {
                    const t = (Date.now() - timelinePanel.startTime) % timelinePanel.loopDuration
                    timelinePanel.events.push(t)
                }

                function processPlayback() {
                    const now = (Date.now() - timelinePanel.startTime) % timelinePanel.loopDuration
                    for (let i = 0; i < timelinePanel.events.length; ++i) {
                        const et = timelinePanel.events[i]
                        const diff = now - et
                        if (diff >= 0 && diff < playheadTimer.interval) {
                            hiHat.play()
                        }
                    }
                }

                Timer {
                    id: playbackTimer
                    interval: 5
                    repeat: true
                    running: false
                    onTriggered: timelinePanel.processPlayback()
                }
            }
        }
    }

    // === Bottom: three rectangular buttons with manual shadow ===
    RowLayout {
        id: buttonRow
        anchors {
            left: parent.left
            leftMargin: margin
            right: parent.right
            rightMargin: margin
            bottom: parent.bottom
            bottomMargin: margin
        }
        spacing: spacing
        height: buttonHeight

        // UNDO
        Item {
            Layout.preferredWidth: buttonWidth
            Layout.maximumWidth: buttonWidth
            Layout.fillHeight: true

            // button shadow
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#30000000"
            }
            // button
            RoundButton {
                anchors.fill: parent
                radius: buttonCorner
                text: "UNDO"
                font.pointSize: buttonFontSize
                font.family: "Verdana"
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#5E35B1"
                        }
                        GradientStop {
                            position: 1
                            color: "#3949AB"
                        }
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: opacity = 0.7
                onReleased: opacity = 1.0
                onClicked: if (timelinePanel.events.length > 0) timelinePanel.events.pop()
            }
        }

        // HIT
        Item {
            Layout.preferredWidth: buttonWidth
            Layout.maximumWidth: buttonWidth
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#30000000"
            }
            RoundButton {
                anchors.fill: parent
                radius: buttonCorner
                text: "HIT"
                font.pointSize: buttonFontSize
                font.family: "Verdana"
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#5E35B1"
                        }
                        GradientStop {
                            position: 1
                            color: "#3949AB"
                        }
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: opacity = 0.7
                onReleased: opacity = 1.0
                onClicked: timelinePanel.scheduleHitAtCurrentPosition()
            }
        }

        // RECORD
        Item {
            Layout.preferredWidth: buttonWidth
            Layout.maximumWidth: buttonWidth
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#30000000"
            }
            RoundButton {
                anchors.fill: parent
                radius: buttonCorner
                text: "RECORD"
                checkable: true
                font.pointSize: buttonFontSize * 0.75
                font.family: "Verdana"
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#5E35B1"
                        }
                        GradientStop {
                            position: 1
                            color: "#3949AB"
                        }
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: opacity = 0.7
                onReleased: opacity = 1.0
                onToggled: {
                    if (checked) {
                        timelinePanel.startTime = Date.now()
                        playheadTimer.running = true
                        playbackTimer.running = true
                    } else {
                        playheadTimer.running = false
                        playbackTimer.running = false
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "clicked"
        }
    ]
}
