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
import QGroundControl.FlightDisplay 1.0

Rectangle {
    id: _root
    color: Qt.rgba(0, 0, 0, 0)
    height: ScreenTools.defaultFontPixelWidth * 5
    width: dialogModel.count * (ScreenTools.defaultFontPixelWidth * 7)
    
    property var targetParent: undefined;
    property var mother: undefined;

    property var float_components: [
        {"p": targetParent, "obj": secondVideo},
        {"p": targetParent, "obj": thirdVideo},
        {"p": targetParent, "obj": undefined},
        {"p": targetParent, "obj": undefined},
        {"p": targetParent, "obj": undefined},
        {"p": targetParent, "obj": undefined}
        ]    

    SwitchContainer {
        id: secondVideo
        visible: false
        objectName: "secondVideo"
        FlightDisplayViewVideoSecond {
        }

        Timer {
            id:           videoStartDelay
            interval:     2000;
            running:      false
            repeat:       false
            onTriggered:  QGroundControl.customedVideoManager.startVideo()
        }

        onAttachedChanged: {
            console.log("Blame, attached Changed")
            QGroundControl.customedVideoManager.stopVideo();
            videoStartDelay.start()
        }
    }

    SwitchContainer {
        id: thirdVideo
        visible: false
        objectName: "thirdVideo"

        Text {
            text: "样例"
            color: "white"
            anchors.fill: parent
            font.pointSize: ScreenTools.defaultFontPointSize * 3
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment:    Text.AlignHCenter
        }
    }

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
                        if (dialog.visible) {
                            dialog.hide()
                        } else {
                            if (dialog.targetChild && dialog.targetParent) {
                                if (dialog.targetChild.attached) {
                                    dialog.targetChild.attached = false;
                                    dialog.getContentItem(dialog.targetChild, dialog.targetParent, dialog);
                                    dialog.targetParent.parentList -= 1;
                                }
                            }
                            dialog.show()
                        }
                    }
                }

                DialogWindow {
                    id: dialog
                    width: 500
                    height: 300
                    visible: false

                    targetChild: _root.float_components[index]["obj"];
                    targetParent: _root.float_components[index]["p"];

                    Component.onCompleted: {
                        console.log("Blame, switching");
                        dialog.pushItem(targetChild, _root, dialog);
                        if (targetChild !== undefined) {
                            targetChild.attached = false;
                            targetChild.visible = true;
                            if (index === 0) {
                                if (dialog.targetParent !== undefined) {
                                    dialog.pushContentItem(dialog.targetChild, dialog, dialog.targetParent);
                                    dialog.targetChild.attached = true;
                                    dialog.targetParent.parentList += 1;
                                }
                            }
                        }
                    }
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
        objectName: "dialogList";
    }
}
