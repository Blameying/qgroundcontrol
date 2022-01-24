import QtQuick                    2.0
import QtQuick.Controls           2.0
import QtQuick.Window             2.0
import QtGraphicalEffects         1.0

import QGroundControl             1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controls    1.0
import QGroundControl.Palette     1.0
import QGroundControl.FactSystem  1.0
import QGroundControl.Custom      1.0

Rectangle {
    color: Qt.rgba(0, 0, 0, 0)
    height: ScreenTools.defaultFontPixelWidth * 5
    width: dialogModel.count * (ScreenTools.defaultFontPixelWidth * 7)

    ListModel{
        id: dialogModel;
        ListElement{
            name: "Home";
            icon: "/InstrumentValueIcons/camera.svg";
        }
        ListElement{
            name: "Profile";
            icon: "/res/radar.svg";
        }
        ListElement{
            name: "Message";
            icon: "/res/radar.svg";
        }
        ListElement{
            name: "Help";
            icon: "/res/radar.svg";
        }
        ListElement{
            name: "Setting";
            icon: "/res/radar.svg";
        }
        ListElement{
            name: "Sign Out";
            icon: "/res/radar.svg";
        }
    }

    Component {
        id: circleButton
        Rectangle {
            width: leftSpace.width * 2 + contentSpace.width
            height: parent.height
            color: Qt.rgba(0, 0, 0, 0)
            Rectangle {
                id: leftSpace
                color: parent.color
                width: ScreenTools.defaultFontPixelWidth
                height: parent.height
                anchors.left: parent.left
                anchors.top: parent.top
            }
            Rectangle{
                id: contentSpace
                width: ScreenTools.defaultFontPixelWidth * 5;
                height: width;
                radius: width/2;
                color: "#FFFFFF";
                anchors.left: leftSpace.right
                anchors.top: parent.top
                property bool showed: false

                Image {
                    id: _image
                    anchors.fill: parent
                    smooth: true
                    source: icon;
                    sourceSize: Qt.size(parent.size, parent.size)
                    clip: true
                    antialiasing: true
                    visible: false
                }
                Rectangle {
                    id: _mask
                    color: parent.color
                    anchors.fill: parent
                    radius: width/2
                    visible: false
                    antialiasing: true
                    smooth: true
                }
                OpacityMask {
                    id: mask_image
                    anchors.fill: _image
                    source: _image
                    maskSource: _mask
                    visible: true
                    antialiasing: true
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        if (parent.showed) {
                            dialog.hide()
                            parent.showed = false
                        }
                        else {
                            dialog.show()
                            parent.showed = true
                        }
                    }
                }

                CameraWindow {
                    id: dialog
                    width: 500
                    height: 300
                    visible: false
                }
            }
            Rectangle{
                id: rightSpace
                color: parent.color
                width: ScreenTools.defaultFontPixelWidth
                height: parent.height
                anchors.left: contentSpace.right
                anchors.top: parent.top
            }
        }
    }

    QGCListView {
        id: appList;
        orientation: ListView.Horizontal
        anchors.fill: parent
        model: dialogModel;
        delegate: circleButton;
        clip: true
    }
}
