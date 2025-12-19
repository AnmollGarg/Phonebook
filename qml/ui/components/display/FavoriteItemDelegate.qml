// Favorite Item Delegate - Reusable component for favorite contact items
import QtQuick 2.7
import Lomiri.Components 1.3

import "." as Display

Item {
    id: favoriteItem
    width: units.gu(12)
    height: parent ? parent.height : units.gu(10)

    property var contactData: null
    
    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            favoriteItem.clicked()
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: units.gu(0.1)
        width: parent.width

        Display.Avatar {
            id: favoriteAvatar
            name: contactData ? contactData.fullName : ""
            size: units.gu(4)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: nameLabel
            text: contactData ? contactData.firstName : ""
            anchors.horizontalCenter: parent.horizontalCenter
            fontSize: "small"
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            maximumLineCount: 2
        }
    }
}

