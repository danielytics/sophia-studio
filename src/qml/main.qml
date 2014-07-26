import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }
    toolBar: ToolBar {
        RowLayout {
            ToolButton {
                id: centerWorkspaceButton
                text: "C"
                onPressedChanged: workspace.centerView()
            }
        }
    }
    WorkspaceView {
        id: workspace
        anchors.fill: parent
        anchors.margins: 32
        anchors.bottomMargin: 64
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        anchors.leftMargin: 32
        spacing: 8
//        Button {
//            text: qsTr("Add")
//            onClicked: {
//                workspace.createGadget();
//            }
//        }
    }
    Rectangle {
        property bool toggled: false
        id: minimapToggle
        anchors.top: parent.top
        anchors.topMargin: -1
        anchors.left: minimap.left
        anchors.right: minimap.right
        height: 5
        border.width: 1
        border.color: "lightgray"
        color: "darkgray"
        visible: !minimap.visible
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.toggled = true
        }
    }

    Rectangle {
        id: minimap
        border.width: 1
        border.color: "darkgray"
        anchors.top: minimapToggle.top
        anchors.right: parent.right
        width: 100 * (workspace.workspaceWidth / workspace.workspaceHeight)
        height: 100
        visible: workspace.isMoving || centerWorkspaceButton.pressed || minimapToggle.toggled
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: minimapToggle.toggled = false
        }

        Item {
            anchors.fill: parent
            anchors.margins: 1
            Rectangle {
                x: workspace.xPosition * parent.width
                y: workspace.yPosition * parent.height
                width: (parent.width * workspace.visibleWidth) / workspace.workspaceWidth
                height: (parent.height * workspace.visibleHeight) / workspace.workspaceHeight
                border.width: 1
                border.color: "gray"
                color: "lightgray"
                onXChanged: if (minimapMouse.drag.active) workspace.changeView(x / parent.width, y / parent.height);
                onYChanged: if (minimapMouse.drag.active) workspace.changeView(x / parent.width, y /                  parent.height);
                MouseArea {
                    id: minimapMouse
                    anchors.fill: parent
                    cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    drag.target: parent
                    drag.axis: Drag.XAxis | Drag.YAxis
                    drag.minimumX: 0
                    drag.maximumX: parent.parent.width - parent.width
                    drag.minimumY: 0
                    drag.maximumY: parent.parent.height - parent.height
                }
            }
        }
    }
}
