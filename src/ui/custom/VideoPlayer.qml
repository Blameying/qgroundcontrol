
import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0

import QGroundControl.ScreenTools  1.0
import QtAV 1.7


Rectangle {
    anchors.fill: parent
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("video, ", player.status);
            my_capture.capture();
        }
    }
}
