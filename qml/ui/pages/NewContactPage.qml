// New Contact Page - Create a new contact
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Lomiri.Components.Popups 1.3

import "../../logic" 1.0

Page {
    id: newContactPage

    // Editable field values
    property string editFirstName: ""
    property string editLastName: ""
    property string editPhone: ""
    property string editEmail: ""
    property string editCountryCode: ""
    property bool editIsFavorite: false
    property string editContactType: "individual"

    header: PageHeader {
        title: i18n.tr("New Contact")
        
        trailingActionBar.actions: [
            Action {
                iconName: "tick"
                text: i18n.tr("Save")
                enabled: (editFirstName.trim() !== "" || editLastName.trim() !== "" || editPhone.trim() !== "")
                onTriggered: {
                    saveContact()
                }
            }
        ]
    }

    ContactsService {
        id: contactsService
    }
    
    OdooSyncService {
        id: odooSyncService
    }
    
    // Dialog for sync status
    Component {
        id: syncStatusDialog
        Dialog {
            id: dialog
            title: i18n.tr("Sync Status")
            text: ""
            
            Button {
                text: i18n.tr("OK")
                onClicked: PopupUtils.close(dialog)
            }
        }
    }

    function saveContact() {
        var fullName = (editFirstName + " " + editLastName).trim();
        if (fullName === "") {
            fullName = editFirstName || editLastName || "New Contact";
        }
        
        var contactData = {
            firstName: editFirstName,
            lastName: editLastName,
            fullName: fullName,
            phone: editPhone,
            email: editEmail,
            countryCode: editCountryCode,
            isFavorite: editIsFavorite,
            contactType: editContactType
        };
        
        // Create contact locally first
        var newContact = contactsService.createContact(contactData);
        if (newContact) {
            // Try to sync to Odoo
            syncToOdoo(newContact)
        }
    }
    
    function syncToOdoo(contactToSync) {
        // Store the contact ID and service reference for later use
        var contactIdToUpdate = contactToSync.id
        var serviceRef = contactsService
        
        if (!serviceRef) {
            console.log("Error: contactsService is not available")
            return
        }
        
        odooSyncService.syncNewContactToOdoo(contactToSync,
            // onSuccess
            function(odooRecordId, accountId) {
                console.log("Contact created in Odoo with ID:", odooRecordId)
                try {
                    if (!serviceRef) {
                        console.log("Error: contactsService is null in callback")
                        return
                    }
                    
                    // Update contact with odoo_record_id and account_id
                    var updateData = {
                        odoo_record_id: odooRecordId,
                        account_id: accountId,
                        sync_status: "synced"
                    }
                    var updated = serviceRef.updateContact(contactIdToUpdate, updateData)
                    if (updated) {
                        console.log("Contact updated with Odoo ID:", odooRecordId)
                    } else {
                        console.log("Warning: Failed to update contact with Odoo ID")
                    }
                } catch (e) {
                    console.log("Error updating contact:", e.toString())
                }
                
                // Navigate back
                Qt.callLater(function() {
                    var pageStack = findPageStack(newContactPage);
                    if (pageStack) {
                        pageStack.removePages(newContactPage);
                    }
                })
            },
            // onError
            function(errorType, errorMessage) {
                console.log("Error creating contact in Odoo:", errorType, errorMessage)
                try {
                    if (serviceRef) {
                        // Mark as pending sync
                        var updateData = {
                            sync_status: "pending"
                        }
                        serviceRef.updateContact(contactIdToUpdate, updateData)
                    }
                } catch (e) {
                    console.log("Error updating contact sync status:", e.toString())
                }
                
                // Show error but still navigate back (contact was created locally)
                try {
                    var dialog = PopupUtils.open(syncStatusDialog, null)
                    if (dialog) {
                        dialog.text = i18n.tr("Contact created locally but failed to sync to Odoo: ") + errorMessage
                    }
                } catch (e) {
                    console.log("Error showing dialog:", e.toString())
                }
                
                // Navigate back after a delay
                Qt.callLater(function() {
                    var pageStack = findPageStack(newContactPage);
                    if (pageStack) {
                        pageStack.removePages(newContactPage);
                    }
                })
            }
        )
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

            // Avatar placeholder
            Item {
                width: parent.width
                height: units.gu(15)

                Image {
                    id: contactAvatar
                    source: Qt.resolvedUrl("../../../assets/avatar.png")
                    width: units.gu(12)
                    height: units.gu(12)
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Name - Editable
            Row {
                width: parent.width
                spacing: units.gu(1)
                
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
                    width: parent.width
                    text: editPhone
                    placeholderText: i18n.tr("Phone number")
                    onTextChanged: editPhone = text
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
                    width: parent.width
                    text: editEmail
                    placeholderText: i18n.tr("Email address")
                    inputMethodHints: Qt.ImhEmailCharactersOnly
                    onTextChanged: editEmail = text
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
                    width: parent.width
                    text: editCountryCode
                    placeholderText: i18n.tr("Country code (e.g., +1)")
                    onTextChanged: editCountryCode = text
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
                    checked: editIsFavorite
                    onCheckedChanged: editIsFavorite = checked
                }
            }
        }
    }
}



