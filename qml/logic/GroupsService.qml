// Groups Service - QML component for accessing group data
import QtQuick 2.7
import "ContactsData.js" as ContactsData

QtObject {
    id: groupsService

    // Get all groups
    function getAllGroups() {
        return ContactsData.getAllGroups();
    }

    // Get group by ID
    function getGroupById(id) {
        return ContactsData.getGroupById(id);
    }

    // Create a new group
    function createGroup(groupData) {
        return ContactsData.createGroup(groupData);
    }

    // Update group
    function updateGroup(id, updatedData) {
        return ContactsData.updateGroup(id, updatedData);
    }

    // Delete group
    function deleteGroup(id) {
        return ContactsData.deleteGroup(id);
    }

    // Get contacts in a group
    function getContactsInGroup(groupId) {
        var contacts = ContactsData.getContactsInGroup(groupId);
        return resolveAvatarPaths(contacts);
    }

    // Add contact to group
    function addContactToGroup(groupId, contactId) {
        return ContactsData.addContactToGroup(groupId, contactId);
    }

    // Remove contact from group
    function removeContactFromGroup(groupId, contactId) {
        return ContactsData.removeContactFromGroup(groupId, contactId);
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
}


