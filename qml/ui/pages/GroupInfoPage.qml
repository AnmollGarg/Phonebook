// Group Info Page - Display and manage group details
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../logic" 1.0
import "../components/display" 1.0

Page {
    id: groupInfoPage

    property int groupId: -1
    property var group: null
    property bool isEditMode: false
    property var groupContacts: []

    // Editable field values
    property string editName: ""
    property string editDescription: ""
    property var selectedContactIds: []

    GroupsService {
        id: groupsService
    }

    ContactsService {
        id: contactsService
    }

    Component.onCompleted: {
        if (groupId > 0) {
            group = groupsService.getGroupById(groupId)
            if (group) {
                loadGroupData()
            }
        }
    }

    function loadGroupData() {
        if (!group) return
        
        editName = group.name || ""
        editDescription = group.description || ""
        selectedContactIds = group.contactIds ? group.contactIds.slice() : []
        refreshGroupContacts()
    }

    function refreshGroupContacts() {
        if (!group) return
        groupContacts = groupsService.getContactsInGroup(groupId)
    }

    function enterEditMode() {
        isEditMode = true
        loadGroupData()
    }

    function saveGroup() {
        if (!group || groupId <= 0) return
        
        var updatedData = {
            name: editName.trim(),
            description: editDescription.trim(),
            contactIds: selectedContactIds.slice()
        }
        
        var updated = groupsService.updateGroup(groupId, updatedData)
        if (updated) {
            group = updated
            isEditMode = false
            refreshGroupContacts()
        }
    }

    function toggleContactSelection(contactId) {
        var index = selectedContactIds.indexOf(contactId)
        if (index === -1) {
            selectedContactIds.push(contactId)
        } else {
            selectedContactIds.splice(index, 1)
        }
        selectedContactIds = selectedContactIds.slice()
    }

    function isContactSelected(contactId) {
        return selectedContactIds.indexOf(contactId) !== -1
    }

    function removeContactFromGroup(contactId) {
        if (groupsService.removeContactFromGroup(groupId, contactId)) {
            loadGroupData()
        }
    }

    header: PageHeader {
        title: group ? group.name : i18n.tr("Group Info")
        
        trailingActionBar.actions: [
            Action {
                iconName: isEditMode ? "tick" : "edit"
                text: isEditMode ? i18n.tr("Save") : i18n.tr("Edit")
                onTriggered: {
                    if (isEditMode) {
                        saveGroup()
                    } else {
                        enterEditMode()
                    }
                }
            },
            Action {
                iconName: "delete"
                text: i18n.tr("Delete Group")
                visible: !isEditMode
                onTriggered: {
                    if (groupsService.deleteGroup(groupId)) {
                        var pageStack = findPageStack(groupInfoPage)
                        if (pageStack) {
                            pageStack.removePages(groupInfoPage)
                        }
                    }
                }
            }
        ]
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

            // Group Name
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Group Name")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                    visible: isEditMode
                }

                TextField {
                    id: nameField
                    width: parent.width
                    placeholderText: i18n.tr("Enter group name")
                    text: editName
                    visible: isEditMode
                    onTextChanged: editName = text
                }

                Label {
                    text: group ? group.name : ""
                    fontSize: "x-large"
                    font.bold: true
                    width: parent.width
                    visible: !isEditMode
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Group Description
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Description")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                    visible: isEditMode
                }

                TextArea {
                    id: descriptionField
                    width: parent.width
                    height: units.gu(8)
                    placeholderText: i18n.tr("Enter group description (optional)")
                    text: editDescription
                    visible: isEditMode
                    onTextChanged: editDescription = text
                }

                Label {
                    text: group && group.description ? group.description : i18n.tr("No description")
                    fontSize: "medium"
                    width: parent.width
                    visible: !isEditMode
                    wrapMode: Text.WordWrap
                    color: group && group.description ? theme.palette.normal.baseText : theme.palette.normal.backgroundSecondaryText
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Contacts in Group
            Column {
                width: parent.width
                spacing: units.gu(1)

                Row {
                    width: parent.width
                    spacing: units.gu(1)

                    Label {
                        text: isEditMode ? i18n.tr("Select Contacts") : i18n.tr("Contacts in Group")
                        fontSize: "medium"
                        font.bold: true
                        width: parent.width - contactCountLabel.width - parent.spacing
                    }

                    Label {
                        id: contactCountLabel
                        text: {
                            var count = isEditMode ? selectedContactIds.length : (groupContacts ? groupContacts.length : 0)
                            return "(" + count + ")"
                        }
                        fontSize: "medium"
                        font.bold: true
                        color: theme.palette.normal.backgroundSecondaryText
                    }
                }

                Label {
                    text: {
                        if (isEditMode) {
                            var count = selectedContactIds.length
                            if (count === 0) {
                                return i18n.tr("No contacts selected")
                            } else if (count === 1) {
                                return i18n.tr("1 contact selected")
                            } else {
                                return i18n.tr("%1 contacts selected").arg(count)
                            }
                        } else {
                            return ""
                        }
                    }
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                    width: parent.width
                    visible: isEditMode
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
                    model: isEditMode ? contactsService.getAllContactsSorted() : groupContacts

                    delegate: ListItem {
                        id: contactListItem
                        width: parent.width
                        height: units.gu(8)
                        divider.visible: true

                        property var contactItem: modelData

                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: units.gu(2)
                            anchors.rightMargin: units.gu(2)
                            spacing: units.gu(1.5)

                            // Checkbox (only in edit mode)
                            CheckBox {
                                id: contactCheckbox
                                anchors.verticalCenter: parent.verticalCenter
                                visible: isEditMode
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
                                width: parent.width - (isEditMode ? contactCheckbox.width : 0) - units.gu(5)
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
                            if (isEditMode) {
                                contactCheckbox.checked = !contactCheckbox.checked
                            } else {
                                // Navigate to contact info
                                var pageStack = findPageStack(groupInfoPage)
                                if (pageStack) {
                                    var pageUrl = Qt.resolvedUrl("ContactInfoPage.qml")
                                    pageStack.addPageToNextColumn(groupInfoPage, pageUrl, {contactId: modelData.id})
                                }
                            }
                        }

                        trailingActions: ListItemActions {
                            actions: [
                                Action {
                                    iconName: "delete"
                                    text: i18n.tr("Remove from Group")
                                    visible: !isEditMode
                                    enabled: !isEditMode
                                    onTriggered: {
                                        if (!isEditMode) {
                                            removeContactFromGroup(modelData.id)
                                        }
                                    }
                                }
                            ]
                        }
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: isEditMode ? i18n.tr("No contacts available") : i18n.tr("No contacts in this group")
                    visible: (isEditMode && contactsService.getAllContactsSorted().length === 0) || (!isEditMode && groupContacts.length === 0)
                    fontSize: "medium"
                    color: theme.palette.normal.backgroundSecondaryText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    function findPageStack(item) {
        var parent = item.parent
        while (parent) {
            if (parent.addPageToNextColumn || parent.removePages) {
                return parent
            }
            parent = parent.parent
        }
        return null
    }
}

