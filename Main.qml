import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import guitar

Window {
    width: 1300
    height: 700
    maximumWidth: 1300
    maximumHeight: 700
    minimumWidth: 1300
    minimumHeight: 700

    visible: true
    color: "#C9F4FA"

    title: qsTr("Guitar Tuner")
    id: window

    function start() {
        begin_animation.start();
    }

    Column {
        id: main_column
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        topPadding: 260
        bottomPadding: 250
        padding: 140
        spacing: 10

        Text {
            id: header
            objectName: "header"

            font.pixelSize: 60
            font.family: "Rockwell"
            //font.bold: true

            text: "ULTRA - GUITAR - \n  SUPER - TUNER"
        }

        Text {
            id: hint

            leftPadding: 140
            font.pointSize: 14

            text: "Powered by: Qt/QML"
            font.family: "Javanese Text"
        }

        Button {
            id: beginButton

            anchors.left: parent.left
            anchors.leftMargin: 195

            //hoverEnabled: true

            width: 350
            height: 100

            onClicked: {
                start()
                main_column.enabled = false
            }

            background: Rectangle {
                anchors.fill: parent

                width: 350
                height: 100

                color: beginButton.down ? "#01a3a4" : "#c7ecee"
                border.color: "#01a3a4"
                radius: 20

                Text {
                    anchors.centerIn: parent

                    color: beginButton.down ? "#c7ecee":"#01a3a4"
                    font.family: "Verdana";
                    font.bold: true
                    font.pixelSize: 40

                    text: "TUNE"
                }
            }
            Rectangle {
                id: wave

                width: beginButton.width
                height: beginButton.height
                radius: 20

                color: "transparent"
                border.color: "#01a3a4"
                anchors.centerIn: parent
            }
        }
        SequentialAnimation {
            id: begin_animation

            SequentialAnimation {
                id: beginButton_animation
                ParallelAnimation {
                    PropertyAnimation {
                        target: wave
                        property: "border.width"
                        from: 3
                        to: 0
                        duration: 300
                    }
                    PropertyAnimation {
                        target: wave
                        property: "width"
                        to: beginButton.width + 45
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        target: wave
                        property: "height"
                        to: beginButton.height + 40
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        target: wave
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 300
                    }
                    PropertyAnimation {
                        target: beginButton
                        property: "opacity"
                        from: 1
                        to: 0
                        easing.type: Easing.InQuint
                        duration: 500
                    }
                    // костыль
                    PropertyAnimation {
                        target: beginButton
                        property: "x"
                        from: 0
                        to: 1
                        easing.type: Easing.InQuint
                        duration: 1200
                    }
                }
            }
            ParallelAnimation {
                id: beginText_animation
                PropertyAnimation {
                    target: header
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 400
                }
                PropertyAnimation {
                    target: header
                    property: "x"
                    to: - 500
                    easing.type: Easing.InOutCubic
                    duration: 600
                }
                PropertyAnimation {
                    target: hint
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 400
                }
                PropertyAnimation {
                    target: hint
                    property: "x"
                    to: - 600
                    easing.type: Easing.InOutCubic
                    duration: 800
                }
            }
        }
    }

    Guitar {
        id: guitar_head
    }

    Rectangle {

        id: head

        width: 580
        height: 300

        // border.width: 2
        // border.color: "black"

        color: "transparent"

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: fill

            fillMode: Image.PreserveAspectFit
            source: guitar_head.getPath()
            anchors.fill: parent
        }
    }

    // Row {
    //     //anchors.fill: parent
    //     padding: 3
    //     spacing: 24

    //     anchors.bottom: head.top
    //     anchors.left: head.left
    //     anchors.leftMargin: 58

    //     Repeater {
    //         model: ["G", "B", "E"]
    //         Rectangle {

    //             height: 50
    //             width: 50

    //             antialiasing: true
    //             radius: 25

    //             color: "white"

    //             border.width: 5
    //             border.color: "black"


    //             Text {
    //                 anchors.centerIn: parent
    //                 text: modelData
    //             }
    //         }
    //     }
    // }

    // // Нижний ряд
    // Row {
    //     //anchors.fill: parent
    //     padding: 3
    //     spacing: 24

    //     anchors.top: head.bottom
    //     anchors.left: head.left
    //     anchors.leftMargin: 58

    //     Repeater {
    //         model: ["D", "A", "E"]
    //         Rectangle {

    //             height: 50
    //             width: 50

    //             antialiasing: true
    //             radius: 25

    //             color: "white"

    //             border.width: 5
    //             border.color: "black"


    //             Text {
    //                 anchors.centerIn: parent
    //                 text: modelData
    //             }
    //         }
    //     }
    // }
}
