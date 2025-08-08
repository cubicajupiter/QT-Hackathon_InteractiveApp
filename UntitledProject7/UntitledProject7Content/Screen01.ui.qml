
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
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: stop2
                            position: (animatedFlipable.gradientPosition + 0.2) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: stop3
                            position: (animatedFlipable.gradientPosition + 0.4) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: stop4
                            position: (animatedFlipable.gradientPosition + 0.6) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: stop5
                            position: (animatedFlipable.gradientPosition + 0.8) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
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
                            position: (1.0 - animatedFlipable.gradientPosition + 0.0) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: bstop2
                            position: (1.0 - animatedFlipable.gradientPosition + 0.2) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: bstop3
                            position: (1.0 - animatedFlipable.gradientPosition + 0.4) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: bstop4
                            position: (1.0 - animatedFlipable.gradientPosition + 0.6) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                        GradientStop {
                            id: bstop5
                            position: (1.0 - animatedFlipable.gradientPosition + 0.8) % 1.0
                            color: Qt.hsla(Math.random(), 0.8, 0.5, 1)
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                }
                            }
                        }
                    }
                }

                states: [
                    State {
                        name: "back"
                        when: animatedFlipable.flipped
                        PropertyChanges {
                            target: animatedFlipable
                            rotationY: 180
                        }
                    },
                    State {
                        name: "front"
                        when: !animatedFlipable.flipped
                        PropertyChanges {
                            target: animatedFlipable
                            rotationY: 0
                        }
                    }
                ]

                transitions: Transition {
                    NumberAnimation {
                        properties: "rotationY"
                        duration: 600
                        easing.type: Easing.InOutQuad
                    }
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
                        animatedFlipable.flipped = !animatedFlipable.flipped
                    }
                }

                function reactToHit() {
                    // Flash effect: brighter colors on the current visible side
                    var stops = animatedFlipable.flipped ? backItem.gradient.stops : frontItem.gradient.stops
                    for (var i = 0; i < stops.length; i++) {
                        stops[i].color = Qt.hsla(Math.random(), 1, 0.8, 1)
                    }

                    // Also trigger a flip when hit
                    animatedFlipable.flipped = !animatedFlipable.flipped
                }
            }
        }
        Item {
            Layout.row: 1
            Layout.column: 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Keep only the shadow rectangle (we remove the filled rectangle behind)
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: panelRadius
                color: "#40000000"
            }

            // ===== REPLACED: no background rectangle — buttons occupy the same field =====
            Item {
                id: timelinePanel
                anchors.fill: parent
                // timing base (used to map current time -> slot when scheduling hits)
                property real loopDuration: 5000
                property double startTime: Date.now()

                // 8 slots, each has a state: 0 = black, 1 = yellow, 2 = red
                property var slotStates: [0, 0, 0, 0, 0, 0, 0, 0]

                // playhead normalized position 0..1
                property real playheadPos: 0.0
                // last integer slot index visited by playhead (used to avoid retrigger)
                property int lastPlayIndex: -1

                // colors map
                function colorForState(s) {
                    if (s === 0)
                        return "#000000"
                    if (s === 1)
                        return "#FFD700" // yellow (gold)
                    if (s === 2)
                        return "#FF3B30" // red
                    return "#000000"
                }

                // hi-hat sound (QtMultimedia SoundEffect)
                SoundEffect {
                    id: hiHat
                    source: Qt.resolvedUrl("sounds/hihat.wav")
                    volume: 0.9
                }

                // --- TILED GRID: no spacing, no margins, tiles fill entire field ---
                GridLayout {
                    id: slotGrid
                    anchors.fill: parent
                    columns: 8
                    rows: 1
                    rowSpacing: 0
                    columnSpacing: 0
                    anchors.margins: 0
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0

                    Repeater {
                        id: slotRepeater
                        model: 8
                        Rectangle {
                            id: slotRect
                            property int slotIndex: index
                            // make tiles fill equally and remove internal margins
                            color: timelinePanel.colorForState(
                                       timelinePanel.slotStates[slotIndex])
                            border.width: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent ? parent.width / 8 : 40
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: 0

                            // No inner shine margin — full-bleed tile look
                            // If you still want thin separators, change border.width above.
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // cycle state 0 -> 1 -> 2 -> 0
                                    var s = timelinePanel.slotStates[slotIndex]
                                    s = (s + 1) % 3
                                    timelinePanel.slotStates[slotIndex] = s
                                    slotRect.color = timelinePanel.colorForState(
                                                s)
                                }
                            }

                            // Expose a method to programmatically advance the state
                            function advanceState() {
                                var s = timelinePanel.slotStates[slotIndex]
                                s = (s + 1) % 3
                                timelinePanel.slotStates[slotIndex] = s
                                slotRect.color = timelinePanel.colorForState(s)
                            }
                        }
                    }
                }

                // visual playhead: a thin vertical line that moves across the slotGrid
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
                        // compute left and right bounds (tiles are full-bleed)
                        var left = slotGrid.x
                        var right = slotGrid.x + slotGrid.width
                        return left + (right - left) * timelinePanel.playheadPos - width / 2
                    }
                    z: 2
                }

                // Timer to update playheadPos based on startTime -> precise loopDuration control.
                // Running when RECORD is active.
                Timer {
                    id: playheadTimer
                    interval: 16 // ~60 FPS
                    repeat: true
                    running: false
                    onTriggered: {
                        var t = (Date.now(
                                     ) - timelinePanel.startTime) % timelinePanel.loopDuration
                        timelinePanel.playheadPos = t / timelinePanel.loopDuration
                        // map to slot index (0..7). When crossing into a new slot, trigger if needed.
                        var idx = Math.floor(timelinePanel.playheadPos * 8)
                        if (idx < 0)
                            idx = 0
                        if (idx > 7)
                            idx = 7
                        if (idx !== timelinePanel.lastPlayIndex) {
                            timelinePanel.lastPlayIndex = idx
                            // play hi-hat only when state === 1 (yellow)
                            if (timelinePanel.slotStates[idx] === 1) {
                                if (hiHat.source)
                                    hiHat.play()
                            }
                        }
                    }
                }

                // Scheduler function used by the existing HIT button:
                // Maps the current phase of the loop to one of the 8 slots and
                // advances that slot's state (cycles).
                function scheduleHitAtCurrentPosition() {
                    var t = (Date.now(
                                 ) - timelinePanel.startTime) % timelinePanel.loopDuration
                    var slot = Math.floor(8 * t / timelinePanel.loopDuration)
                    if (slot < 0)
                        slot = 0
                    if (slot > 7)
                        slot = 7
                    var item = slotRepeater.itemAt(slot)
                    if (item && item.advanceState) {
                        item.advanceState()
                    } else {
                        timelinePanel.slotStates[slot] = (timelinePanel.slotStates[slot] + 1) % 3
                    }
                }

                // Optional utility: reset all slots to black
                function resetAllSlots() {
                    for (var i = 0; i < 8; ++i) {
                        timelinePanel.slotStates[i] = 0
                        var it = slotRepeater.itemAt(i)
                        if (it)
                            it.color = timelinePanel.colorForState(0)
                    }
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

            // Modern elevated button shadow
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#50000000"
                opacity: 0.7
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
                    border.width: 1
                    border.color: "#6E45C1"
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#4A2D91"
                        }
                        GradientStop {
                            position: 1
                            color: "#2A3084"
                        }
                    }
                    // Inner glow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: parent.radius - 1
                        color: "transparent"
                        border.width: 1
                        border.color: "#8061D1"
                        opacity: 0.5
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font {
                        family: parent.font.family
                        pointSize: parent.font.pointSize
                        bold: true
                    }
                    color: "#FFFFFF"
                    opacity: parent.pressed ? 0.8 : 1.0
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    opacity = 0.9
                    scale = 0.97
                }
                onReleased: {
                    opacity = 1.0
                    scale = 1.0
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }
                onClicked: {
                    // Undo: revert last non-black slot to black (simple heuristic)
                    for (var i = 7; i >= 0; --i) {
                        if (timelinePanel.slotStates[i] !== 0) {
                            timelinePanel.slotStates[i] = 0
                            var it = slotRepeater.itemAt(i)
                            if (it)
                                it.color = timelinePanel.colorForState(0)
                            break
                        }
                    }
                    if (animatedFlipable && animatedFlipable.reactToHit)
                        animatedFlipable.reactToHit()
                }
            }
        }

        // HIT
        Item {
            Layout.preferredWidth: buttonWidth
            Layout.maximumWidth: buttonWidth
            Layout.fillHeight: true

            // Modern elevated button shadow
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#50000000"
                opacity: 0.7
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
                    border.width: 1
                    border.color: "#FF6B94"
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#F44362"
                        }
                        GradientStop {
                            position: 1
                            color: "#BA3157"
                        }
                    }
                    // Inner glow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: parent.radius - 1
                        color: "transparent"
                        border.width: 1
                        border.color: "#FF8DA9"
                        opacity: 0.5
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font {
                        family: parent.font.family
                        pointSize: parent.font.pointSize
                        bold: true
                    }
                    color: "#FFFFFF"
                    opacity: parent.pressed ? 0.8 : 1.0
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    opacity = 0.9
                    scale = 0.97
                }
                onReleased: {
                    opacity = 1.0
                    scale = 1.0
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }
                onClicked: {
                    // Use the new scheduler to advance the slot at current loop
                    if (timelinePanel
                            && timelinePanel.scheduleHitAtCurrentPosition) {
                        timelinePanel.scheduleHitAtCurrentPosition()
                    }
                    if (animatedFlipable && animatedFlipable.reactToHit)
                        animatedFlipable.reactToHit()
                }
            }
        }

        // RECORD
        Item {
            Layout.preferredWidth: buttonWidth
            Layout.maximumWidth: buttonWidth
            Layout.fillHeight: true

            // Modern elevated button shadow
            Rectangle {
                anchors.fill: parent
                y: 4
                radius: buttonCorner
                color: "#50000000"
                opacity: 0.7
            }
            RoundButton {
                id: recordBtn
                anchors.fill: parent
                radius: buttonCorner
                text: "RECORD"
                checkable: true
                font.pointSize: buttonFontSize * 0.75
                font.family: "Verdana"
                background: Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    border.width: 1
                    border.color: parent.parent.checked ? "#FF6B6B" : "#6E45C1"
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: parent.parent.checked ? "#F44336" : "#4A2D91"
                        }
                        GradientStop {
                            position: 1
                            color: parent.parent.checked ? "#D32F2F" : "#2A3084"
                        }
                    }
                    // Inner glow effect
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 1
                        radius: parent.radius - 1
                        color: "transparent"
                        border.width: 1
                        border.color: parent.parent.parent.checked ? "#FF8D8D" : "#8061D1"
                        opacity: 0.5
                    }
                }
                contentItem: Text {
                    text: parent.text
                    font {
                        family: parent.font.family
                        pointSize: parent.font.pointSize
                        bold: true
                    }
                    color: "#FFFFFF"
                    opacity: parent.pressed ? 0.8 : 1.0
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onPressed: {
                    opacity = 0.9
                    scale = 0.97
                }
                onReleased: {
                    opacity = 1.0
                    scale = 1.0
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }
                onToggled: {
                    if (checked) {
                        // start loop from now
                        timelinePanel.startTime = Date.now()
                        timelinePanel.lastPlayIndex = -1
                        timelinePanel.playheadPos = 0.0
                        playheadTimer.start()
                    } else {
                        playheadTimer.stop()
                        timelinePanel.lastPlayIndex = -1
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
