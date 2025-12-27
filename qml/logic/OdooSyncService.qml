// Odoo Sync Service - Service interface for Odoo sync operations
import QtQuick 2.7
import QtQuick.LocalStorage 2.0
import "OdooSyncData.js" as OdooSyncData
import "ContactsData.js" as ContactsData

QtObject {
    id: odooSyncService
    
    // Initialize database tables
    function initDatabase() {
        return OdooSyncData.initLocalTables()
    }
    
    // Account management
    function getAllAccounts() {
        return OdooSyncData.getAllAccounts()
    }
    
    function getAccountById(accountId) {
        return OdooSyncData.getAccountById(accountId)
    }
    
    function saveAccount(name, serverUrl, database, username, apiKey, password) {
        return OdooSyncData.saveAccount(name, serverUrl, database, username, apiKey, password)
    }
    
    function updateAccount(accountId, name, serverUrl, database, username, apiKey, password) {
        return OdooSyncData.updateAccount(accountId, name, serverUrl, database, username, apiKey, password)
    }
    
    function deleteAccount(accountId) {
        return OdooSyncData.deleteAccount(accountId)
    }
    
    // Normalize URL
    function normalizeUrl(url) {
        var normalized = url.trim()
        
        // Remove any malformed protocol prefixes
        normalized = normalized.replace(/^https?:\/\/+/, "")
        normalized = normalized.replace(/^ttp:\/\//, "")
        normalized = normalized.replace(/^ttps:\/\//, "")
        normalized = normalized.replace(/^http:\/\/+/, "")
        normalized = normalized.replace(/^https:\/\/+/, "")
        
        // Remove leading slashes
        normalized = normalized.replace(/^\/+/, "")
        
        // Add https:// if no protocol specified
        if (!normalized.startsWith("http://") && !normalized.startsWith("https://")) {
            normalized = "https://" + normalized
        }
        
        return normalized
    }
    
    // Fetch databases from Odoo server
    function fetchDatabases(serverUrl, onSuccess, onError) {
        var url = normalizeUrl(serverUrl)
        var dbListUrl = url.replace(/\/$/, "") + "/web/database/list"
        
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 0) {
                    if (onError) onError("network_error", "Network error: Unable to connect to server")
                    return
                }
                
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText)
                        var dbList = []
                        
                        // Handle different response formats
                        if (response.result) {
                            if (Array.isArray(response.result)) {
                                dbList = response.result
                            } else if (response.result.databases && Array.isArray(response.result.databases)) {
                                dbList = response.result.databases
                            } else if (typeof response.result === 'object') {
                                for (var key in response.result) {
                                    if (Array.isArray(response.result[key])) {
                                        dbList = response.result[key]
                                        break
                                    }
                                }
                            }
                        } else if (Array.isArray(response)) {
                            dbList = response
                        }
                        
                        if (dbList.length > 0) {
                            if (onSuccess) onSuccess(dbList)
                        } else {
                            // Try alternative endpoint
                            tryAlternativeEndpoint(url, onSuccess, onError)
                        }
                    } catch (e) {
                        console.log("Error parsing database list:", e)
                        tryAlternativeEndpoint(url, onSuccess, onError)
                    }
                } else if (xhr.status === 404 || xhr.status === 405) {
                    tryAlternativeEndpoint(url, onSuccess, onError)
                } else {
                    if (onError) onError("http_error", "HTTP " + xhr.status)
                }
            }
        }
        
        xhr.onerror = function() {
            if (onError) onError("network_error", "Network error while fetching databases")
        }
        
        xhr.open("POST", dbListUrl)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.send(JSON.stringify({jsonrpc: "2.0", method: "call", params: {}, id: 1}))
    }
    
    // Try alternative endpoint
    function tryAlternativeEndpoint(baseUrl, onSuccess, onError) {
        var cleanUrl = baseUrl.replace(/\/$/, "")
        var altUrl = cleanUrl + "/web/database/selector"
        
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText)
                        var dbList = []
                        
                        if (response.result) {
                            if (Array.isArray(response.result)) {
                                dbList = response.result
                            } else if (response.result.databases) {
                                dbList = response.result.databases
                            }
                        }
                        
                        if (dbList.length > 0 && onSuccess) {
                            onSuccess(dbList)
                        } else if (onError) {
                            onError("no_databases", "Could not fetch databases automatically")
                        }
                    } catch (e) {
                        if (onError) onError("parse_error", "Error parsing response")
                    }
                } else if (onError) {
                    onError("http_error", "Could not fetch databases")
                }
            }
        }
        
        xhr.onerror = function() {
            if (onError) onError("network_error", "Network error")
        }
        
        xhr.open("POST", altUrl)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.send(JSON.stringify({jsonrpc: "2.0", method: "call", params: {}, id: 1}))
    }
    
    // Sync contacts from Odoo
    function syncContactsFromOdoo(account, onProgress, onComplete, onError) {
        var serverUrl = normalizeUrl(account.server_url)
        var url = serverUrl.replace(/\/$/, "") + "/jsonrpc"
        var database = account.database
        var username = account.username
        var auth = account.api_key || account.password
        
        // Step 1: Authenticate
        var authXhr = new XMLHttpRequest()
        authXhr.onreadystatechange = function() {
            if (authXhr.readyState === XMLHttpRequest.DONE && authXhr.status === 200) {
                try {
                    var authResponse = JSON.parse(authXhr.responseText)
                    if (authResponse.result && typeof authResponse.result === 'number' && authResponse.result > 0) {
                        var uid = authResponse.result
                        if (onProgress) onProgress(20, "Authenticated. Fetching contacts...")
                        
                        // Step 2: Fetch contacts
                        var contactsXhr = new XMLHttpRequest()
                        contactsXhr.onreadystatechange = function() {
                            if (contactsXhr.readyState === XMLHttpRequest.DONE && contactsXhr.status === 200) {
                                try {
                                    var contactsResponse = JSON.parse(contactsXhr.responseText)
                                    if (contactsResponse.result && !contactsResponse.error) {
                                        if (onProgress) onProgress(60, "Processing contacts...")
                                        
                                        // Process and save contacts
                                        var processed = processContacts(contactsResponse.result)
                                        OdooSyncData.saveSyncedContacts(account.id, processed)
                                        
                                        if (onProgress) onProgress(100, "Sync completed successfully!")
                                        if (onComplete) onComplete(processed)
                                    } else {
                                        if (onError) onError("sync_error", contactsResponse.error ? JSON.stringify(contactsResponse.error) : "Unknown error")
                                    }
                                } catch (e) {
                                    if (onError) onError("parse_error", "Error parsing response: " + e.toString())
                                }
                            }
                        }
                        
                        contactsXhr.onerror = function() {
                            if (onError) onError("network_error", "Network error while fetching contacts")
                        }
                        
                        contactsXhr.open("POST", url)
                        contactsXhr.setRequestHeader("Content-Type", "application/json")
                        var contactsData = {
                            jsonrpc: "2.0",
                            method: "call",
                            params: {
                                service: "object",
                                method: "execute_kw",
                                args: [
                                    database,
                                    uid,
                                    auth,
                                    "res.partner",
                                    "search_read",
                                    [[]],
                                    {
                                        fields: ["name", "id", "phone", "mobile", "email"],
                                        limit: 100
                                    }
                                ]
                            },
                            id: 2
                        }
                        contactsXhr.send(JSON.stringify(contactsData))
                    } else {
                        if (onError) onError("auth_error", "Authentication failed")
                    }
                } catch (e) {
                    if (onError) onError("auth_error", "Authentication error: " + e.toString())
                }
            }
        }
        
        authXhr.onerror = function() {
            if (onError) onError("network_error", "Network error during authentication")
        }
        
        authXhr.open("POST", url)
        authXhr.setRequestHeader("Content-Type", "application/json")
        var authData = {
            jsonrpc: "2.0",
            method: "call",
            params: {
                service: "common",
                method: "authenticate",
                args: [database, username, auth, {}]
            },
            id: 1
        }
        authXhr.send(JSON.stringify(authData))
    }
    
    // Process contacts from Odoo format
    function processContacts(odooContacts) {
        var processed = []
        for (var i = 0; i < odooContacts.length; i++) {
            var contact = odooContacts[i]
            processed.push({
                id: contact.id,
                name: contact.name || "",
                phone: contact.phone || contact.mobile || "",
                email: contact.email || ""
            })
        }
        return processed
    }
    
    // Get synced contacts
    function getSyncedContacts(accountId) {
        return OdooSyncData.getSyncedContacts(accountId)
    }
    
    // Import contacts to local contacts
    function importContactsToLocal(accountId) {
        var cachedContacts = OdooSyncData.getCachedContactsForImport(accountId)
        var importedCount = 0
        
        for (var i = 0; i < cachedContacts.length; i++) {
            var row = cachedContacts[i]
            var name = row.name || ""
            var nameParts = name.split(" ")
            var firstName = nameParts[0] || ""
            var lastName = nameParts.length > 1 ? nameParts.slice(1).join(" ") : ""
            
            // Check if contact already exists
            var allContacts = ContactsData.getAllContacts()
            var existing = false
            for (var j = 0; j < allContacts.length; j++) {
                if (allContacts[j].odoo_record_id && allContacts[j].odoo_record_id === row.odoo_record_id) {
                    existing = true
                    break
                }
            }
            
            if (!existing) {
                var contactData = {
                    firstName: firstName,
                    lastName: lastName,
                    fullName: name,
                    phone: row.phone || "",
                    email: row.email || "",
                    odoo_record_id: row.odoo_record_id,
                    sync_status: "synced",
                    account_id: accountId
                }
                ContactsData.createContact(contactData)
                importedCount++
            }
        }
        
        return importedCount
    }
}

