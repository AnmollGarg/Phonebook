// Contacts Data Service - Centralized contact information
// Demo contact database
var contacts = [
    {
        id: 1,
        firstName: "John",
        lastName: "Doe",
        fullName: "John Doe",
        phone: "+1 234-567-8900",
        countryCode: "+1",
        email: "john.doe@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: true
    },
    {
        id: 2,
        firstName: "Jane",
        lastName: "Smith",
        fullName: "Jane Smith",
        phone: "+44 20 7946 0958",
        countryCode: "+44",
        email: "jane.smith@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: true
    },
    {
        id: 3,
        firstName: "Bob",
        lastName: "Johnson",
        fullName: "Bob Johnson",
        phone: "+1 555-123-4567",
        countryCode: "+1",
        email: "bob.johnson@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: true
    },
    {
        id: 4,
        firstName: "Alice",
        lastName: "Brown",
        fullName: "Alice Brown",
        phone: "+33 1 42 86 83 26",
        countryCode: "+33",
        email: "alice.brown@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: true
    },
    {
        id: 5,
        firstName: "Charlie",
        lastName: "Wilson",
        fullName: "Charlie Wilson",
        phone: "+49 30 2273 0",
        countryCode: "+49",
        email: "charlie.wilson@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: true
    },
    {
        id: 6,
        firstName: "David",
        lastName: "Lee",
        fullName: "David Lee",
        phone: "+81 3 1234 5678",
        countryCode: "+81",
        email: "david.lee@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 7,
        firstName: "Emma",
        lastName: "Johnson",
        fullName: "Emma Johnson",
        phone: "+44 20 7946 0958",
        countryCode: "+44",
        email: "emma.johnson@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 8,
        firstName: "Frank",
        lastName: "Brown",
        fullName: "Frank Brown",
        phone: "+33 1 42 86 83 26",
        countryCode: "+33",
        email: "frank.brown@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 9,
        firstName: "George",
        lastName: "Wilson",
        fullName: "George Wilson",
        phone: "+49 30 2273 0",
        countryCode: "+49",
        email: "george.wilson@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 10,
        firstName: "Henry",
        lastName: "Lee",
        fullName: "Henry Lee",
        phone: "+81 3 1234 5678",
        countryCode: "+81",
        email: "henry.lee@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 11,
        firstName: "Isaac",
        lastName: "Brown",
        fullName: "Isaac Brown",
        phone: "+33 1 42 86 83 26",
        countryCode: "+33",
        email: "isaac.brown@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 12,
        firstName: "Jacob",
        lastName: "Wilson",
        fullName: "Jacob Wilson",
        phone: "+49 30 2273 0",
        countryCode: "+49",
        email: "jacob.wilson@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 13,
        firstName: "James",
        lastName: "Lee",
        fullName: "James Lee",
        phone: "+81 3 1234 5678",
        countryCode: "+81",
        email: "james.lee@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    },
    {
        id: 14,
        firstName: "John",
        lastName: "Doe",
        fullName: "John Doe",
        phone: "+1 234-567-8900",
        countryCode: "+1",
        email: "john.doe@example.com",
        avatar: "../../assets/avatar.png",
        isFavorite: false
    }
];

// Recent calls data
//use contact id between the 1 to 14 for the recent calls
var recentCalls = [
    { contactId: 1, time: "2:30 PM", type: "incoming" },
    { contactId: 2, time: "1:15 PM", type: "missed" },
    { contactId: 3, time: "12:45 PM", type: "outgoing" },
    { contactId: 4, time: "11:20 AM", type: "incoming" },
    { contactId: 5, time: "10:05 AM", type: "missed" },
    { contactId: 6, time: "9:30 AM", type: "outgoing" },
    { contactId: 7, time: "8:15 AM", type: "incoming" },
    { contactId: 8, time: "7:00 AM", type: "missed" },
    { contactId: 9, time: "6:45 AM", type: "outgoing" },
    { contactId: 10, time: "5:30 AM", type: "incoming" },
    { contactId: 11, time: "4:15 AM", type: "missed" },
    { contactId: 12, time: "3:00 AM", type: "outgoing" },
    { contactId: 13, time: "2:45 AM", type: "incoming" },
    { contactId: 14, time: "1:30 AM", type: "missed" },
    { contactId: 3, time: "12:15 AM", type: "outgoing" },
    { contactId: 1, time: "11:00 PM", type: "incoming" },
    { contactId: 5, time: "9:45 PM", type: "missed" },
    { contactId: 7, time: "8:30 PM", type: "outgoing" },
    { contactId: 9, time: "7:15 PM", type: "incoming" },
    { contactId: 11, time: "6:00 PM", type: "missed" },
    { contactId: 13, time: "4:45 PM", type: "outgoing" },
    { contactId: 2, time: "3:30 PM", type: "incoming" },
    { contactId: 4, time: "2:15 PM", type: "missed" },
    { contactId: 6, time: "1:00 PM", type: "outgoing" },
    { contactId: 8, time: "12:45 PM", type: "incoming" },
    { contactId: 10, time: "11:30 AM", type: "missed" },
    { contactId: 12, time: "10:15 AM", type: "outgoing" },
    { contactId: 14, time: "9:00 AM", type: "incoming" },
    { contactId: 1, time: "7:45 AM", type: "missed" },
    { contactId: 3, time: "6:30 AM", type: "outgoing" },
    { contactId: 5, time: "5:15 AM", type: "incoming" },
    { contactId: 7, time: "4:00 AM", type: "missed" },
    { contactId: 9, time: "2:45 AM", type: "outgoing" },
    { contactId: 11, time: "1:30 AM", type: "incoming" },
    { contactId: 13, time: "12:15 AM", type: "missed" },
    { contactId: 2, time: "11:00 PM", type: "outgoing" },
    { contactId: 4, time: "9:45 PM", type: "incoming" },
    { contactId: 6, time: "8:30 PM", type: "missed" },
    { contactId: 8, time: "7:15 PM", type: "outgoing" },
    { contactId: 10, time: "6:00 PM", type: "incoming" },
    { contactId: 12, time: "4:45 PM", type: "missed" },
    { contactId: 14, time: "3:30 PM", type: "outgoing" },
    { contactId: 1, time: "2:15 PM", type: "incoming" },
    { contactId: 3, time: "1:00 PM", type: "missed" },
    { contactId: 5, time: "12:45 PM", type: "outgoing" },
    { contactId: 7, time: "11:30 AM", type: "incoming" },
    { contactId: 9, time: "10:15 AM", type: "missed" },
    { contactId: 11, time: "9:00 AM", type: "outgoing" },
    { contactId: 13, time: "7:45 AM", type: "incoming" },
    { contactId: 2, time: "6:30 AM", type: "missed" },
    { contactId: 4, time: "5:15 AM", type: "outgoing" },
    { contactId: 6, time: "4:00 AM", type: "incoming" },
    { contactId: 8, time: "2:45 AM", type: "missed" },
    { contactId: 10, time: "1:30 AM", type: "outgoing" },
    { contactId: 12, time: "12:15 AM", type: "incoming" },
    { contactId: 14, time: "11:00 PM", type: "missed" },
    { contactId: 1, time: "9:45 PM", type: "outgoing" },
    { contactId: 3, time: "8:30 PM", type: "incoming" },
    { contactId: 5, time: "7:15 PM", type: "missed" },
    { contactId: 7, time: "6:00 PM", type: "outgoing" },
    { contactId: 9, time: "4:45 PM", type: "incoming" },
    { contactId: 11, time: "3:30 PM", type: "missed" },
    { contactId: 13, time: "2:15 PM", type: "outgoing" },
    { contactId: 2, time: "1:00 PM", type: "incoming" },
    { contactId: 4, time: "12:45 PM", type: "missed" },
    { contactId: 6, time: "11:30 AM", type: "outgoing" },
    { contactId: 8, time: "10:15 AM", type: "incoming" },
    { contactId: 10, time: "9:00 AM", type: "missed" },
    { contactId: 12, time: "7:45 AM", type: "outgoing" },
    { contactId: 14, time: "6:30 AM", type: "incoming" },
    { contactId: 1, time: "5:15 AM", type: "missed" },
    { contactId: 3, time: "4:00 AM", type: "outgoing" },
    { contactId: 5, time: "2:45 AM", type: "incoming" },
    { contactId: 7, time: "1:30 AM", type: "missed" },
    { contactId: 9, time: "12:15 AM", type: "outgoing" },
    { contactId: 11, time: "11:00 PM", type: "incoming" },
    { contactId: 13, time: "9:45 PM", type: "missed" },
    { contactId: 2, time: "8:30 PM", type: "outgoing" },
    { contactId: 4, time: "7:15 PM", type: "incoming" },
    { contactId: 6, time: "6:00 PM", type: "missed" },
    { contactId: 8, time: "4:45 PM", type: "outgoing" },
    { contactId: 10, time: "3:30 PM", type: "incoming" },
    { contactId: 12, time: "2:15 PM", type: "missed" },
    { contactId: 14, time: "1:00 PM", type: "outgoing" },
    { contactId: 1, time: "12:45 PM", type: "incoming" },
];

// Get all contacts
function getAllContacts() {
    return contacts;
}

// Get all contacts sorted alphabetically by full name
function getAllContactsSorted() {
    var sortedContacts = contacts.slice(); // Create a copy
    sortedContacts.sort(function(a, b) {
        var nameA = (a.fullName || "").toLowerCase();
        var nameB = (b.fullName || "").toLowerCase();
        if (nameA < nameB) return -1;
        if (nameA > nameB) return 1;
        return 0;
    });
    return sortedContacts;
}

// Get favorite contacts
function getFavorites() {
    return contacts.filter(function(contact) {
        return contact.isFavorite;
    });
}

// Get contact by ID
function getContactById(id) {
    for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].id === id) {
            return contacts[i];
        }
    }
    return null;
}

// Get recent calls with contact information
function getRecentCalls() {
    var calls = [];
    for (var i = 0; i < recentCalls.length; i++) {
        var call = recentCalls[i];
        var contact = getContactById(call.contactId);
        if (contact) {
            calls.push({
                name: contact.fullName,
                phone: contact.phone,
                time: call.time,
                type: call.type,
                contactId: contact.id
            });
        }
    }
    return calls;
}

// Get call history for a specific contact
function getCallHistoryByContactId(contactId) {
    var calls = [];
    var contact = getContactById(contactId);
    if (!contact) {
        return calls;
    }
    
    for (var i = 0; i < recentCalls.length; i++) {
        var call = recentCalls[i];
        if (call.contactId === contactId) {
            calls.push({
                name: contact.fullName,
                phone: contact.phone,
                time: call.time,
                type: call.type,
                contactId: contact.id
            });
        }
    }
    return calls;
}

// Search contacts by name or phone
function searchContacts(query) {
    if (!query || query.trim() === "") {
        return contacts;
    }
    
    var lowerQuery = query.toLowerCase();
    return contacts.filter(function(contact) {
        return contact.fullName.toLowerCase().indexOf(lowerQuery) !== -1 ||
               contact.phone.indexOf(query) !== -1 ||
               contact.firstName.toLowerCase().indexOf(lowerQuery) !== -1 ||
               contact.lastName.toLowerCase().indexOf(lowerQuery) !== -1;
    });
}

// Create a new contact
function createContact(contactData) {
    // Find the highest ID and increment
    var maxId = 0;
    for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].id > maxId) {
            maxId = contacts[i].id;
        }
    }
    
    var newId = maxId + 1;
    var firstName = contactData.firstName || "";
    var lastName = contactData.lastName || "";
    var fullName = contactData.fullName || (firstName + " " + lastName).trim();
    if (fullName === "") {
        fullName = firstName || lastName || "New Contact";
    }
    
    var newContact = {
        id: newId,
        firstName: firstName,
        lastName: lastName,
        fullName: fullName,
        phone: contactData.phone || "",
        countryCode: contactData.countryCode || "",
        email: contactData.email || "",
        avatar: contactData.avatar || "../../assets/avatar.png",
        isFavorite: contactData.isFavorite || false
    };
    
    contacts.push(newContact);
    return newContact;
}

// Update contact by ID
function updateContact(id, updatedData) {
    for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].id === id) {
            // Update all provided fields
            if (updatedData.firstName !== undefined) {
                contacts[i].firstName = updatedData.firstName;
            }
            if (updatedData.lastName !== undefined) {
                contacts[i].lastName = updatedData.lastName;
            }
            if (updatedData.fullName !== undefined) {
                contacts[i].fullName = updatedData.fullName;
            } else if (updatedData.firstName !== undefined || updatedData.lastName !== undefined) {
                // Reconstruct fullName if firstName or lastName changed
                var firstName = updatedData.firstName !== undefined ? updatedData.firstName : contacts[i].firstName;
                var lastName = updatedData.lastName !== undefined ? updatedData.lastName : contacts[i].lastName;
                contacts[i].fullName = (firstName + " " + lastName).trim();
            }
            if (updatedData.phone !== undefined) {
                contacts[i].phone = updatedData.phone;
            }
            if (updatedData.countryCode !== undefined) {
                contacts[i].countryCode = updatedData.countryCode;
            }
            if (updatedData.email !== undefined) {
                contacts[i].email = updatedData.email;
            }
            if (updatedData.isFavorite !== undefined) {
                contacts[i].isFavorite = updatedData.isFavorite;
            }
            if (updatedData.avatar !== undefined) {
                contacts[i].avatar = updatedData.avatar;
            }
            if (updatedData.contactType !== undefined) {
                contacts[i].contactType = updatedData.contactType;
            }
            if (updatedData.notes !== undefined) {
                contacts[i].notes = updatedData.notes;
            }
            return contacts[i];
        }
    }
    return null;
}

// Delete contact by ID
function deleteContact(id) {
    for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].id === id) {
            contacts.splice(i, 1);
            // Also remove contact from all groups
            for (var j = 0; j < groups.length; j++) {
                var contactIndex = groups[j].contactIds.indexOf(id);
                if (contactIndex !== -1) {
                    groups[j].contactIds.splice(contactIndex, 1);
                }
            }
            return true;
        }
    }
    return false;
}

// Groups data storage
var groups = [
    {
        id: 1,
        name: "Family",
        description: "Family members and relatives",
        contactIds: [1, 2, 3]
    },
    {
        id: 2,
        name: "Work",
        description: "Colleagues and work contacts",
        contactIds: [4, 5, 6]
    },
    {
        id: 3,
        name: "Friends",
        description: "Close friends",
        contactIds: [7, 8, 9]
    }
];

// Get all groups
function getAllGroups() {
    return groups;
}

// Get group by ID
function getGroupById(id) {
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].id === id) {
            return groups[i];
        }
    }
    return null;
}

// Create a new group
function createGroup(groupData) {
    // Find the highest ID and increment
    var maxId = 0;
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].id > maxId) {
            maxId = groups[i].id;
        }
    }
    
    var newId = maxId + 1;
    var newGroup = {
        id: newId,
        name: groupData.name || "New Group",
        description: groupData.description || "",
        contactIds: groupData.contactIds || []
    };
    
    groups.push(newGroup);
    return newGroup;
}

// Update group by ID
function updateGroup(id, updatedData) {
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].id === id) {
            if (updatedData.name !== undefined) {
                groups[i].name = updatedData.name;
            }
            if (updatedData.description !== undefined) {
                groups[i].description = updatedData.description;
            }
            if (updatedData.contactIds !== undefined) {
                groups[i].contactIds = updatedData.contactIds;
            }
            return groups[i];
        }
    }
    return null;
}

// Delete group by ID
function deleteGroup(id) {
    for (var i = 0; i < groups.length; i++) {
        if (groups[i].id === id) {
            groups.splice(i, 1);
            return true;
        }
    }
    return false;
}

// Get contacts in a group
function getContactsInGroup(groupId) {
    var group = getGroupById(groupId);
    if (!group) {
        return [];
    }
    
    var groupContacts = [];
    for (var i = 0; i < group.contactIds.length; i++) {
        var contact = getContactById(group.contactIds[i]);
        if (contact) {
            groupContacts.push(contact);
        }
    }
    return groupContacts;
}

// Add contact to group
function addContactToGroup(groupId, contactId) {
    var group = getGroupById(groupId);
    if (!group) {
        return false;
    }
    
    if (group.contactIds.indexOf(contactId) === -1) {
        group.contactIds.push(contactId);
        return true;
    }
    return false;
}

// Remove contact from group
function removeContactFromGroup(groupId, contactId) {
    var group = getGroupById(groupId);
    if (!group) {
        return false;
    }
    
    var index = group.contactIds.indexOf(contactId);
    if (index !== -1) {
        group.contactIds.splice(index, 1);
        return true;
    }
    return false;
}

