// Recent Call Item Delegate - Reusable component for recent call items
import QtQuick 2.7
import Lomiri.Components 1.3

Rectangle {
    id: recentCallItem
    width: parent ? parent.width : units.gu(40)
    height: units.gu(6)
    color: "transparent"

    property var callData: null
    
    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            recentCallItem.clicked()
        }
    }

    readonly property color missedColor: "#E95420"
    readonly property color incomingColor: "#2ECC40"
    readonly property color outgoingColor: "#FFA500"

    function getCallTypeColor(type) {
        if (type === "missed") return missedColor
        else if (type === "incoming") return incomingColor
        else return outgoingColor
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: units.gu(1)

        // Call type indicator
        Rectangle {
            width: units.gu(0.5)
            height: parent.height
            color: callData ? getCallTypeColor(callData.type) : "transparent"
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - units.gu(10)
            spacing: units.gu(0.25)

            Label {
                text: callData ? callData.name : ""
                fontSize: "medium"
                font.bold: true
            }

            Row {
                spacing: units.gu(0.5)
                
                Label {
                    text: callData ? callData.phone : ""
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }
                
                Label {
                    text: callData ? callData.type : ""
                    fontSize: "small"
                    color: callData ? getCallTypeColor(callData.type) : "transparent"
                    font.capitalization: Font.Capitalize
                }
            }
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: callData ? callData.time : ""
            fontSize: "small"
            color: theme.palette.normal.backgroundSecondaryText
        }
    }
}

