// New Group Page - Create a new contact group
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../logic" 1.0
import "../components/display" 1.0

Page {
    id: newGroupPage

    // Editable field values
    property string editName: ""
    property string editDescription: ""
    property var selectedContactIds: []
    property var allContacts: []

    GroupsService {
        id: groupsService
    }

    ContactsService {
        id: contactsService
    }

    Component.onCompleted: {
        allContacts = contactsService.getAllContactsSorted()
    }

    function toggleContactSelection(contactId) {
        var index = selectedContactIds.indexOf(contactId)
        if (index === -1) {
            selectedContactIds.push(contactId)
        } else {
            selectedContactIds.splice(index, 1)
        }
        // Create a new array to trigger property change
        selectedContactIds = selectedContactIds.slice()
    }

    function isContactSelected(contactId) {
        return selectedContactIds.indexOf(contactId) !== -1
    }

    header: PageHeader {
        title: i18n.tr("New Group")
        
        trailingActionBar.actions: [
            Action {
                iconName: "tick"
                text: i18n.tr("Save")
                enabled: editName.trim() !== ""
                onTriggered: {
                    saveGroup()
                }
            }
        ]
    }

    function saveGroup() {
        var groupData = {
            name: editName.trim(),
            description: editDescription.trim(),
            contactIds: selectedContactIds.slice()
        };
        
        var newGroup = groupsService.createGroup(groupData);
        if (newGroup) {
            // Navigate back
            var pageStack = findPageStack(newGroupPage);
            if (pageStack) {
                pageStack.removePages(newGroupPage);
            }
        }
    }

    function findPageStack(item) {
        var parent = item.parent
        while (parent) {
            if (parent.removePages) {
                return parent
            }
            parent = parent.parent
        }
        return null
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height + units.gu(2)
        anchors.leftMargin: units.gu(2)
        anchors.rightMargin: units.gu(2)
        anchors.bottomMargin: units.gu(2)
        contentWidth: column.width
        contentHeight: column.height
        clip: true

        Column {
            id: column
            width: flickable.width
            spacing: units.gu(2)

            // Group name
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Group Name")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                TextField {
                    id: nameField
                    width: parent.width
                    placeholderText: i18n.tr("Enter group name")
                    text: editName
                    onTextChanged: editName = text
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Group description
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Description")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                TextArea {
                    id: descriptionField
                    width: parent.width
                    height: units.gu(8)
                    placeholderText: i18n.tr("Enter group description (optional)")
                    text: editDescription
                    onTextChanged: editDescription = text
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Contacts Selection
            Column {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Select Contacts")
                    fontSize: "medium"
                    font.bold: true
                    width: parent.width
                }

                Label {
                    text: {
                        var count = selectedContactIds.length
                        if (count === 0) {
                            return i18n.tr("No contacts selected")
                        } else if (count === 1) {
                            return i18n.tr("1 contact selected")
                        } else {
                            return i18n.tr("%1 contacts selected").arg(count)
                        }
                    }
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                    width: parent.width
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Contacts List
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Repeater {
                    model: allContacts

                    delegate: ListItem {
                        width: parent.width
                        height: units.gu(8)
                        divider.visible: true

                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: units.gu(2)
                            anchors.rightMargin: units.gu(2)
                            spacing: units.gu(1.5)

                            // Checkbox
                            CheckBox {
                                id: contactCheckbox
                                anchors.verticalCenter: parent.verticalCenter
                                checked: isContactSelected(modelData.id)
                                onCheckedChanged: {
                                    if (checked !== isContactSelected(modelData.id)) {
                                        toggleContactSelection(modelData.id)
                                    }
                                }
                            }

                            // Avatar
                            Avatar {
                                name: modelData.fullName || ""
                                size: units.gu(4)
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Contact Info
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - contactCheckbox.width - units.gu(5)
                                spacing: units.gu(0.25)

                                Label {
                                    text: modelData.fullName || ""
                                    fontSize: "medium"
                                    font.bold: true
                                    width: parent.width
                                    elide: Text.ElideRight
                                }

                                Label {
                                    text: modelData.phone || ""
                                    fontSize: "small"
                                    color: theme.palette.normal.backgroundSecondaryText
                                    width: parent.width
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        onClicked: {
                            contactCheckbox.checked = !contactCheckbox.checked
                        }
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n.tr("No contacts available")
                    visible: allContacts.length === 0
                    fontSize: "medium"
                    color: theme.palette.normal.backgroundSecondaryText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}

