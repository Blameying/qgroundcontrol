import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Controls.Styles    1.4
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0
import QtGraphicalEffects         1.12

import QGroundControl.ScreenTools  1.0

Rectangle {
    color: "#dadada"
    ScrollView {
        id: scroll_root
        anchors.fill: parent
        clip: true
        contentWidth: width

        property string font_color: "#000000";
        property real common_border_width: 0.1;

        Column {
            spacing: ScreenTools.defaultFontPixelHeight
            anchors.fill: parent
            Rectangle {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                anchors.left: parent.left
                anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                anchors.right: parent.right
                anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
                width: parent.width - anchors.rightMargin * 2;
                Column {
                    width: (parent.width - parent.spacing) / 2
                    Label {
                        id: label1;
                        color: scroll_root.font_color;
                        text: "基站坐标";
                        horizontalAlignment: Text.AlignCenter;
                        verticalAlignment: Text.AlignVCenter;
                        width: parent.width
                        height: ScreenTools.defaultFontPixelHeight * 2;
                        renderType: Text.NativeRendering;
                    }
                    TextArea {
                        text: "0\n0"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        enabled: false
                        width: parent.width
                        height: ScreenTools.defaultFontPixelHeight * 3;
                        renderType: Text.NativeRendering
                        background: Rectangle {
                            border.color: scroll_root.font_color
                            border.width: scroll_root.common_border_width
                        }
                    }
                }
                Column {
                    width: ((parent.width - parent.spacing) / 2)
                    Label {
                        id: label2
                        color: scroll_root.font_color
                        text: "相对坐标"
                        horizontalAlignment: Text.AlignLeft;
                        verticalAlignment: Text.AlignVCenter;
                        width: parent.width;
                        height: ScreenTools.defaultFontPixelHeight * 2;
                        renderType: Text.NativeRendering;
                    }
                    TextArea {
                        text: "0\n0"
                        horizontalAlignment: Text.AlignHCenter;
                        verticalAlignment: Text.AlignVCenter;
                        enabled: false
                        width: parent.width
                        height: ScreenTools.defaultFontPixelHeight * 3;
                        renderType: Text.NativeRendering;
                        background: Rectangle {
                            border.color: scroll_root.font_color
                            border.width: scroll_root.common_border_width
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            Grid {
                id: grid
                columns: 4
                Layout.alignment: Qt.AlignCenter
                horizontalItemAlignment: Qt.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2

                property real item_height: ScreenTools.defaultFontPixelHeight * 2;
                property real item_width: ScreenTools.defaultFontPixelWidth * 6;
                Text {
                    id: tag;
                    text: "横滚角";
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: rollAngle
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
                Text {
                    text: "俯仰角";
                    horizontalAlignment: Text.AlignHCenter;
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: pitchAngle
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
                Text {
                    text: "航向角"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: headingAngle
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
                Text {
                    text: qsTr("深度");
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: depth
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
                Text {
                    text: qsTr("电压");
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: voltage
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
                Text {
                    text: qsTr("电流");
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: parent.item_width
                    renderType: Text.NativeRendering
                }
                TextField {
                    id: current
                    text: "0"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    height: parent.item_height
                    width: label1.width - parent.item_width - parent.spacing
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        border.color: scroll_root.font_color
                        border.width: scroll_root.common_border_width
                    }
                }
            }

            Rectangle {
                width: grid.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            ListView {
                id: bar_list
                anchors.horizontalCenter: parent.horizontalCenter
                boundsBehavior: Flickable.StopAtBounds
                height: 160
                orientation: ListView.Horizontal
                width: grid.width

                ListModel {
                    id: appModel;
                    ListElement {
                        name: "功率限制"
                        value: 0.2
                    }
                    ListElement {
                        name: "前进油门"
                        value: 0.4
                    }
                    ListElement {
                        name: "升降油门"
                        value: 0.5
                    }
                    ListElement {
                        name: "平移油门"
                        value: 0.8
                    }
                    ListElement {
                        name: "旋转油门"
                        value: 1.0
                    }
                }

                Component {
                    id: bar
                    Rectangle {
                        width: grid.width / appModel.count;
                        height: 160
                        color: Qt.rgba(0,0,0,0)
                        Rectangle {
                            id: model_root
                            width: ScreenTools.defaultFontPixelWidth * 2;
                            height: parent.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Qt.rgba(0,0,0,0)
                            Rectangle {
                                width: model_root.width
                                height: model_root.height * 0.6
                                anchors.top: model_root.top
                                anchors.left: model_root.left
                                color: "#e7e6e6"
                                border.width: scroll_root.common_border_width
                                border.color: scroll_root.font_color
                                Rectangle {
                                    id: progress_bar
                                    width: parent.width
                                    height: parent.height * value
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    LinearGradient {
                                        anchors.fill: parent
                                        start: Qt.point(0, 0)
                                        end: Qt.point(width, 0)
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#13c966"; }
                                            GradientStop { position: 1.0; color: "#0c773c"; }
                                        }
                                    }
                                }

                                Text {
                                    width: progress_bar.width
                                    height: ScreenTools.defaultFontPixelHeight
                                    visible: (value < 1)
                                    anchors.bottom: progress_bar.top
                                    anchors.horizontalCenter: progress_bar.horizontalCenter
                                    text: Math.round(value * 100).toString();
                                    color: scroll_root.font_color
                                }
                            }
                            Text {
                                anchors.left: model_root.left
                                anchors.bottom: model_root.bottom
                                width: model_root.width
                                height: model_root.height * 0.4
                                text: name
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignTop
                                renderType: Text.NativeRendering
                                wrapMode: Text.WrapAnywhere
                            }
                        }
                    }
                }

                delegate: bar
                model: appModel
            }

            Rectangle {
                width: grid.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            Grid {
                columns: 4
                Layout.alignment: Qt.AlignCenter
                horizontalItemAlignment: Qt.AlignHCenter
                verticalItemAlignment: Qt.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5

                Label {
                    text: "连接主控"
                    color: "#ffffff"
                    padding: 6
                    background: Rectangle {
                        color: "#66686a"
                        radius: 3
                    }
                    width: label1.width - connectMainControl.width
                    renderType: Text.NativeRendering
                }

                CheckBox {
                   id: connectMainControl
                   display: AbstractButton.IconOnly
                   checked: true
                   width: 15
                }

                Label {
                    text: "系统上电"
                    color: "#ffffff"
                    padding: 6
                    width: label1.width - connectMainControl.width
                    background: Rectangle {
                        color: "#66686a"
                        radius: 3
                    }
                    renderType: Text.NativeRendering
                }
                CheckBox {
                    display: AbstractButton.IconOnly
                    checked: true
                    width: 15
                }
                Label {
                    text: "手动模式"
                    color: "#ffffff"
                    padding: 6
                    background: Rectangle {
                        color: "#66686a"
                        radius: 3
                    }

                    renderType: Text.NativeRendering
                    width: label1.width - connectMainControl.width
                }
                CheckBox {
                   display: AbstractButton.IconOnly
                   checked: true
                   width: 15
                }
                Label {
                    text: "自动模式"
                    color: "#ffffff"
                    padding: 6
                    background: Rectangle {
                        color: "#66686a"
                        radius: 3
                    }

                    renderType: Text.NativeRendering
                    width: label1.width - connectMainControl.width
                }
                CheckBox {
                   display: AbstractButton.IconOnly
                   checked: true
                   width: 15
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3}D{i:5}D{i:9}D{i:4}D{i:14}D{i:15}D{i:16}
D{i:17}D{i:18}D{i:19}D{i:20}D{i:21}D{i:22}D{i:23}D{i:24}D{i:25}D{i:13}D{i:26}D{i:28}
D{i:34}D{i:27}D{i:40}D{i:42}D{i:44}D{i:45}D{i:47}D{i:48}D{i:50}D{i:51}D{i:53}D{i:41}
D{i:2}D{i:1}
}
##^##*/
