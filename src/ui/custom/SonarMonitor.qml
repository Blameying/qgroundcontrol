import QtQuick 2.15
import QtQuick.Window 2.15
import com.kdab.dockwidgets 1.0 as KDDW

Rectangle {
    anchors.fill: parent
    Rectangle{
        id:rect
        width: parent.width
        height: parent.height * 0.2
        color: "cyan"
        anchors.top: parent.top
        anchors.left: parent.left
    }


    KDDW.MainWindowLayout {
        width: parent.width
        height:parent.height * 0.8
        anchors.left: parent.left
        anchors.top:rect.bottom

        // Each main layout needs a unique id
        uniqueName: "MainLayout-1"

        KDDW.DockWidget {
            id: dock1
            uniqueName: "dock1" // Each dock widget needs a unique id
            Rectangle {
                color: "pink"
            }

            property QtObject titleBarVal: dock1.actualTitleBar

            onSwitchStatusChanged: {
                console.log("Blame, status changed", parent.count);
            }

            Component.onCompleted: {
                console.log("Blame, this is ", dock1.titleBarVal, dock1.titleBarVal.switchStatus);
            }
        }

        KDDW.DockWidget {
            id: dock2
            uniqueName: "dock2"
            Rectangle {
                color: "yellow"
            }
        }
        KDDW.DockWidget {
            id: dock3
            uniqueName: "dock3"
            Rectangle {
                color: "red"
            }
        }

        Component.onCompleted: {
            // Add dock4 to the Bottom location
            // Add dock5 to the left of dock4
            addDockWidget(dock1, KDDW.KDDockWidgets.Location_OnRight);
            addDockWidget(dock2, KDDW.KDDockWidgets.Location_OnRight, dock1);
            addDockWidget(dock3, KDDW.KDDockWidgets.Location_OnTop);
        }
    }

}
