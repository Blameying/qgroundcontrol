
import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0
import QtMultimedia               5.15

import QGroundControl.ScreenTools  1.0
import VlcPlayer 1.1
import Vlc 1.1
import VlcVideoOutput 1.1


Rectangle {
    VlcVideoOutput {
        anchors.fill: parent
        source: VlcPlayer {
            id: videoPlayer
            url: "rtsp://localhost:8554/"
        }
    }

    MouseArea {
        anchors.fill: videoPlayer
        onClicked: {
            console.log("Blame: ", videoPlayer.status)
        }
    }
}
