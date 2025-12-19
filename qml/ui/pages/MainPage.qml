import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components/input" 1.0
import "../components/display" 1.0
import "../components/widget" 1.0
import "../../logic" 1.0

Page {
    id: mainPage
    anchors.fill: parent

    property bool isSearchMode: false
    property string searchText: ""
    property var allContacts: []
    property var filteredContacts: []

    signal avatarClicked()
    signal settingsClicked()

    ContactsService {
        id: contactsService
    }

    Component.onCompleted: {
        allContacts = contactsService.getAllContactsSorted()
        filteredContacts = allContacts
    }

    function toggleSearch() {
        isSearchMode = !isSearchMode
        if (!isSearchMode) {
            searchText = ""
            filteredContacts = allContacts
        } else {
            searchBox.searchField.forceActiveFocus()
        }
    }

    function performSearch(text) {
        searchText = text
        if (text.trim() === "") {
            filteredContacts = allContacts
        } else {
            filteredContacts = contactsService.searchContacts(text)
        }
    }

    header: PageHeader {
        title: i18n.tr("Phonebook")
        
        trailingActionBar.actions: [
            Action {
                iconName: isSearchMode ? "close" : "search"
                text: isSearchMode ? i18n.tr("Close Search") : i18n.tr("Search")
                onTriggered: {
                    toggleSearch()
                }
            },
            Action {
                iconName: "settings"
                text: i18n.tr("Settings")
                onTriggered: {
                    console.log("MainPage: settingsClicked signal received")
                    mainPage.settingsClicked()
                }
            },
            Action {
                iconName: "contact"
                text: i18n.tr("Profile")
                onTriggered: {
                    console.log("MainPage: avatarClicked signal received")
                    mainPage.avatarClicked()
                }
            }
        ]
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: header.height

        Column {
            anchors.fill: parent
            spacing: units.gu(1)

            // Search Field - shown when in search mode
            SearchBox {
                id: searchBox
                width: parent.width
                showAvatar: false
                editable: true
                visible: isSearchMode
                
                onSearchTextChanged: {
                    performSearch(text)
                }
            }

            Favorites {
                id: favorites
                width: parent.width
                visible: !isSearchMode
                onContactClicked: function(contactId) {
                    var pageStack = findPageStack(mainPage)
                    if (pageStack) {
                        console.log("Opening ContactInfoPage for contact ID:", contactId)
                        var pageUrl = Qt.resolvedUrl("../../ui/pages/ContactInfoPage.qml")
                        console.log("Resolved URL:", pageUrl)
                        pageStack.addPageToNextColumn(mainPage, pageUrl, {contactId: contactId})
                    } else {
                        console.log("Error: Could not find pageStack")
                    }
                }
            }

            // Search Results - shown when in search mode
            Item {
                width: parent.width
                height: parent.height - searchBox.height - units.gu(1)
                visible: isSearchMode

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: units.gu(1)
                    spacing: units.gu(1)

                    Label {
                        text: i18n.tr("Search Results")
                        fontSize: "medium"
                        font.bold: true
                        width: parent.width
                    }

                    ListView {
                        id: searchResultsList
                        width: parent.width
                        height: parent.height - units.gu(3)
                        clip: true
                        spacing: units.gu(0.5)
                        model: filteredContacts

                        delegate: ContactListItemDelegate {
                            contactData: modelData
                            onClicked: {
                                var pageStack = findPageStack(mainPage)
                                if (pageStack) {
                                    console.log("Opening ContactInfoPage for contact ID:", modelData.id)
                                    var pageUrl = Qt.resolvedUrl("../../ui/pages/ContactInfoPage.qml")
                                    console.log("Resolved URL:", pageUrl)
                                    pageStack.addPageToNextColumn(mainPage, pageUrl, {contactId: modelData.id})
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
                                    // Refresh contacts
                                    allContacts = contactsService.getAllContactsSorted()
                                    performSearch(searchText)
                                    console.log("Contact deleted successfully")
                                }
                            }
                        }

                        Label {
                            anchors.centerIn: parent
                            text: i18n.tr("No contacts found")
                            visible: searchResultsList.count === 0 && searchText.trim() !== ""
                            fontSize: "medium"
                            color: theme.palette.normal.backgroundSecondaryText
                        }
                    }
                }
            }

            // Normal view - Recents (shown when not in search mode)
            Item {
                width: parent.width
                height: parent.height - favorites.height - units.gu(1)
                visible: !isSearchMode

                Recents {
                    id: recentsComponent
                    anchors.fill: parent
                    onContactClicked: function(contactId) {
                        var pageStack = findPageStack(mainPage)
                        if (pageStack) {
                            console.log("Opening ContactInfoPage for contact ID:", contactId)
                            var pageUrl = Qt.resolvedUrl("../../ui/pages/ContactInfoPage.qml")
                            console.log("Resolved URL:", pageUrl)
                            pageStack.addPageToNextColumn(mainPage, pageUrl, {contactId: contactId})
                        } else {
                            console.log("Error: Could not find pageStack")
                        }
                    }
                }
            }
        }
    }

    // Floating Action Button for creating new contact
    FloatingActionButton {
        id: fab
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: units.gu(2)
        iconName: "add"
        z: 10
        
        onClicked: {
            var pageStack = findPageStack(mainPage)
            if (pageStack) {
                console.log("Opening NewContactPage")
                var pageUrl = Qt.resolvedUrl("../../ui/pages/NewContactPage.qml")
                console.log("Resolved URL:", pageUrl)
                pageStack.addPageToNextColumn(mainPage, pageUrl)
            } else {
                console.log("Error: Could not find pageStack")
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

