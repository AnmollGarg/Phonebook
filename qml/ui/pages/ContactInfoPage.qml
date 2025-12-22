// Contact Info Page - Display full contact information
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7 as Controls

import "../../logic" 1.0
import "../components/display" 1.0
import "../components/widget" 1.0

Page {
    id: contactInfoPage

    property int contactId: -1
    property var contact: null
    property bool isEditMode: false

    // Editable field values
    property string editFirstName: ""
    property string editLastName: ""
    property string editPhone: ""
    property string editEmail: ""
    property string editCountryCode: ""
    property bool editIsFavorite: false
    property string editContactType: "individual" // "individual" or "company"
    property string editNotes: ""
    property string activeTab: "info" // "info" or "notes"

    header: PageHeader {
        title: contact ? contact.fullName : i18n.tr("Contact Info")
        
        trailingActionBar.actions: [
            Action {
                iconName: isEditMode ? "tick" : "edit"
                text: isEditMode ? i18n.tr("Save") : i18n.tr("Edit")
                onTriggered: {
                    if (isEditMode) {
                        saveContact()
                    } else {
                        enterEditMode()
                    }
                }
            }
        ]
    }

    ContactsService {
        id: contactsService
    }

    Component.onCompleted: {
        if (contactId > 0) {
            contact = contactsService.getContactById(contactId);
            if (contact) {
                loadContactData()
            }
        }
    }

    function loadContactData() {
        if (contact) {
            // Split fullName into first and last name
            var nameParts = contact.fullName.split(" ");
            editFirstName = nameParts[0] || "";
            editLastName = nameParts.slice(1).join(" ") || "";
            editPhone = contact.phone || "";
            editEmail = contact.email || "";
            editCountryCode = contact.countryCode || "";
            editIsFavorite = contact.isFavorite || false;
            editContactType = contact.contactType || "individual";
            editNotes = contact.notes || "";
        }
    }

    function enterEditMode() {
        isEditMode = true;
        loadContactData();
    }

    function saveContact() {
        if (!contact || contactId <= 0) return;
        
        var updatedFullName = (editFirstName + " " + editLastName).trim();
        if (updatedFullName === "") {
            updatedFullName = editFirstName || editLastName || contact.fullName;
        }
        
        var updatedData = {
            firstName: editFirstName,
            lastName: editLastName,
            fullName: updatedFullName,
            phone: editPhone,
            email: editEmail,
            countryCode: editCountryCode,
            isFavorite: editIsFavorite,
            contactType: editContactType,
            notes: editNotes
        };
        
        var updated = contactsService.updateContact(contactId, updatedData);
        if (updated) {
            contact = updated;
            isEditMode = false;
        }
    }

    Item {
        id: mainContainer
        anchors.fill: parent
        anchors.topMargin: header.height

        TabbedView {
            id: tabbedView
            anchors.fill: parent
            tabs: [
                {label: i18n.tr("Info"), key: "info"},
                {label: i18n.tr("Notes"), key: "notes"}
            ]
            currentTab: activeTab
            
            onTabSelected: {
                activeTab = tabKey
            }

            // Info Tab Content
            Flickable {
                id: flickable
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: tabbedView.tabHeight
                anchors.bottom: parent.bottom
                visible: activeTab === "info"
                contentWidth: column.width
                contentHeight: Math.max(column.height + units.gu(4), height)
                flickableDirection: Flickable.VerticalFlick
                clip: true

                Column {
                    id: column
                    width: flickable.width - units.gu(4)
                    x: units.gu(2)
                    y: units.gu(2)
                    spacing: units.gu(2)

            // Avatar
            Item {
                width: parent.width
                height: units.gu(15)

                Avatar {
                    id: contactAvatar
                    name: contact ? contact.fullName : ""
                    size: units.gu(12)
                    anchors.centerIn: parent
                }
            }

            // Name - Editable
            Row {
                width: parent.width
                spacing: units.gu(1)
                visible: isEditMode
                
                TextField {
                    id: firstNameField
                    width: (parent.width - parent.spacing) / 2
                    placeholderText: i18n.tr("First Name")
                    text: editFirstName
                    onTextChanged: editFirstName = text
                }
                
                TextField {
                    id: lastNameField
                    width: (parent.width - parent.spacing) / 2
                    placeholderText: i18n.tr("Last Name")
                    text: editLastName
                    onTextChanged: editLastName = text
                }
            }
            
            Label {
                visible: !isEditMode
                text: contact ? contact.fullName : ""
                fontSize: "x-large"
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Contact Type
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Contact Type")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                Row {
                    width: parent.width
                    spacing: units.gu(2)
                    visible: isEditMode

                    Row {
                        spacing: units.gu(1)
                        Controls.RadioButton {
                            id: individualRadio
                            checked: editContactType === "individual"
                            onCheckedChanged: {
                                if (checked) {
                                    editContactType = "individual"
                                }
                            }
                        }
                        Label {
                            text: i18n.tr("Individual")
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    individualRadio.checked = true
                                }
                            }
                        }
                    }

                    Row {
                        spacing: units.gu(1)
                        Controls.RadioButton {
                            id: companyRadio
                            checked: editContactType === "company"
                            onCheckedChanged: {
                                if (checked) {
                                    editContactType = "company"
                                }
                            }
                        }
                        Label {
                            text: i18n.tr("Company")
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    companyRadio.checked = true
                                }
                            }
                        }
                    }
                }

                Label {
                    visible: !isEditMode
                    text: contact && contact.contactType === "company" ? i18n.tr("Company") : i18n.tr("Individual")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Phone Number
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Phone")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                TextField {
                    visible: isEditMode
                    width: parent.width
                    text: editPhone
                    onTextChanged: editPhone = text
                }

                Label {
                    visible: !isEditMode
                    text: contact ? contact.phone : ""
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Email
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Email")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                TextField {
                    visible: isEditMode
                    width: parent.width
                    text: editEmail
                    inputMethodHints: Qt.ImhEmailCharactersOnly
                    onTextChanged: editEmail = text
                }

                Label {
                    visible: !isEditMode
                    text: contact ? contact.email : ""
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Country Code
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Country Code")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                TextField {
                    visible: isEditMode
                    width: parent.width
                    text: editCountryCode
                    onTextChanged: editCountryCode = text
                }

                Label {
                    visible: !isEditMode
                    text: contact ? contact.countryCode : ""
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Favorite Status
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Favorite")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                Switch {
                    visible: isEditMode
                    checked: editIsFavorite
                    onCheckedChanged: editIsFavorite = checked
                }

                Label {
                    visible: !isEditMode
                    text: contact && contact.isFavorite ? i18n.tr("Yes") : i18n.tr("No")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
            }
        }

            // Notes Tab Content
            NotesEditor {
                id: notesEditor
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: tabbedView.tabHeight
                anchors.bottom: parent.bottom
                visible: activeTab === "notes"
                notes: editNotes
                isEditMode: contactInfoPage.isEditMode
                placeholderText: i18n.tr("Add notes about this contact...")
                labelText: i18n.tr("Notes")
                
                onTextChanged: {
                    editNotes = newText
                }
            }
        }
    }
}

