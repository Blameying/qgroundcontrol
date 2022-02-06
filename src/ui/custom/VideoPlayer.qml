
import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0

import QGroundControl.ScreenTools  1.0
import QtAV 1.4


Rectangle {
    Video {
        id: video
        autoPlay: false
        anchors.fill:parent
        source: "rtsp://localhost:8554/"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("video, ", video.status);
            video.play();
        }
    }
}
