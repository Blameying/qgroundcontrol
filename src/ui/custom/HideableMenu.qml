import QtQuick                    2.6
import QtQuick.Controls           2.0
import QtQuick.Window             2.0
import QtQml 2.15
import QtGraphicalEffects         1.0

import QGroundControl             1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controls    1.0
import QGroundControl.Palette     1.0
import QGroundControl.FactSystem  1.0

Rectangle{
    //显示区域的颜色背景

    color: Qt.rgba(0,0,0,0)
    property int switchButtonWidth: 4

    QGCPalette {
        id:                 qgcPal  // Note how id does not use an underscore
        colorGroupEnabled:  enabled
    }

    property bool unfold: false;
    property int normalWidth: ScreenTools.defaultFontPixelWidth * 6;
    property string icon_color: "#f9f9f9";
    property string icon_underline_color: "#ffffff";
    property string icon_hovered_color: "#e5e5e5"
    property string icon_chosed_color: "#ffffb3"

    Behavior on width{
        NumberAnimation{duration: 300;}
    }

    Rectangle{
        id: barRect;
        width: unfold? normalWidth : 0
        height: parent.height;
        anchors.top: parent.top
        anchors.left: parent.left
        color: icon_color;
        clip: true;

        Behavior on width{
            NumberAnimation{duration: 300;}
        }
        ListModel{
            id: appModel;
            ListElement{
                name: "航行信息";
                icon: "/res/sail_info.svg";
                icon_deep: "/res/sail_info_deep.svg"
                source: "subPageSailInfo.qml"
            }
            ListElement{
                name: "主摄像";
                icon: "/res/main_camera.svg";
                icon_deep: "/res/main_camera_deep.svg"
                source: "subPageCamera.qml"
            }
            ListElement{
                name: "副摄像";
                icon: "/res/second_camera.svg";
                icon_deep: "/res/second_camera_deep.svg"
                source: "subPageCamera.qml"
            }
            ListElement{
                name: "调参";
                icon: "/res/parameters.svg";
                icon_deep: "/res/parameters_deep.svg"
                source: "subPageParameter.qml"
            }
            ListElement{
                name: "系统";
                icon: "/res/system.svg";
                icon_deep: "/res/system_deep.svg"
                source: "subPageSystemSetting.qml"
            }
        }

        Component{
            id: appDelegate;
            Rectangle {
                id: delegateBackground;
                width: normalWidth;
                height: width;
                
                Binding on color {
                    value: appList.chosed_index == index ? icon_chosed_color : icon_color;
                }

                property bool entered: false;

                ToolTip.visible: entered;
                ToolTip.delay: 1000;
                ToolTip.text: name;


				//显示图标
                Image {
                    id: imageIcon;
                    width: parent.width * 0.8;
                    height: width;
                    fillMode: Image.Stretch
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    Binding on source {
                        value: appList.chosed_index == index? icon_deep : icon;
                    }
                }
                // 底部下划线
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: 1
                    color: icon_underline_color
                }
				//鼠标处理
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onEntered: {
                        if (!(appList.chosed_index == index)) {
                            delegateBackground.color = icon_hovered_color;
                            imageIcon.source = icon_deep;
                        }
                        parent.entered = true;
                    }
                    onExited: {
                        if (!(appList.chosed_index == index))
                        {
                            imageIcon.source = icon;
                            delegateBackground.color = icon_color;
                        }
                        parent.entered = false;
                    }
                    onClicked: {
                        appList.chosed_index = index;
                        pageContent.source = source;
                    }
                }

                Component.onCompleted: {
                    if (appList.chosed_index == index) {
                        pageContent.source = source;
                    }
                }
            }
        }

        QGCListView {
            id: appList;
            anchors.fill: parent
            model: appModel;
            delegate: appDelegate;
            clip: true

            property int chosed_index: 0;
        }
    }

    Loader {
        id: pageContent
        width: parent.width - barRect.width - switchButton.width
        height: parent.height
        anchors.left: barRect.right
        anchors.top: parent.top
    }

    // 展开/收回按钮
    Rectangle{
        id: switchButton
        width: ScreenTools.defaultFontPixelWidth * switchButtonWidth;
        height: width;
        radius: width/2;
        z: QGroundControl.zOrderTopMost
        color: icon_color;
        border.color: qgcPal.colorGreen;
        border.width: 1;
        anchors.left: pageContent.right;
        anchors.leftMargin: -width/2;
        anchors.verticalCenter: barRect.verticalCenter;
        Image {
            width: parent.width * 0.5;
            height: width;
            mipmap: true;
            anchors.centerIn: parent;
			//此处使用旋转180度实现展开按钮图标和收回按钮图标
            rotation: unfold? 180:0;
            source: "/res/arrow_right.svg";
        }

        MouseArea{
            anchors.fill: parent;
            onClicked: {
                unfold = !unfold;
            }
        }
    }
}
