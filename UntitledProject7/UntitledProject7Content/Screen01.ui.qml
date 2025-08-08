import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtWebEngine 1.15
import QtMultimedia
import "html/strudelHost.js" as StrudelHost
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
    property real buttonFontSize: buttonHeight * 0.25
    property real buttonWidth: (width - 2 * margin - 2 * spacing) / 3
    property real panelRadius: margin * 0.5
    property real buttonCorner: buttonHeight * 0.2
    property real bottomButtonWidth: (width - 2 * margin - spacing) / 2

    // === Strudel Web host (invisible) ===
    WebEngineView {
        id: strudelView
        anchors.fill: parent
        visible: false

        // Build data: URL from JS-provided HTML and load it
        Component.onCompleted: {
            var html = StrudelHost.getStrudelHostHtml()
            // Use encodeURIComponent to safely put into data URL
            var dataUrl = "data:text/html;charset=utf-8," + encodeURIComponent(
                        html)
            url = dataUrl
        }

        onLoadingChanged: {
            if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus) {
                console.log("Strudel host loaded")
            } else if (loadRequest.status === WebEngineLoadRequest.LoadFailedStatus) {
                console.warn("Strudel host failed to load:",
                             loadRequest.errorString)
            }
        }

        function playPatternCode(patternCode) {
            runJavaScript(
                        "window.strudelPlayPattern && window.strudelPlayPattern(" + JSON.stringify(
                            patternCode) + ");")
        }
        function stopPattern() {
            runJavaScript("window.strudelStop && window.strudelStop();")
        }
    }

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

        // Animated flip panel (kept as-is)
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
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
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
                    onClicked: animatedFlipable.flipped = !animatedFlipable.flipped
                }
                function reactToHit() {
                    var stops = animatedFlipable.flipped ? backItem.gradient.stops : frontItem.gradient.stops
                    for (var i = 0; i < stops.length; i++)
                        stops[i].color = Qt.hsla(Math.random(), 1, 0.8, 1)
                    animatedFlipable.flipped = !animatedFlipable.flipped
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

            Item {
                id: timelinePanel
                anchors.fill: parent
                property real loopDuration: 5000
                property double startTime: Date.now()
                property var slotStates: [0, 0, 0, 0, 0, 0, 0, 0]
                property real playheadPos: 0.0
                property int lastPlayIndex: -1

                function colorForState(s) {
                    if (s === 0)
                        return "#000000"
                    if (s === 1)
                        return "#FFD700"
                    if (s === 2)
                        return "#FF3B30"
                    return "#000000"
                }

                GridLayout {
                    id: slotGrid
                    anchors.fill: parent
                    columns: 8
                    rows: 1
                    rowSpacing: 0
                    columnSpacing: 0
                    anchors.margins: 0

                    Repeater {
                        id: slotRepeater
                        model: 8
                        Rectangle {
                            id: slotRect
                            property int slotIndex: index
                            color: timelinePanel.colorForState(
                                       timelinePanel.slotStates[slotIndex])
                            border.width: 0
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent ? parent.width / 8 : 40
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var s = timelinePanel.slotStates[slotIndex]
                                    s = (s + 1) % 3
                                    timelinePanel.slotStates[slotIndex] = s
                                    slotRect.color = timelinePanel.colorForState(
                                                s)
                                    if (recordBtn.checked)
                                        timelinePanel.playSlotsArray(
                                                    timelinePanel.slotStates)
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
                        return left + (right - left) * timelinePanel.playheadPos - width / 2
                    }
                    z: 2
                }

                Timer {
                    id: playheadTimer
                    interval: 16
                    repeat: true
                    running: false
                    onTriggered: {
                        var t = (Date.now(
                                     ) - timelinePanel.startTime) % timelinePanel.loopDuration
                        timelinePanel.playheadPos = t / timelinePanel.loopDuration
                        var idx = Math.floor(timelinePanel.playheadPos * 8)
                        idx = Math.max(0, Math.min(7, idx))
                        if (idx !== timelinePanel.lastPlayIndex) {
                            timelinePanel.lastPlayIndex = idx
                        }
                    }
                }

                function buildStrudelSnippetFromSlots(slots) {
                    var tokens = []
                    for (var i = 0; i < slots.length; ++i) {
                        if (slots[i] === 1)
                            tokens.push("c")
                        else if (slots[i] === 2)
                            tokens.push("e")
                        else
                            tokens.push("_")
                    }
                    var seq = "<" + tokens.join(" ") + ">*1"
                    var js = "try{ if (typeof initStrudel === 'function') initStrudel(); note("
                            + JSON.stringify(
                                seq) + ").jux(rev).play(); }catch(e){ console.error('Strudel eval error', e); }"
                    return js
                }

                function playSlotsArray(slots) {
                    var snippet = timelinePanel.buildStrudelSnippetFromSlots(
                                slots)
                    strudelView.playPatternCode(snippet)
                }

                function stopStrudel() {
                    strudelView.stopPattern()
                }

                function scheduleHitAtCurrentPosition() {
                    var t = (Date.now(
                                 ) - timelinePanel.startTime) % timelinePanel.loopDuration
                    var slot = Math.floor(8 * t / timelinePanel.loopDuration)
                    slot = Math.max(0, Math.min(7, slot))
                    var item = slotRepeater.itemAt(slot)
                    if (item && item.advanceState)
                        item.advanceState()
                    else
                        timelinePanel.slotStates[slot] = (timelinePanel.slotStates[slot] + 1) % 3
                }

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

    // Bottom buttons (CLEAR and RECORD)
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

        Item {
            Layout.preferredWidth: bottomButtonWidth
            Layout.maximumWidth: bottomButtonWidth
            Layout.fillHeight: true

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
                text: "CLEAR"
                font.pointSize: buttonFontSize
                onClicked: {
                    timelinePanel.resetAllSlots()
                    if (recordBtn.checked)
                        timelinePanel.playSlotsArray(timelinePanel.slotStates)
                    if (animatedFlipable && animatedFlipable.reactToHit)
                        animatedFlipable.reactToHit()
                }
            }
        }

        Item {
            Layout.preferredWidth: bottomButtonWidth
            Layout.maximumWidth: bottomButtonWidth
            Layout.fillHeight: true

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
                onToggled: {
                    if (checked) {
                        timelinePanel.startTime = Date.now()
                        timelinePanel.lastPlayIndex = -1
                        timelinePanel.playheadPos = 0.0
                        playheadTimer.start()
                        timelinePanel.playSlotsArray(timelinePanel.slotStates)
                    } else {
                        playheadTimer.stop()
                        timelinePanel.lastPlayIndex = -1
                        timelinePanel.stopStrudel()
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
