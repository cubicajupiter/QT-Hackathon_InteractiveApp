
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
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
                anchors.fill: parent
                radius: panelRadius
                color: "#FFFFFF"
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
            }
        }
    }

    states: [
        State {
            name: "clicked"
        }
    ]
}
