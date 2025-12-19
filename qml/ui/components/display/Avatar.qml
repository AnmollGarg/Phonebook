// Avatar Component - Shows initials with colored background
import QtQuick 2.7
import Lomiri.Components 1.3

Rectangle {
    id: avatar
    
    property string name: ""
    property int size: units.gu(4)
    
    width: size
    height: size
    radius: width / 2
    color: getColorForName(name)
    
    function getInitials(name) {
        if (!name || name.trim() === "") return ""
        // Show only the first character of the name
        return name.trim()[0].toUpperCase()
    }
    
    function getColorForName(name) {
        // Generate a consistent color based on name
        var colors = [
            "#E95420", // Lomiri orange
            "#2ECC40", // Green
            "#0073E6", // Blue
            "#7B68EE", // Purple
            "#FF6B6B", // Red
            "#4ECDC4", // Teal
            "#FFA500", // Orange
            "#9B59B6", // Purple
            "#1ABC9C", // Turquoise
            "#E67E22"  // Carrot
        ]
        if (!name || name.trim() === "") return colors[0]
        var hash = 0
        for (var i = 0; i < name.length; i++) {
            hash = name.charCodeAt(i) + ((hash << 5) - hash)
        }
        return colors[Math.abs(hash) % colors.length]
    }
    
    Label {
        anchors.centerIn: parent
        text: avatar.getInitials(name)
        fontSize: "medium"
        font.bold: true
        color: "white"
    }
}

