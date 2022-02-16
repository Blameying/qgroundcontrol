import QtQuick 2.15
import QtQuick.Window 2.15

Rectangle {
    anchors.fill: parent
    Rectangle{
        id:rect
        width: parent.width
        height: parent.height * 0.2
        color: "cyan"
        anchors.top: parent.top
        anchors.left: parent.left
    }
}
