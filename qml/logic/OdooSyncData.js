// Odoo Sync Data - Database operations for Odoo accounts and synced contacts
// Note: This file uses QtQuick.LocalStorage 2.0 which must be imported in the calling QML

// Database name constant
var DB_NAME = "phonebookDatabase"
var DB_VERSION = "1.0"
var DB_DESCRIPTION = "Phonebook Database"
var DB_SIZE = 1000000

// Initialize local database tables
function initLocalTables() {
    try {
        var db = LocalStorage.openDatabaseSync(DB_NAME, DB_VERSION, DB_DESCRIPTION, DB_SIZE)
        db.transaction(function(tx) {
            // Odoo accounts table
            tx.executeSql('CREATE TABLE IF NOT EXISTS odoo_accounts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, server_url TEXT NOT NULL, database TEXT NOT NULL, username TEXT NOT NULL, api_key TEXT, password TEXT, created_at TEXT)')
            
            // Cached contacts from Odoo (for offline use)
            tx.executeSql('CREATE TABLE IF NOT EXISTS cached_odoo_contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, account_id INTEGER NOT NULL, odoo_record_id INTEGER, name TEXT, phone TEXT, email TEXT, last_updated TEXT)')
        })
        return true
    } catch (e) {
        console.log("Error initializing local tables:", e)
        return false
    }
}

// Get database connection
function getDatabase() {
    return LocalStorage.openDatabaseSync(DB_NAME, DB_VERSION, DB_DESCRIPTION, DB_SIZE)
}

// Load all saved accounts
function getAllAccounts() {
    try {
        var db = getDatabase()
        var accounts = []
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM odoo_accounts ORDER BY id DESC')
            for (var i = 0; i < result.rows.length; i++) {
                accounts.push(result.rows.item(i))
            }
        })
        return accounts
    } catch (e) {
        console.log("Error loading accounts:", e)
        return []
    }
}

// Get account by ID
function getAccountById(accountId) {
    try {
        var db = getDatabase()
        var account = null
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM odoo_accounts WHERE id = ?', [accountId])
            if (result.rows.length > 0) {
                account = result.rows.item(0)
            }
        })
        return account
    } catch (e) {
        console.log("Error loading account:", e)
        return null
    }
}

// Save a new account
function saveAccount(name, serverUrl, database, username, apiKey, password) {
    try {
        var db = getDatabase()
        db.transaction(function(tx) {
            tx.executeSql('INSERT INTO odoo_accounts (name, server_url, database, username, api_key, password, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [name, serverUrl, database, username, apiKey || "", password || "", new Date().toISOString()])
        })
        return true
    } catch (e) {
        console.log("Error saving account:", e)
        return false
    }
}

// Update an existing account
function updateAccount(accountId, name, serverUrl, database, username, apiKey, password) {
    try {
        var db = getDatabase()
        db.transaction(function(tx) {
            tx.executeSql('UPDATE odoo_accounts SET name = ?, server_url = ?, database = ?, username = ?, api_key = ?, password = ? WHERE id = ?',
                [name, serverUrl, database, username, apiKey || "", password || "", accountId])
        })
        return true
    } catch (e) {
        console.log("Error updating account:", e)
        return false
    }
}

// Delete an account
function deleteAccount(accountId) {
    try {
        var db = getDatabase()
        db.transaction(function(tx) {
            tx.executeSql('DELETE FROM odoo_accounts WHERE id = ?', [accountId])
            // Also delete cached contacts for this account
            tx.executeSql('DELETE FROM cached_odoo_contacts WHERE account_id = ?', [accountId])
        })
        return true
    } catch (e) {
        console.log("Error deleting account:", e)
        return false
    }
}

// Save synced contacts to cache
function saveSyncedContacts(accountId, contacts) {
    try {
        var db = getDatabase()
        var now = new Date().toISOString()
        db.transaction(function(tx) {
            // Clear old cached contacts for this account
            tx.executeSql('DELETE FROM cached_odoo_contacts WHERE account_id = ?', [accountId])
            
            // Insert new contacts
            for (var i = 0; i < contacts.length; i++) {
                var contact = contacts[i]
                var name = contact.name || ""
                var phone = contact.phone || contact.mobile || ""
                var email = contact.email || ""
                var isCompany = contact.is_company ? 1 : 0
                
                tx.executeSql(
                    'INSERT INTO cached_odoo_contacts (account_id, odoo_record_id, name, phone, email, last_updated) VALUES (?, ?, ?, ?, ?, ?)',
                    [accountId, contact.id, name, phone, email, now]
                )
            }
        })
        return true
    } catch (e) {
        console.log("Error saving synced contacts:", e)
        return false
    }
}

// Get synced contacts for an account
function getSyncedContacts(accountId) {
    try {
        var db = getDatabase()
        var contacts = []
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM cached_odoo_contacts WHERE account_id = ? ORDER BY name', [accountId])
            for (var i = 0; i < result.rows.length; i++) {
                var row = result.rows.item(i)
                contacts.push({
                    odoo_record_id: row.odoo_record_id,
                    name: row.name || "Unnamed Contact",
                    phone: row.phone || "",
                    email: row.email || ""
                })
            }
        })
        return contacts
    } catch (e) {
        console.log("Error fetching synced contacts:", e)
        return []
    }
}

// Get cached contacts for import
function getCachedContactsForImport(accountId) {
    try {
        var db = getDatabase()
        var contacts = []
        db.transaction(function(tx) {
            var result = tx.executeSql('SELECT * FROM cached_odoo_contacts WHERE account_id = ?', [accountId])
            for (var i = 0; i < result.rows.length; i++) {
                contacts.push(result.rows.item(i))
            }
        })
        return contacts
    } catch (e) {
        console.log("Error fetching cached contacts:", e)
        return []
    }
}

