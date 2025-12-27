// All Contacts component - list of all contacts
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../../logic" 1.0
import "../dialog" 1.0

Rectangle {
    id: recentsContainer
    color: "transparent"

    signal contactClicked(int contactId)

    ContactsService {
        id: contactsService
    }
    
    OdooSyncService {
        id: odooSyncService
        Component.onCompleted: {
            // Link OdooSyncService to ContactsService for deletion sync
            contactsService.odooSyncService = odooSyncService
        }
    }

    property var allContactsModel: []
    property int contactToDelete: -1
    
    // Timer to refresh contacts after component loads
    Timer {
        id: refreshTimer
        interval: 100
        running: true
        onTriggered: {
            recentsContainer.refreshContacts()
        }
    }
    
    ConfirmationDialog {
        id: deleteConfirmationDialog
        title: i18n.tr("Delete Contact")
        message: i18n.tr("Are you really sure you want to delete this contact?")
        confirmText: i18n.tr("Delete")
        cancelText: i18n.tr("Cancel")
        
        onConfirmed: {
            if (contactToDelete > 0) {
                if (contactsService.deleteContact(contactToDelete)) {
                    // Refresh the contact list
                    recentsContainer.refreshContacts()
                    console.log("Contact deleted successfully")
                }
                contactToDelete = -1
            }
        }
        
        onCancelled: {
            contactToDelete = -1
        }
    }
    
    Component.onCompleted: {
        refreshContacts()
    }
    
    function refreshContacts() {
        allContactsModel = contactsService.getAllContactsSorted()
    }

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(1)
        spacing: units.gu(1)

        Label {
            text: i18n.tr("All Contacts")
            fontSize: "medium"
            font.bold: true
            anchors.left: parent.left
        }

        ListView {
            id: contactsList
            width: parent.width
            height: parent.height - units.gu(3)
            clip: true
            spacing: units.gu(0.5)
            model: allContactsModel

            delegate: ContactListItemDelegate {
                contactData: modelData
                onClicked: {
                    recentsContainer.contactClicked(modelData.id)
                }
                onCallClicked: {
                    console.log("Call clicked for contact:", modelData.fullName, modelData.phone)
                    // TODO: Implement call functionality
                }
                onMessageClicked: {
                    console.log("Message clicked for contact:", modelData.fullName, modelData.phone)
                    // TODO: Implement message functionality
                }
                onDeleteClicked: {
                    console.log("Delete clicked for contact:", modelData.id)
                    contactToDelete = modelData.id
                    deleteConfirmationDialog.show()
                }
            }

            Label {
                anchors.centerIn: parent
                text: i18n.tr("No contacts")
                visible: contactsList.count === 0
                fontSize: "medium"
                color: theme.palette.normal.backgroundSecondaryText
            }
        }
    }
}

