import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0
import QtGraphicalEffects         1.12

import QGroundControl              1.0
import QGroundControl.ScreenTools  1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.SettingsManager       1.0
import Qt.labs.settings 1.0

Rectangle {
    color: "#dadada"
    ScrollView {
        id: scroll_root
        anchors.fill: parent
        clip: true
        contentWidth: width

        property var    _videoSettings: QGroundControl.settingsManager.customedVideoSettings;
        property string font_color: "#000000";
        property string alert_color: "#ff0000";
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
                    id: label_ip
                    text: "IP"
                    color: scroll_root.font_color
                    width: ScreenTools.defaultFontPixelWidth * 8
                    height: ScreenTools.defaultFontPixelHeight * 2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding;
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius;
                    }
                }
                TextField {
                    id: text_ip
                    text: ""
                    height: label_ip.height
                    width: parent.width - parent.spacing - label_ip.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom
                    renderType: Text.NativeRendering
                    color: acceptableInput? scroll_root.font_color : scroll_root.alert_color
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
                    validator: RegExpValidator {
                        regExp:/^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$/
                    }

                    onAccepted: {
                        if (acceptableInput) {
                            rtsp_url.text = "rtsp://admin:zhifan518@%1:554/cam/realmonitor?channel=1&subtype=0".arg(text);
                        }
                    }
                    Settings {
                        id: settings
                        property alias second_camera_ip: text_ip.text;
                    }
                }
                FactTextField {
                    id: rtsp_url
                    visible: false
                    fact: scroll_root._videoSettings.rtspUrl
                    Component.onCompleted: {
                        text_ip.accepted.connect(editingFinished)
                    }
                }
            }

            Label {
                width: parent.width
                text: "图像处理"
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
                    id: label_enhance
                    text: "图像增强"
                    color: scroll_root.font_color
                    width: label_ip.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }
                TextSlider {
                    id: camera_second_enhance
                    width: parent.width - label_enhance.width
                    from: 1
                    value: 25
                    to: 100
                    stepSize: 1
                    height: label_enhance.height

                    Settings {
                        property alias image_enhance_second: camera_second_enhance.value;
                    }
                }
            }

            Row {
                width: parent.width
                spacing: ScreenTools.defaultFontPixelWidth
                Label {
                    id: label_green
                    text: "绿光抑制"
                    color: scroll_root.font_color
                    width: label_enhance.width
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }
                TextSlider {
                    id: camera_second_green
                    width: parent.width - label_enhance.width
                    from: 1
                    value: 25
                    to: 100
                    stepSize: 1
                    height: label_green.height
                    Settings {
                        property alias image_green_second: camera_second_green.value;
                    }
                }
            }

            Label {
                width: parent.width
                text: "字幕"
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
                    id: label_depth
                    text: "深度"
                    color: scroll_root.font_color
                    width: parent.width * 0.2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }

                Rectangle {
                    color: Qt.rgba(0,0,0,0)
                    anchors.verticalCenter: parent.verticalCenter
                    width: ScreenTools.defaultFontPixelWidth * 4
                    height: width
                    Rectangle {
                        anchors.fill: parent
                        id: depth_check_button
                        radius: parent.width / 2
                        border.width: 1
                        border.color: scroll_root.border_color
                        color: scroll_root.content_color
                        clip: true

                        property bool checked: false

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parent.checked = !parent.checked;
                            }
                        }
                    }

                    LinearGradient {
                        anchors.fill: depth_check_button
                        source: depth_check_button
                        visible: depth_check_button.checked
                        start: Qt.point(0, 0)
                        end: Qt.point(depth_check_button.width, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#13c966"; }
                            GradientStop { position: 1.0; color: "#0c773c"; }
                        }
                    }
                }

                Text {
                    text: "X:"
                    height: label_depth.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                }

                TextField {
                    width: parent.width * 0.2
                    height: label_depth.height
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Y:"
                    height: label_depth.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                }

                TextField {
                    width: parent.width * 0.2
                    height: label_depth.height
                    renderType: Text.NativeRendering
                }
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth
                width: parent.width
                Label {
                    text: "温度"
                    color: scroll_root.font_color
                    width: parent.width * 0.2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    padding: scroll_root.common_padding
                    background: Rectangle {
                        color: scroll_root.background_color
                        radius: scroll_root.common_radius
                    }
                }

                Rectangle {
                    color: Qt.rgba(0,0,0,0)
                    anchors.verticalCenter: parent.verticalCenter
                    width: ScreenTools.defaultFontPixelWidth * 4
                    height: width
                    Rectangle {
                        anchors.fill: parent
                        id: temperature_check_button
                        radius: parent.width / 2
                        border.width: 1
                        border.color: scroll_root.border_color
                        color: scroll_root.content_color
                        clip: true

                        property bool checked: false

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parent.checked = !parent.checked;
                            }
                        }
                    }

                    LinearGradient {
                        anchors.fill: temperature_check_button
                        source: temperature_check_button
                        visible: temperature_check_button.checked
                        start: Qt.point(0, 0)
                        end: Qt.point(temperature_check_button.width, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#13c966"; }
                            GradientStop { position: 1.0; color: "#0c773c"; }
                        }
                    }
                }

                Text {
                    text: "X:"
                    height: label_depth.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                }

                TextField {
                    width: parent.width * 0.2
                    height: label_depth.height
                    renderType: Text.NativeRendering
                }

                Text {
                    text: "Y:"
                    height: label_depth.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                }

                TextField {
                    width: parent.width * 0.2
                    height: label_depth.height
                    renderType: Text.NativeRendering
                }
            }

            Rectangle {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

            ListModel {
                id: config_list
                ListElement {
                    name: "自定义1"
                    x: -1
                    y: -1
                    text: ""
                    active: false
                }
                ListElement {
                    name: "自定义2"
                    x: -1
                    y: -1
                    text: ""
                    active: false
                }
            }

            GroupBox {
                id: groupbox
                label: Rectangle {
                    id: label_delegate
                    width: ScreenTools.defaultFontPixelWidth * 8
                    height: ScreenTools.defaultFontPixelWidth * 4
                    color: scroll_root.icon_color
                    radius: scroll_root.common_radius
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "/res/add_dark.svg"
                        fillMode: Image.Stretch
                        mipmap: true
                        width: parent.height
                        height: parent.height

                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            parent.color = scroll_root.icon_hovered_color;
                        }
                        onExited: {
                            parent.color = scroll_root.icon_color;
                        }
                        onClicked: {
                            parent.color = scroll_root.icon_chosed_color;
                            config_list.append(
                                {"name": "自定义" + config_list.count,
                                 "x": -1,
                                 "y": -1,
                                 "text": "",
                                 "active": false});
                        }
                    }
                }

                width: parent.width
                topPadding: label.height;
                height: customed_subtitles.height + topPadding * 2 + position_0.height;
                background: Rectangle {
                    y: groupbox.topPadding - groupbox.padding
                    width: parent.width
                    height: parent.height - groupbox.topPadding + groupbox.padding
                    color:"transparent"
                    border.color: scroll_root.background_color;
                    radius: 2
                }

                Rectangle {
                    id: position_0
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    height: ScreenTools.defaultFontPixelHeight
                    opacity: 0
                }

                ListView {
                    id: customed_subtitles
                    anchors.top: position_0.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    boundsBehavior: Flickable.StopAtBounds
                    width: parent.width
                    height: config_list.count * (label_depth.height * 2 + spacing) + (config_list.count - 1) * spacing
                    spacing: ScreenTools.defaultFontPixelHeight
                    interactive: false

                    Component {
                        id: subtitles_model
                        Column {
                            width: customed_subtitles.width
                            spacing: ScreenTools.defaultFontPixelHeight
                            Row {
                                width: parent.width
                                spacing: ScreenTools.defaultFontPixelWidth
                                Label {
                                    id: customed_name
                                    text: name
                                    color: scroll_root.font_color
                                    width: parent.width * 0.2
                                    height: label_depth.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    renderType: Text.NativeRendering
                                    padding: scroll_root.common_padding
                                    background: Rectangle {
                                        color: scroll_root.background_color
                                        radius: scroll_root.common_radius
                                    }
                                }

                                Rectangle {
                                    color: Qt.rgba(0,0,0,0)
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: ScreenTools.defaultFontPixelWidth * 4
                                    height: width
                                    Rectangle {
                                        anchors.fill: parent
                                        id: list_check_button
                                        radius: parent.width / 2
                                        border.width: 1
                                        border.color: scroll_root.border_color
                                        color: scroll_root.content_color
                                        clip: true

                                        property bool checked: active;

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                parent.checked = !parent.checked;
                                                config_list.setProperty(index, "active", !active);
                                            }
                                        }
                                    }

                                    LinearGradient {
                                        anchors.fill: list_check_button
                                        source: list_check_button
                                        visible: list_check_button.checked
                                        start: Qt.point(0, 0)
                                        end: Qt.point(list_check_button.width, 0)
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: "#13c966"; }
                                            GradientStop { position: 1.0; color: "#0c773c"; }
                                        }
                                    }
                                }

                                Text {
                                    id: text_x
                                    text: "X:"
                                    height: label_depth.height
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    renderType: Text.NativeRendering
                                }

                                TextField {
                                    id: text_field_x
                                    width: parent.width * 0.2
                                    text: x < 0? "": x.toString()
                                    height: label_depth.height
                                    renderType: Text.NativeRendering
                                }

                                Text {
                                    id: text_y
                                    text: "Y:"
                                    height: label_depth.height
                                    renderType: Text.NativeRendering
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                TextField {
                                    id: text_field_y
                                    width: parent.width * 0.2
                                    text: y < 0? "" : y.toString()
                                    height: label_depth.height
                                    renderType: Text.NativeRendering
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: ScreenTools.defaultFontPixelWidth
                                Rectangle {
                                    id: text_edit_container
                                    width: parent.width * 0.8
                                    height: label_depth.height
                                    border.width: 1
                                    border.color: scroll_root.font_color
                                    radius: scroll_root.common_radius

                                    TextEdit {
                                        text: text
                                        anchors.fill: parent
                                        anchors.margins: ScreenTools.defaultFontPixelWidth
                                        renderType: Text.NativeRendering
                                        horizontalAlignment: Text.AlignLeft
                                        verticalAlignment: Text.AlignTop
                                    }
                                }

                                Rectangle {
                                    //width: parent.width - text_edit_container - parent.spacing
                                    width: parent.width * 0.2
                                    height: text_edit_container.height
                                    color: scroll_root.icon_color
                                    radius: scroll_root.common_radius
                                    Image {
                                        width: parent.width > parent.height? parent.height:parent.width
                                        height: width
                                        source: "/res/rubbish.svg"
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        fillMode: Image.Stretch
                                        mipmap: true
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onEntered: {
                                            parent.color = "#f83647";
                                        }
                                        onExited: {
                                            parent.color = scroll_root.icon_color;
                                        }
                                        onClicked: {
                                            parent.color = "#af3d47";
                                            config_list.remove(index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    delegate: subtitles_model
                    model: config_list
                }
            }

            Rectangle {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                height: ScreenTools.defaultFontPixelHeight
                opacity: 0
            }

        }
    }
}
