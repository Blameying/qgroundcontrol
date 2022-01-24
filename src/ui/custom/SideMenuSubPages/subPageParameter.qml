
import QtQuick                    2.15
import QtQuick.Controls           2.15
import QtQuick.Layouts            1.15
import QtQuick.Window             2.0

Rectangle {
    color: "#dadada"
    ScrollView {
        id: scroll_root
        anchors.fill: parent
        clip: true
        contentWidth: scroll_root.width

        property string font_color: "#000000";
        property string background_color: "#4dd2ff";
        property string border_color: "#679898";

        ListModel {
            id: parameters
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
            ListElement {
                name: "demo1"
                value: 0.5
                description: "This is only demo parameter"
            }
        }

        Component {
            id: param_delegate
            Rectangle {
                width: parent.width
                height: 30
                color: "#00000000"
                Text {
                    id: text_name
                    text: name
                    height: parent.height
                    width: parent.width * 0.2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: scroll_root.font_color
                    renderType: Text.NativeRendering
                    anchors.left: parent.left
                    anchors.top: parent.top
                }

                TextInput{
                    id: text_input_param
                    text: value
                    validator: DoubleValidator{bottom: 0; top: 100;}
                    focus: true
                    color: scroll_root.font_color
                    width: parent.width * 0.2
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    anchors.left: text_name.right
                    anchors.top: parent.top
                }

                Text {
                    id: text_description
                    text: description
                    height: parent.height
                    width: parent.width * 0.6
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: scroll_root.font_color
                    renderType: Text.NativeRendering
                    anchors.left: text_input_param.right
                    anchors.top: parent.top
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: text_description.bottom
                    width: parent.width
                    height: 1
                    color: scroll_root.border_color
                }
            }
        }

        ListView {
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            delegate: param_delegate
            model: parameters
        }
    }
}
