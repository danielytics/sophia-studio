import QtQuick 2.0

Rectangle {
    id: view
    property bool isMoving: false
    property real xPosition: 0
    property real yPosition: 0
    property alias visibleWidth: container.width
    property alias visibleHeight: container.height
    property alias workspaceWidth: workspace.width
    property alias workspaceHeight: workspace.height
    Item {
        id: internal
        readonly property var gadgetComponent: Qt.createComponent("Gadget.qml");
        property real mouseX: 0
        property real mouseY: 0
    }

    function createGadget (x, y) {
        var afc = x !== undefined || y !== undefined
        x = x === undefined ? 0 : x
        y = y === undefined ? 0 : y
        var object = internal.gadgetComponent.createObject(workspace, {x: x, y: y, adjustForCenter: afc, afterEditCallack: function(){view.focus = true;}});
    }
    function centerView () {
        workspace.anchors.centerIn = container
        workspace.anchors.centerIn = null
    }
    function changeView (x, y) {
        // xPosition = -x / width
        // -xPosition * width = x
        workspace.x = -x * workspace.width
        workspace.y = -y * workspace.height
    }

    border.width: 1
    clip: true
    focus: true

    Rectangle {
        id: container
        x: 1
        y: 1
        width: parent.width - 2
        height: parent.height - 2
        clip: true
        MouseArea {
            property real startX
            property real startY
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            cursorShape: {
                if (pressedButtons & Qt.LeftButton) {
                    Qt.CrossCursor;
                } else {
                    Qt.ArrowCursor;
                }
            }
            onPressed: {
                if (mouse.button & Qt.LeftButton) {
                    startX = mouseX;
                    startY = mouseY;
                }
            }
            onPositionChanged: {
            }
//                onWheel: {
//                    var r = mapToItem(workspace, wheel.x, wheel.y);
//                    zoom.origin.x = r.x;
//                    zoom.origin.y = r.y;
//                    var value = (wheel.angleDelta.y / 120) * 0.1;
//                    if ((value < 0 && zoom.xScale > 0.2) || (value > 0 && zoom.xScale < 3)){
//                        zoom.xScale += value;
//                        zoom.yScale += value;
//                    }
//                    workspace.keepInContainer();
//                }
        }

        Rectangle {
            property real min_x: container.width >= workspace.width ? 0 : container.width - workspace.width
            property real max_x: container.width >= workspace.width ? container.width - workspace.width : 0
            property real min_y: container.height >= workspace.height ? 0 : container.height - workspace.height
            property real max_y: container.height >= workspace.height ? container.height - workspace.height : 0
            id: workspace
            width: 2000
            height: 1500
            anchors.centerIn: container
            color: "lightgray"
            border.width: 1
            border.color: "gray"
            clip: true
            onXChanged: xPosition = -x / width
            onYChanged: yPosition = -y / height
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                hoverEnabled: true
                cursorShape: if (pressedButtons & Qt.RightButton) Qt.SizeAllCursor
                drag.target: parent
                drag.axis: Drag.XAxis | Drag.YAxis
                drag.minimumX: workspace.min_x
                drag.maximumX: workspace.max_x
                drag.minimumY: workspace.min_y
                drag.maximumY: workspace.max_y
                onPressed: isMoving = true
                onReleased: isMoving = false
                onPositionChanged: {
                    internal.mouseX = mouse.x;
                    internal.mouseY = mouse.y;
                }
            }
        }
        onWidthChanged: {
            if (workspace.x < workspace.min_x) {
                workspace.x = workspace.min_x;
            } else if (workspace.x > workspace.max_x) {
                workspace.x = workspace.max_x;
            }
        }
        onHeightChanged: {
            if (workspace.y < workspace.min_y) {
                workspace.y = workspace.min_y;
            } else if (workspace.y > workspace.max_y) {
                workspace.y = workspace.max_y;
            }
        }
    }
    Keys.onPressed: {
        if (event.modifiers & Qt.ControlModifier && event.key == Qt.Key_Space) {
            createGadget(internal.mouseX, internal.mouseY);
        }
    }
    Component.onCompleted: centerView()
}
