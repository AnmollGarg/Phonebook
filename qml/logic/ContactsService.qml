// Contacts Service - QML component for accessing contact data
import QtQuick 2.7
import "ContactsData.js" as ContactsData

QtObject {
    id: contactsService

    // Get all contacts with resolved avatar paths
    function getAllContacts() {
        var contacts = ContactsData.getAllContacts();
        return resolveAvatarPaths(contacts);
    }

    // Get all contacts sorted alphabetically with resolved avatar paths
    function getAllContactsSorted() {
        var contacts = ContactsData.getAllContactsSorted();
        return resolveAvatarPaths(contacts);
    }

    // Get favorite contacts with resolved avatar paths
    function getFavorites() {
        var favorites = ContactsData.getFavorites();
        return resolveAvatarPaths(favorites);
    }

    // Get contact by ID with resolved avatar path
    function getContactById(id) {
        var contact = ContactsData.getContactById(id);
        if (contact) {
            return resolveAvatarPath(contact);
        }
        return null;
    }

    // Get recent calls with contact information
    function getRecentCalls() {
        return ContactsData.getRecentCalls();
    }

    // Search contacts
    function searchContacts(query) {
        var results = ContactsData.searchContacts(query);
        return resolveAvatarPaths(results);
    }

    // Resolve avatar path for a single contact
    function resolveAvatarPath(contact) {
        if (contact && contact.avatar) {
            var resolved = Qt.resolvedUrl(contact.avatar);
            contact.avatar = resolved;
        }
        return contact;
    }

    // Resolve avatar paths for multiple contacts
    function resolveAvatarPaths(contacts) {
        for (var i = 0; i < contacts.length; i++) {
            if (contacts[i].avatar) {
                contacts[i].avatar = Qt.resolvedUrl(contacts[i].avatar);
            }
        }
        return contacts;
    }

    // Update contact
    function updateContact(id, updatedData) {
        var updated = ContactsData.updateContact(id, updatedData);
        if (updated) {
            return resolveAvatarPath(updated);
        }
        return null;
    }

    // Get call history for a specific contact
    function getCallHistoryByContactId(contactId) {
        return ContactsData.getCallHistoryByContactId(contactId);
    }

    // Create a new contact
    function createContact(contactData) {
        var newContact = ContactsData.createContact(contactData);
        if (newContact) {
            return resolveAvatarPath(newContact);
        }
        return null;
    }

    // Delete a contact
    function deleteContact(id) {
        return ContactsData.deleteContact(id);
    }
}

