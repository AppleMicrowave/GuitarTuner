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

            font.pixelSize: 60
            font.family: "Rockwell"
            //font.bold: true

            text: "ULTRA - GUITAR - \n  SUPER - TUNER"
        }

        Text {
            leftPadding: 140
            font.pointSize: 14

            text: "Powered by: Qt/QML"
            font.family: "Javanese Text"
        }

        Button {
            id: btn

            anchors.left: parent.left
            anchors.leftMargin: 195

            //hoverEnabled: true

            width: 350
            height: 100


            background: Rectangle {
                anchors.fill: parent

                width: 350
                height: 100

                color: btn.down ? "#01a3a4" : "#c7ecee"
                border.color: "#01a3a4"
                radius: 20

                Text {
                    anchors.centerIn: parent

                    color: btn.down ? "#c7ecee":"#01a3a4"
                    font.family: "Verdana";
                    font.bold: true
                    font.pixelSize: 40

                    text: "TUNE"
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
            fillMode: Image.PreserveAspectFit
            source: guitar_head.getPath()
            anchors.fill: parent
        }
    }


    // Верхний ряд
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
