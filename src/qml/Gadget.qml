import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    property int shadow: 1
    property bool adjustForCenter: false
    property var afterEditCallack: function(){}
    id: object
    width: 100//Math.max(12 + (inputs.model * 15), 12 + (outputs.model * 15), 100);
    height: 32
    border.width: 1
    color: "white"
    radius: 4

    TextField {
        id: textArea
        anchors.fill: parent
        anchors.margins: 5
        text: "object"
        enabled: false
        onAccepted: {
            cursorPosition = 0;
            enabled = false;
            var words = text.split(" ");
            if (words.length > 0) {
                var command = words[0];
                var params = words.slice(1);
                if (command === "add") {
                    inputs.model = 2;
                    outputs.model = 1;
                } else if (command === "route") {
                    inputs.model = 2;
                    outputs.model = params.length + 1;
                } else {
                    if (command !== "object") {
                        textColor = "#ff7878";
                    }
                    inputs.model = 0;
                    outputs.model = 0;
                }
            }
            afterEditCallack();
        }
        onFocusChanged: {
            if (!focus) {
                enabled = false;
            }
        }

        onEnabledChanged: {
            if (enabled) {
                textColor = "#787878";
                selectAll();
                forceActiveFocus();
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        enabled: !textArea.enabled
        cursorShape: {
            if (enabled) {
                pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
            } else {
                Qt.IBeamCursor
            }
        }
        onDoubleClicked: {
            textArea.enabled = true;
        }

        drag.target: object
        drag.axis: Drag.XAxis | Drag.YAxis
        drag.minimumX: 0
        drag.maximumX: object.parent.width - object.width
        drag.minimumY: 0
        drag.maximumY: object.parent.height - object.height

    }
    Row {
        x: 8
        y: 1
        spacing: 3
        Repeater {
            id: inputs
            model: 0
            Rectangle {
                color: "#A6CAA9"
                //border.width: 1
                //border.color: "#303030"
                radius: 1
                width: 12
                height: 4
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.color = "red"
                    onExited: parent.color = "#A6CAA9"
                }
            }
        }
    }
    Row {
        x: 8
        y: object.height - 5
        spacing: 3
        Repeater {
            id: outputs
            model: 0
            Rectangle {
                color: "#A6CAA9"
                //border.width: 1
                //border.color: "#303030"
                radius: 1
                width: 12
                height: 4
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.color = "red"
                    onExited: parent.color = "#A6CAA9"
                }
            }
        }
    }
    Component.onCompleted: {
        if (adjustForCenter) {
            x -= width * 0.5;
            y -= height * 0.5;
            adjustForCenter = false;
        }
    }
}
