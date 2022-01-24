import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 500
    height: 1080

    TextField {
        background: Item {
            implicitWidth: 100
            implicitHeight: 40
            Rectangle {
                height: 3
                width: parent.width
                color: "#000000"
                anchors.bottom: parent.bottom
            }
        }
    }
}
