import QtQuick                    2.15
import QtQuick.Controls           2.15

Slider {
    id: control
    snapMode: Slider.SnapOnRelease
    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
        Text {
            anchors.bottom: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 5
            visible: true
            text: control.value
        }
    }
}
