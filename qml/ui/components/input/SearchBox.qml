// Searchbox component
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

Rectangle {
    id: searchBox
    implicitHeight: units.gu(6)

    property bool showAvatar: true
    property bool editable: false
    property alias text: searchField.text
    property alias placeholderText: searchField.placeholderText
    property alias searchField: searchField

    signal searchTextChanged(string text)
    signal searchClicked()
    signal avatarClicked()
    signal settingsClicked()
    
    MouseArea {
        anchors.left: parent.left
        anchors.right: showAvatar ? userAvatar.left : parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        enabled: !editable
        onClicked: {
            console.log("SearchBox clicked")
            searchBox.searchClicked()
        }
    }
    
    TextField {
        id: searchField
        anchors.left: parent.left
        anchors.right: showAvatar ? userAvatar.left : parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: units.gu(1)
        anchors.rightMargin: showAvatar ? units.gu(1) : units.gu(1)
        placeholderText: i18n.tr("Search contacts...")
        readOnly: !editable
        enabled: editable
        hasClearButton: editable
        
        onTextChanged: {
            searchBox.searchTextChanged(text)
        }
    }

    //User Avatar
    MouseArea {
        id: avatarMouseArea
        anchors.fill: userAvatar
        enabled: showAvatar
        onClicked: {
            console.log("Avatar clicked")
            searchBox.avatarClicked()
        }
    }
    
    Image {
        id: userAvatar
        source: Qt.resolvedUrl("../../../../assets/avatar.png")
        anchors.right: settingsIcon.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: units.gu(1)
        anchors.margins: units.gu(1)
        width: units.gu(4.5)
        height: units.gu(4.5)
        fillMode: Image.PreserveAspectFit
        z: 10
        visible: showAvatar
    }

    // Settings Icon
    MouseArea {
        id: settingsMouseArea
        anchors.fill: settingsIcon
        enabled: showAvatar
        onClicked: {
            console.log("Settings clicked")
            searchBox.settingsClicked()
        }
    }
    
    Icon {
        id: settingsIcon
        name: "settings"
        width: units.gu(3)
        height: units.gu(3)
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: units.gu(1)
        z: 10
        visible: showAvatar
    }
}