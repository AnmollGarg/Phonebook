// Search Page - Display all contacts with search functionality
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../logic" 1.0
import "../components/display" 1.0
import "../components/input" 1.0
import "." as Pages

Page {
    id: searchPage

    header: PageHeader {
        title: i18n.tr("Search Contacts")
    }

    ContactsService {
        id: contactsService
    }

    property var allContacts: contactsService.getAllContacts()
    property var filteredContacts: allContacts

    Column {
        anchors.fill: parent
        anchors.topMargin: header.height + units.gu(2)
        spacing: units.gu(1)

        // Search Field
        SearchBox {
            id: searchBox
            width: parent.width
            showAvatar: false
            editable: true
            
            Component.onCompleted: {
                searchField.forceActiveFocus()
            }
            
            onSearchTextChanged: {
                if (text.trim() === "") {
                    filteredContacts = allContacts;
                } else {
                    filteredContacts = contactsService.searchContacts(text);
                }
            }
        }

        // Search Results Label
        Label {
            text: i18n.tr("Search Results")
            fontSize: "medium"
            font.bold: true
            width: parent.width
            visible: searchBox.text.trim() !== ""
        }

        // Contacts List
        ListView {
            id: contactsList
            width: parent.width
            height: parent.height - searchBox.height - units.gu(2)
            clip: true
            spacing: units.gu(0.5)
            model: filteredContacts

            delegate: ContactListItemDelegate {
                contactData: modelData
                onClicked: {
                    var pageStack = findPageStack(searchPage)
                    if (pageStack) {
                        console.log("Opening ContactInfoPage for contact ID:", modelData.id)
                        // Use path relative to qml root, same as Main.qml does
                        var pageUrl = Qt.resolvedUrl("../../ui/pages/ContactInfoPage.qml")
                        console.log("Resolved URL:", pageUrl)
                        pageStack.addPageToNextColumn(searchPage, pageUrl, {contactId: modelData.id})
                    } else {
                        console.log("Error: Could not find pageStack")
                    }
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
                    if (contactsService.deleteContact(modelData.id)) {
                        // Refresh the contact list
                        allContacts = contactsService.getAllContacts()
                        if (searchBox.text.trim() === "") {
                            filteredContacts = allContacts
                        } else {
                            filteredContacts = contactsService.searchContacts(searchBox.text)
                        }
                        console.log("Contact deleted successfully")
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: i18n.tr("No contacts found")
                visible: contactsList.count === 0 && searchBox.text.trim() !== ""
                fontSize: "medium"
                color: theme.palette.normal.backgroundSecondaryText
            }
        }
    }

    function findPageStack(item) {
        var parent = item.parent
        while (parent) {
            if (parent.addPageToNextColumn) {
                return parent
            }
            parent = parent.parent
        }
        return null
    }
}

