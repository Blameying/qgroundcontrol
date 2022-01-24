import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0

import QGroundControl.ScreenTools  1.0

Rectangle {
    ScrollView {
        id: scroll_root
        anchors.fill: parent
        clip: true
        contentWidth: scroll_root.width

        property string font_color: "#000000";
        property string background_color: "#4dd2ff";
        property string content_color: "#e7e6e6";
        property real   common_padding: 8;
        property real   common_radius: 5;
        property string border_color: "#679898";
        property string icon_color: background_color;
        property string icon_hovered_color: "#00abe6";
        property string icon_chosed_color: "#00cc00";

        Column {
            spacing: ScreenTools.defaultFontPixelHeight
            anchors.left: parent.left
            anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
            anchors.right: parent.right
            anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
            width: parent.width - anchors.rightMargin * 2

            Rectangle {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_main_ip
                    text: "主控IP"
                    color: scroll_root.font_color
                    width: parent.width * 0.4
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }
                TextField {
                    id: text_field_main_ip
                    text: "192.168.1.100"
                    height: label_main_ip.height
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    renderType: Text.NativeRendering
                    color: scroll_root.font_color
                    background: Rectangle {
                        border.width: 0
                        color: scroll_root.content_color
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: scroll_root.font_color
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_extend_ip
                    text: "扩展口IP"
                    color: scroll_root.font_color
                    width: label_main_ip.width
                    height: label_main_ip.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    padding: scroll_root.common_padding
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }
                TextField {
                    id: text_field_extend_ip
                    text: "192.168.1.100"
                    height: label_main_ip.height
                    width: text_field_main_ip.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    renderType: Text.NativeRendering
                    color: scroll_root.font_color
                    background: Rectangle {
                        border.width: 0
                        color: scroll_root.content_color
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: scroll_root.font_color
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_sonar_ip
                    text: "声纳IP"
                    color: scroll_root.font_color
                    width: label_main_ip.width
                    height: label_main_ip.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    padding: scroll_root.common_padding
                    renderType: Text.NativeRendering
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }
                TextField {
                    id: text_field_sonar_ip
                    text: "192.168.1.100"
                    height: label_main_ip.height
                    width: text_field_main_ip.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    renderType: Text.NativeRendering
                    color: scroll_root.font_color
                    background: Rectangle {
                        border.width: 0
                        color: scroll_root.content_color
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: scroll_root.font_color
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
            Label {
                width: parent.width
                height: ScreenTools.defaultFontPixelHeight * 2
                text: "显示设置"
                color: scroll_root.font_color
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.NativeRendering
                padding: scroll_root.common_padding
                background: Rectangle {
                    color: scroll_root.background_color
                    radius: scroll_root.common_radius
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_camera_1
                    text: "摄像头1"
                    color: scroll_root.font_color
                    width: parent.width * 0.3
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                RadioButton {
                    checked: true
                    anchors.verticalCenter: parent.verticalCenter
                    text: "启用"
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }                                                 
                                                                  
                RadioButton {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "禁用"
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_camera_2
                    text: "摄像头2"
                    color: scroll_root.font_color
                    width: label_camera_1.width
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                RadioButton {
                    checked: true
                    anchors.verticalCenter: parent.verticalCenter
                    text: "启用"
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }

                RadioButton {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "禁用"
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_sonar_switch
                    text: "声纳"
                    color: scroll_root.font_color
                    width: label_camera_1.width
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                RadioButton {
                    checked: true
                    anchors.verticalCenter: parent.verticalCenter
                    text: "启用"
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }

                RadioButton {
                    text: "禁用"
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }
            }
            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    id: label_map
                    text: "地图"
                    color: scroll_root.font_color
                    width: label_camera_1.width
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                    anchors.verticalCenter: parent.verticalCenter
                }

                RadioButton {
                    checked: true
                    text: "启用"
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }

                RadioButton {
                    text: "禁用"
                    anchors.verticalCenter: parent.verticalCenter
                    contentItem: Text {
                        text: parent.text
                        color: scroll_root.font_color
                        leftPadding: parent.indicator.width + parent.spacing
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter    
                        renderType: Text.NativeRendering
                    }                                             
                }
            }
        }
    }
}
