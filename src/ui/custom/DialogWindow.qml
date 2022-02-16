import QtQuick          2.15
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
    flags: Qt.Window | Qt.FramelessWindowHint
    modality: Qt.NonModal
    property int bw: 5

    property string title: "Window";
    property var mother: undefined;
    property var targetParent: undefined;
    property var targetChild: undefined;

    function pushItem(child, oldParent, newParent) {
        if (child === undefined) return;
        if (oldParent === undefined) return;
        if (newParent === undefined) return;

        var index = indexOfObject(child.objectName, oldParent);
        if (index === -1) {
            console.log("Blame, we cannot find the object " + child.objectName);
        } else {
            newParent.data.push(oldParent.data[index]);
            console.log("Blame, we switched successful");
        }
    }

    function getContentItem(child, oldParent, newParent) {
        if (child === undefined) return;
        if (oldParent === undefined) return;
        if (newParent === undefined) return;

        for (var i = 0; i < oldParent.contentChildren.length; i++) {
            if (oldParent.contentChildren[i].data.length === 0) continue;
            if (oldParent.contentChildren[i].data[0].objectName === child.objectName) {
                newParent.data.push(oldParent.contentChildren[i].data[0]);
                oldParent.contentChildren[i].visible = false;
                console.log("Blame, we switched successful");
                return;
            }
        } 
        console.log("Blame, we cannot find the object " + child.objectName);
    }

    function pushContentItem(child, oldParent, newParent) {
        if (child === undefined) return;
        if (oldParent === undefined) return;
        if (newParent === undefined) return;

        var index = indexOfObject(child.objectName, oldParent);
        if (index === -1) {
            console.log("Blame, we cannot find the object " + child.objectName);
        } else {
            newParent.contentChildren[newParent.parentList].data.push(oldParent.data[index]);
            newParent.contentChildren[newParent.parentList].visible = true;
            console.log("Blame, we switched successful");
        }
    }

    function indexOfObject(objName, oldParent) {
        for (var i = 0 ; i < oldParent.data.length; i++) {
            console.log("Blame, name: ", oldParent.data[i].objectName);
            if (oldParent.data[i].objectName === objName)
                return i
        }
        return -1
    }

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.CanTakeOverFromItems | TapHandler.CanTakeOverFromHandlersOfDifferentType | TapHandler.ApprovesTakeOverByAnything
        target: null
        onActiveChanged: if (active) {
            const p = resizeHandler.centroid.position;
            const b = bw + 10; // Increase the corner size slightly
            let e = 0;
            if (p.x < b) { e |= Qt.LeftEdge }
            if (p.x >= width - b) { e |= Qt.RightEdge }
            if (p.y < b) { e |= Qt.TopEdge }
            if (p.y >= height - b) { e |= Qt.BottomEdge }
            root.startSystemResize(e);
        }
    }

    Rectangle {
        id: titlebar
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
        height: ScreenTools.defaultFontPixelHeight * 2
        width: parent.width
        z: QGroundControl.zOrderTopMost
        color: Qt.rgba(0, 0, 0, 0)

        Text {
            height: parent.height
            color: "white"
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: ScreenTools.defaultFontPixelWidth
            text: root.title
            renderType: Text.NativeRendering
        }

        Image {
            id: closeButton
            fillMode: Image.Stretch
            width: parent.height
            height: width
            mipmap: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                top: parent.top
                rightMargin: 2
            }

            property string normal: "qrc:/res/close-gray.svg"
            property string colored: "qrc:/res/close-red.svg"

            source: normal
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = parent.colored;
                }

                onExited: {
                    parent.source = parent.normal;
                }

                onClicked: {
                    root.hide();
                }
            }
        }

        Image {
            id: fixButton
            fillMode: Image.Stretch
            width: closeButton.height
            height: width
            mipmap: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: closeButton.left
                top: parent.top
                rightMargin: 2
            }
            
            property string normal: "qrc:/res/fixed.svg"
            property string colored: "qrc:/res/fixed-blue.svg"
            source: normal
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = parent.colored;
                }

                onExited: {
                    parent.source = parent.normal;
                }

                onClicked: {
                    if (root.targetChild === undefined) return;
                    if (root.targetChild.attached) return;
                    if (root.targetParent === undefined) return;
                    if (root.indexOfObject(root.targetChild.objectName, root) === -1) {
                        console.log("Blame, frame switch meets bugs");
                        return;
                    }
                    root.hide();
                    root.targetChild.attached = true;
                    root.pushContentItem(root.targetChild, root, root.targetParent);
                    root.targetParent.parentList += 1;
                }
            }
        }

        Image {
            id: switchButton
            fillMode: Image.Stretch
            width: closeButton.height
            height: width
            mipmap: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: fixButton.left
                top: parent.top
                rightMargin: 2
            }

            property string normal: "qrc:/res/switch.svg"
            property string colored: "qrc:/res/switch-green.svg"

            source: normal
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = parent.colored;
                }

                onExited: {
                    parent.source = parent.normal;
                }

            }
        }
        Image {
            id: maxButton
            fillMode: Image.Stretch
            width: closeButton.height
            height: width
            mipmap: true
            anchors {
                verticalCenter: parent.verticalCenter
                right: switchButton.left
                top: parent.top
                rightMargin: 2
            }

            property string normal: "qrc:/res/maximum.svg"
            property string colored: "qrc:/res/maximum-pink.svg"

            source: normal
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = parent.colored;
                }

                onExited: {
                    parent.source = parent.normal;
                }

                onClicked: {
                    if (root.visibility === Window.Maximized) {
                        root.showNormal();
                    } else {
                        root.showMaximized();
                    }
                }
            }
        }

        DragHandler {
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: if (active) { root.startSystemMove(); }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
            if (p.x > titlebar.x && p.x < maxButton.x && p.y > titlebar.y && p.y < (titlebar.y + titlebar.height)) {
                return Qt.ClosedHandCursor;
            }
        }
    }
}
