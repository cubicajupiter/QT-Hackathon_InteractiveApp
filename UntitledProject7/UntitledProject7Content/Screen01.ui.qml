
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
    color: "#1A1A22" // dark background

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
            // panel with horizontal animated gradient moving from left to right
            Flipable {
                id: animatedFlipable
                anchors.fill: parent
                transformOrigin: Item.Center
                layer.enabled: true
                layer.smooth: true
                property bool flipped: false

                // Property to animate the gradient
                property real gradientPosition: 0.0

                // Number animation to move the gradient
                NumberAnimation on gradientPosition {
                    from: 0.0
                    to: 1.0
                    duration: 5000
                    loops: Animation.Infinite
                }

                front: Rectangle {
                    id: frontItem
                    anchors.fill: parent
                    radius: panelRadius

                    // Create a horizontal gradient
                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        // Create 5 gradient stops that will be animated left to right
                        GradientStop {
                            id: stop1
                            position: (animatedFlipable.gradientPosition + 0.0) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: stop2
                            position: (animatedFlipable.gradientPosition + 0.2) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: stop3
                            position: (animatedFlipable.gradientPosition + 0.4) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: stop4
                            position: (animatedFlipable.gradientPosition + 0.6) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: stop5
                            position: (animatedFlipable.gradientPosition + 0.8) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                    }
                }

                back: Rectangle {
                    id: backItem
                    anchors.fill: parent
                    radius: panelRadius

                    // Create a horizontal gradient for the back side too
                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        // Create 5 gradient stops that will be animated left to right
                        GradientStop {
                            id: bstop1
                            position: (1.0 - animatedFlipable.gradientPosition + 0.0) % 1.0 // Reverse direction
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: bstop2
                            position: (1.0 - animatedFlipable.gradientPosition + 0.2) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: bstop3
                            position: (1.0 - animatedFlipable.gradientPosition + 0.4) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: bstop4
                            position: (1.0 - animatedFlipable.gradientPosition + 0.6) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                        GradientStop {
                            id: bstop5
                            position: (1.0 - animatedFlipable.gradientPosition + 0.8) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color { ColorAnimation { duration: 1000 } }
                        }
                    }
                }

                states: [
                    State {
                        name: "back"
                        when: animatedFlipable.flipped
                        PropertyChanges { target: animatedFlipable; rotationY: 180 }
                    },
                    State {
                        name: "front"
                        when: !animatedFlipable.flipped
                        PropertyChanges { target: animatedFlipable; rotationY: 0 }
                    }
                ]

                transitions: Transition {
                    NumberAnimation { properties: "rotationY"; duration: 600; easing.type: Easing.InOutQuad }
                }

                Timer {
                    id: gradientTimer
                    interval: 2000
                    running: true
                    repeat: true
                    onTriggered: {
                        // Randomly change gradient colors
                        stop1.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        stop2.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        stop3.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        stop4.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        stop5.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)

                        bstop1.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        bstop2.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        bstop3.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        bstop4.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                        bstop5.color = Qt.hsla(Math.random(), 0.8, 0.5, 1)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        animatedFlipable.flipped = !animatedFlipable.flipped;
                    }
                }

                function reactToHit() {
                    // Flash effect: brighter colors on the current visible side
                    var stops = animatedFlipable.flipped ? backItem.gradient.stops : frontItem.gradient.stops;
                    for(var i=0; i<stops.length; i++){
                        stops[i].color = Qt.hsla(Math.random(), 1, 0.8, 1);
                    }

                    // Also trigger a flip when hit
                    animatedFlipable.flipped = !animatedFlipable.flipped;
                }
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
                color: "#222233"

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
                    width: 6
                    radius: 3
                    color: "#FF9090"
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.1
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    x: timelinePanel.playheadX - width/2
                }


                Repeater {
                    id: eventRepeater
                    model: timelinePanel.events.length
                    Rectangle {
                        width: 8
                        radius: 4
                        height: parent.height
                        color: "#CC4CAF50"
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
                onClicked: {
                    if (timelinePanel.events.length > 0) timelinePanel.events.pop();
                    if (animatedFlipable && animatedFlipable.reactToHit) {
                        animatedFlipable.reactToHit();
                    }
                }
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
                onClicked: {
                    timelinePanel.scheduleHitAtCurrentPosition();
                    if (animatedFlipable && animatedFlipable.reactToHit) {
                        animatedFlipable.reactToHit();
                    }
                }
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
