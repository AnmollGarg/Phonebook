// FloatingExpansionButton - Reusable floating expansion button component
import QtQuick 2.7
import Lomiri.Components 1.3

Rectangle {
    id: expansionButton
    
    width: units.gu(4)
    height: units.gu(4)
    radius: units.gu(0.5)
    
    property bool expanded: false
    property color backgroundColor: "#FF6B35" // Orange color
    property color iconColor: "white"
    property string expandIcon: "go-down"
    property string collapseIcon: "go-up"
    
    color: mouseArea.pressed ? Qt.darker(backgroundColor, 1.2) : backgroundColor
    
    signal clicked()
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            expansionButton.expanded = !expansionButton.expanded
            expansionButton.clicked()
        }
    }
    
    Icon {
        anchors.centerIn: parent
        name: expansionButton.expanded ? expansionButton.collapseIcon : expansionButton.expandIcon
        width: units.gu(2)
        height: units.gu(2)
        color: expansionButton.iconColor
    }
    
    Behavior on rotation {
        NumberAnimation { duration: 200 }
    }
}

