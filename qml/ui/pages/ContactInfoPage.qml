// Contact Info Page - Display full contact information
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7 as Controls

import "../../logic" 1.0
import "../components/display" 1.0

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
            contactType: editContactType
        };
        
        var updated = contactsService.updateContact(contactId, updatedData);
        if (updated) {
            contact = updated;
            isEditMode = false;
        }
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

                    Controls.RadioButton {
                        id: individualRadio
                        text: i18n.tr("Individual")
                        checked: editContactType === "individual"
                        onCheckedChanged: {
                            if (checked) {
                                editContactType = "individual"
                            }
                        }
                    }

                    Controls.RadioButton {
                        id: companyRadio
                        text: i18n.tr("Company")
                        checked: editContactType === "company"
                        onCheckedChanged: {
                            if (checked) {
                                editContactType = "company"
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
}

