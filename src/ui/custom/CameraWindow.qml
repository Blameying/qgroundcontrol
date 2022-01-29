import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0

Window {
    id: root
    minimumWidth:   ScreenTools.isMobile ? Screen.width  : Math.min(ScreenTools.defaultFontPixelWidth * 100, Screen.width)
    minimumHeight:  ScreenTools.isMobile ? Screen.height : Math.min(ScreenTools.defaultFontPixelWidth * 50, Screen.height)
    visible: false
    flags: Qt.Window
    modality: Qt.NonModal

    property string source: "";

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 1)

        Loader {
            anchors.fill: parent
            source: root.source
        }
    }
}
