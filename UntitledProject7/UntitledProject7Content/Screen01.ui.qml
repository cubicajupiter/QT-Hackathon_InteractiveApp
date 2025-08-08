import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtMultimedia
import UntitledProject7

/*
    Screen01.ui.qml
    Local 8‑step sequencer (no Web / no Strudel).
    States per step:
        0 = rest (black)
        1 = yellow -> play hihat
        2 = red    -> play snare
    (You can change mappings or add bass layering easily inside onStepTrigger())

    Buttons:
        CLEAR  - resets all steps to rest
        RECORD - (toggle) starts/stops looping playhead + audio triggering
*/

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height
    color: "#1A1A22"

    // Layout metrics
    property real margin: width * 0.05
    property real spacing: height * 0.025
    property real safeMargin: height * 0.05
    property real buttonHeight: height * 0.12
    property real buttonFontSize: buttonHeight * 0.25

    property real panelRadius: margin * 0.5
    property real buttonCorner: buttonHeight * 0.2
    property real bottomButtonWidth: (width - 2 * margin - spacing) / 2

    // Sequencer config
    property int steps: 8
    property int loopDurationMs: 4000      // total loop duration (adjust tempo)
    property bool playing: recordBtn.checked

    // Sound assets
    SoundEffect {
        id: hihatFx
        source: "qrc:/qt/qml/UntitledProject7Content/sounds/hihat.wav"
        volume: 0.85
        onStatusChanged: if (status === SoundEffect.Error) console.log("Hihat load error:", errorString)
    }
    SoundEffect {
        id: snareFx
        source: "qrc:/qt/qml/UntitledProject7Content/sounds/snare.wav"
        volume: 0.9
        onStatusChanged: if (status === SoundEffect.Error) console.log("Snare load error:", errorString)
    }
    SoundEffect {
        id: bassFx
        source: "qrc:/qt/qml/UntitledProject7Content/sounds/bass.wav"
        volume: 0.9
        onStatusChanged: if (status === SoundEffect.Error) console.log("Bass load error:", errorString)
    }

    // Root layout (top panels + bottom buttons)
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

        // Decorative animated flip panel (retained)
        Item {
            Layout.row: 0
            Layout.column: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                y: 4
                radius: panelRadius
                color: "#40000000"
            }

            Flipable {
                id: animatedFlipable
                anchors.fill: parent
                transformOrigin: Item.Center
                layer.enabled: true
                layer.smooth: true
                property bool flipped: false
                property real gradientPosition: 0.0

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
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { id: stop1; position: (animatedFlipable.gradientPosition + 0.0) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: stop2; position: (animatedFlipable.gradientPosition + 0.2) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: stop3; position: (animatedFlipable.gradientPosition + 0.4) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: stop4; position: (animatedFlipable.gradientPosition + 0.6) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: stop5; position: (animatedFlipable.gradientPosition + 0.8) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                    }
                }
                back: Rectangle {
                    id: backItem
                    anchors.fill: parent
                    radius: panelRadius
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { id: bstop1; position: (1.0-animatedFlipable.gradientPosition + 0.0) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: bstop2; position: (1.0-animatedFlipable.gradientPosition + 0.2) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: bstop3; position: (1.0-animatedFlipable.gradientPosition + 0.4) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: bstop4; position: (1.0-animatedFlipable.gradientPosition + 0.6) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                        GradientStop { id: bstop5; position: (1.0-animatedFlipable.gradientPosition + 0.8) % 1.0; color: Qt.hsla(Math.random(),0.8,0.5,1); Behavior on color { ColorAnimation { duration:1000 } } }
                    }
                }

                states: [
                    State { name: "back"; when: animatedFlipable.flipped; PropertyChanges { target: animatedFlipable; rotationY: 180 } },
                    State { name: "front"; when: !animatedFlipable.flipped; PropertyChanges { target: animatedFlipable; rotationY: 0 } }
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
                        stop1.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        stop2.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        stop3.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        stop4.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        stop5.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        bstop1.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        bstop2.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        bstop3.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        bstop4.color = Qt.hsla(Math.random(),0.8,0.5,1)
                        bstop5.color = Qt.hsla(Math.random(),0.8,0.5,1)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: animatedFlipable.flipped = !animatedFlipable.flipped
                }

                function reactToHit() {
                    var stops = animatedFlipable.flipped ? backItem.gradient.stops : frontItem.gradient.stops
                    for (var i=0;i<stops.length;i++)
                        stops[i].color = Qt.hsla(Math.random(),1,0.8,1)
                    animatedFlipable.flipped = !animatedFlipable.flipped
                }
            }
        }

        // Sequencer panel
        Item {
            id: sequencerPanel
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

            Item {
                id: timelinePanel
                anchors.fill: parent

                // Per step state array
                property var slotStates: (function(){ var a=[]; for (var i=0;i<steps;i++) a.push(0); return a })()
                property real playheadPos: 0.0
                property int lastPlayIndex: -1
                property double startTime: 0

                function colorForState(s) {
                    if (s === 0) return "#000000"
                    if (s === 1) return "#FFD700"
                    if (s === 2) return "#FF3B30"
                    return "#000000"
                }

                GridLayout {
                    id: slotGrid
                    anchors.fill: parent
                    columns: steps
                    rows: 1
                    rowSpacing: 0
                    columnSpacing: 0
                    Repeater {
                        id: slotRepeater
                        model: steps
                        Rectangle {
                            id: slotRect
                            property int slotIndex: index
                            color: timelinePanel.colorForState(timelinePanel.slotStates[slotIndex])
                            border.width: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent ? parent.width / steps : 40
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var s = timelinePanel.slotStates[slotIndex]
                                    s = (s + 1) % 3
                                    timelinePanel.slotStates[slotIndex] = s
                                    slotRect.color = timelinePanel.colorForState(s)
                                }
                            }

                            function advanceState() {
                                var s = timelinePanel.slotStates[slotIndex]
                                s = (s + 1) % 3
                                timelinePanel.slotStates[slotIndex] = s
                                slotRect.color = timelinePanel.colorForState(s)
                            }
                        }
                    }
                }

                Rectangle {
                    id: playhead
                    width: Math.max(2, parent.width * 0.006)
                    color: "#FF9090"
                    radius: width / 2
                    height: slotGrid.height
                    anchors.top: slotGrid.top
                    anchors.bottom: slotGrid.bottom
                    y: slotGrid.y
                    x: {
                        var left = slotGrid.x
                        var right = slotGrid.x + slotGrid.width
                        left + (right - left) * timelinePanel.playheadPos - width/2
                    }
                    z: 2
                }

                // High-resolution timer to animate playhead & trigger steps
                Timer {
                    id: playTimer
                    interval: 16
                    repeat: true
                    running: false
                    onTriggered: {
                        var t = (Date.now() - timelinePanel.startTime) % loopDurationMs
                        timelinePanel.playheadPos = t / loopDurationMs
                        var idx = Math.floor(timelinePanel.playheadPos * steps)
                        if (idx < 0) idx = 0
                        if (idx >= steps) idx = steps - 1
                        if (idx !== timelinePanel.lastPlayIndex) {
                            timelinePanel.lastPlayIndex = idx
                            onStepTrigger(idx, timelinePanel.slotStates[idx])
                        }
                    }
                }

                function onStepTrigger(i, state) {
                    // Play mapped sounds
                    console.log("Step trigger", i, "state", state,
                                "hihat status", hihatFx.status,
                                "snare status", snareFx.status,
                                "bass status", bassFx.status)
                    switch(state) {
                    case 1: // yellow
                        if (hihatFx.status === SoundEffect.Ready) {
                            console.log("Play hihat")
                            hihatFx.play()
                        } else {
                            console.log("Hihat not ready:", hihatFx.status)
                        }
                        break
                    case 2: // red
                        if (snareFx.status === SoundEffect.Ready) {
                            console.log("Play snare")
                            snareFx.play()
                        } else {
                            console.log("Snare not ready:", snareFx.status)
                        }
                        break
                    default:
                        // no sound
                        break
                    }
                    // Example layering (uncomment to add bass every 4 steps):
                    // if (i % 4 === 0 && state !== 0 && bassFx.status === SoundEffect.Ready) bassFx.play()

                    if (animatedFlipable && animatedFlipable.reactToHit)
                        animatedFlipable.reactToHit()
                }

                function resetAllSlots() {
                    for (var i=0;i<steps;i++) {
                        slotStates[i] = 0
                        var it = slotRepeater.itemAt(i)
                        if (it) it.color = colorForState(0)
                    }
                }

                function start() {
                    startTime = Date.now()
                    lastPlayIndex = -1
                    playheadPos = 0
                    playTimer.start()
                }
                function stop() {
                    playTimer.stop()
                    lastPlayIndex = -1
                }
            }
        }
    }

    // Bottom buttons
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

        // CLEAR
        Item {
            Layout.preferredWidth: bottomButtonWidth
            Layout.maximumWidth: bottomButtonWidth
            Layout.fillHeight: true
            Rectangle { anchors.fill: parent; y: 4; radius: buttonCorner; color: "#50000000"; opacity: 0.7 }
            RoundButton {
                anchors.fill: parent
                radius: buttonCorner
                text: "CLEAR"
                font.pointSize: buttonFontSize
                onClicked: timelinePanel.resetAllSlots()
            }
        }

        // RECORD (toggle playback)
        Item {
            Layout.preferredWidth: bottomButtonWidth
            Layout.maximumWidth: bottomButtonWidth
            Layout.fillHeight: true
            Rectangle { anchors.fill: parent; y: 4; radius: buttonCorner; color: "#50000000"; opacity: 0.7 }
            RoundButton {
                id: recordBtn
                anchors.fill: parent
                radius: buttonCorner
                text: "RECORD"
                checkable: true
                font.pointSize: buttonFontSize * 0.75
                onToggled: {
                    if (checked) {
                        timelinePanel.start()
                    } else {
                        timelinePanel.stop()
                    }
                }
            }
        }
    }
}
