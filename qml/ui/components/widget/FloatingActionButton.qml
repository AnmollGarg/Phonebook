// Floating Action Button Component
import QtQuick 2.7
import Lomiri.Components 1.3

Rectangle {
    id: fab
    width: units.gu(6)
    height: units.gu(6)
    radius: units.gu(1)
    color: mouseArea.pressed ? Qt.darker(backgroundColor, 1.2) : backgroundColor
    
    property alias iconName: icon.name
    property color backgroundColor: "#E95420" 
    
    signal clicked()
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            fab.clicked()
        }
    }
    
    Icon {
        id: icon
        anchors.centerIn: parent
        width: units.gu(3)
        height: units.gu(3)
        color: "white"
    }
}

