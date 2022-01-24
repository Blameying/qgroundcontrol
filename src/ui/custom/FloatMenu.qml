import QtQuick                    2.0
import QtQuick.Controls           2.0
import QtQuick.Window             2.0
import QtGraphicalEffects         1.0
import QtQuick.Layouts            1.0

import QGroundControl             1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controls    1.0
import QGroundControl.Palette     1.0
import QGroundControl.FactSystem  1.0
import QGroundControl.Custom      1.0

Rectangle {
    id: root
    width: menuItems.count * singleWidth
    height: singleHeight
    color: Qt.rgba(0, 0, 0, 0)

    property int singleWidth: ScreenTools.defaultFontPixelWidth * 8
    property int singleHeight: ScreenTools.defaultFontPixelWidth * 3
    property int parentWidth: parent.width
    property int parentHeight: parent.height
    property int parentX: parent.x
    property int parentY: parent.y
    property int selected: 0
    property string selectedSrc: ""

    ListModel {
        id: menuItems
        ListElement {
            index: 1
            name: "System"
        }
        ListElement {
            index: 2
            name: "Misc"
        }
        ListElement {
            index: 3
            name: "Sonar"
        }
    }

    Component {
        id: menuModel
        Rectangle {
            width: root.singleWidth
            height: root.singleHeight
            color: Qt.rgba(0.59, 1, 0.40, 0.56)
            border.width: 1
            border.color: "#000000"

            Text {
                id: itemName
                text: name
                anchors.centerIn: parent
                color: "#FFFFFF"
            }

            MouseArea {
                anchors.fill: parent

                property real lastX: 0
                property real lastY: 0
                property var control: root

                property real resultX: 0
                property real resultY: 0

                onPressed: {
                    lastX = mouseX
                    lastY = mouseY
                }

                onContainsMouseChanged: { //修改一下鼠标样式，以示区别
                    if (containsMouse && pressed) {
                        cursorShape = Qt.SizeAllCursor;
                    } else {
                        cursorShape = Qt.ArrowCursor;
                    }
                }

                onPositionChanged: {
                    if (pressed && control)
                    {
                        resultX = control.x+(mouseX-lastX)
                        if (resultX < (parentWidth-root.width) && resultX > 0) {
                            control.x = resultX
                        }
                        resultY = control.y+(mouseY-lastY)
                        if (resultY < (parentHeight-root.height) && resultY > 0) {
                            control.y = resultY
                        }
                    }
                }

                onDoubleClicked: {
                    if (root.selected != index) {
                        root.selected = index
                        root.selectedSrc = name
                    } else if (root.selected == index) {
                        root.selected = 0
                        root.selectedSrc = ""
                    }
                }
            }
        }
    }

    Column {
        Rectangle {
            width: root.width
            height: root.singleHeight
            color: Qt.rgba(0, 0, 0, 0)
            QGCListView {
                id: menuList
                orientation: ListView.Horizontal
                model: menuItems
                delegate: menuModel
                anchors.fill: parent
                clip: true
            }
        }
        Rectangle {
            id: displayPanel
            width: root.width
            height: root.singleHeight * 8
            visible: root.selected == 0? false : true
            color: Qt.rgba(0.59, 1, 0.40, 0.56)

            Text {
                text: selectedSrc
                anchors.centerIn: displayPanel
            }
        }
    }

}

