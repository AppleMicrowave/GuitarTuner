import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Basic

import guitar
import Audi

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
        grid.visible = true;
        grid_animation.start();
        topRow.visible = true;
        bottomRow.visible = true;
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

    }

    Guitar {
        id: guitar_head
    }

    AudioManager {
        id: audioManager
    }

    Rectangle {
        id: left_synchroline
        width: 0
        height: 2
        color: "black"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

    }
    Rectangle {
        id: right_synchroline
        width: 0
        height: 2
        color: "black"
        anchors.right: head.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: grid
        visible: false

        width: 560
        height: 500

        x: 100

        opacity: 0
        color: "transparent"

        Repeater {
            model: grid.width / 20
            Rectangle {
                width: 1
                height: grid.height
                color: "black"

                opacity: {
                    var centerX = parent.width / 2;
                    var distance = Math.abs(x - centerX);
                    return 1.0 - distance / (parent.width / 2) - 0.2; // Прозрачность ближе к краям
                }

                x: index * 20
            }
        }

        Repeater {
            model: grid.height / 20
            Rectangle {
                width: grid.width
                height: 1
                color: "black"

                opacity: {
                   var centerY = parent.height / 2;
                   var distance = Math.abs(y - centerY);
                   return 1.0 - distance / (parent.height / 2) - 0.2; // Прозрачность ближе к краям
               }

                x: (grid.width - width) / 2
                y: index * 20
            }
        }
    }

    Rectangle {
        id: centerWidget

        width: 50
        height: 50
        radius: 25
        color: "grey"

        x: 345
        y: audioManager.getCurrentFrequency()

        border.color: "black"
        border.width: 2

        transformOrigin: Item.Center


        scale: 0

        Rectangle {
            id: wave_mid

            width: centerWidget.width
            height: centerWidget.height
            radius: 60

            color: "transparent"
            border.color: "black"
            border.width: 1
            anchors.centerIn: parent
        }

        // SequentialAnimation on y {
        //     loops: Animation.Infinite
        //     NumberAnimation { to: 500; duration: 2000; easing.type: Easing.InOutQuad }
        //     NumberAnimation { to: 200; duration: 2000; easing.type: Easing.InOutQuad }
        // }
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
                    duration: 600
                }
                // костыль
                PropertyAnimation {
                    target: beginButton
                    property: "x"
                    from: 0
                    to: 1
                    easing.type: Easing.InQuint
                    duration: 800
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
        SequentialAnimation {
            id: synchroline_animation

            // линии
            ParallelAnimation {
                PropertyAnimation {
                    target: left_synchroline
                    property: "width"
                    from: 0
                    to: 361
                    duration: 800
                    easing.type: Easing.InCubic
                }
                PropertyAnimation {
                    target: right_synchroline
                    property: "width"
                    from: 0
                    to: 361
                    duration: 800
                    easing.type: Easing.InCubic
                }
            }
            ParallelAnimation {
                // волна "Герцера"
                PropertyAnimation {
                    target: wave_mid
                    property: "width"
                    to: centerWidget.width + 30
                    duration: 250
                    easing.type: Easing.OutExpo
                }
                PropertyAnimation {
                    target: wave_mid
                    property: "height"
                    to: centerWidget.height + 30
                    duration: 250
                    easing.type: Easing.OutExpo
                }
                PropertyAnimation {
                    target: wave_mid
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 300
                }

                PropertyAnimation {
                    target: centerWidget
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    target: centerWidget
                    property: "scale"
                    from: 0
                    to: 1
                    duration: 200
                    easing.type: Easing.InOutBack
                }
            }
            PropertyAnimation {
                target: grid
                property: "opacity"
                from: 0
                to: 0.3
                easing.type: Easing.InOutCubic
                duration: 800
            }
            ParallelAnimation {
                PropertyAnimation {
                    target: topRow
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 1000
                }
                PropertyAnimation {
                    target: bottomRow
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 1000
                }
            }
        }
        onFinished: {
            audioManager.captureAudio()
        }
    }
    PropertyAnimation {
        id: grid_animation

        target: grid
        property: "x"
        from: grid.x
        to: (grid.x) -20
        duration: 2000

        loops: Animation.Infinite
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

    Row {
        id: topRow
        visible: false

        padding: 3
        spacing: 21

        opacity: 0

        anchors.bottom: head.top
        anchors.left: head.left
        anchors.leftMargin: 55

        Repeater {
            model: ["G", "B", "E"]
            Rectangle {

                height: 50
                width: 50

                antialiasing: true
                radius: 25

                color: "white"

                border.width: 5
                border.color: "black"


                Text {
                    anchors.centerIn: parent
                    text: modelData
                }
            }
        }
    }

    // Нижний ряд
    Row {
        id: bottomRow

        padding: 3
        spacing: 21

        opacity: 0

        anchors.top: head.bottom
        anchors.left: head.left
        anchors.leftMargin: 55

        Repeater {
            model: ["D", "A", "E"]
            Rectangle {

                height: 50
                width: 50

                antialiasing: true
                radius: 25

                color: "white"

                border.width: 5
                border.color: "black"


                Text {
                    anchors.centerIn: parent
                    text: modelData
                }
            }
        }
    }
}
