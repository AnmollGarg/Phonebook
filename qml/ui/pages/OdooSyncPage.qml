// Odoo Sync Page - Manage Odoo accounts and sync contacts
import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "../../logic" 1.0

Page {
    id: root
    
    header: PageHeader {
        title: i18n.tr("Odoo Sync")
    }
    
    // Properties
    property int currentAccountId: 0
    property bool isSyncing: false
    property int syncProgress: 0
    property string syncMessage: ""
    property bool showSyncedData: false
    property var syncedContacts: []
    property string dialogMessage: ""
    
    // Accounts model
    ListModel {
        id: accountsModel
    }
    
    // Databases list for account creation
    property var databases: []
    
    // Reference to the currently open add account dialog
    property var currentAddAccountDialog: null
    
    // Odoo Sync Service
    OdooSyncService {
        id: odooSyncService
    }
    
    // Load accounts on startup
    Component.onCompleted: {
        odooSyncService.initDatabase()
        loadAccounts()
    }
    
    // Load all saved accounts
    function loadAccounts() {
        var accounts = odooSyncService.getAllAccounts()
        accountsModel.clear()
        for (var i = 0; i < accounts.length; i++) {
            accountsModel.append(accounts[i])
        }
    }
    
    // Save a new account
    function saveAccount(name, serverUrl, database, username, apiKey, password) {
        if (odooSyncService.saveAccount(name, serverUrl, database, username, apiKey, password)) {
            loadAccounts()
        } else {
            root.dialogMessage = "Error saving account"
            PopupUtils.open(errorDialog, null)
        }
    }
    
    // Update an existing account
    function updateAccount(accountId, name, serverUrl, database, username, apiKey, password) {
        if (odooSyncService.updateAccount(accountId, name, serverUrl, database, username, apiKey, password)) {
            loadAccounts()
        } else {
            root.dialogMessage = "Error updating account"
            PopupUtils.open(errorDialog, null)
        }
    }
    
    // Delete an account
    function deleteAccount(accountId) {
        if (odooSyncService.deleteAccount(accountId)) {
            loadAccounts()
            if (currentAccountId === accountId) {
                showSyncedData = false
                syncedContacts = []
                syncMessage = ""
            }
        } else {
            root.dialogMessage = "Error deleting account"
            PopupUtils.open(errorDialog, null)
        }
    }
    
    // Fetch available databases from Odoo server
    function fetchDatabases(serverUrl) {
        odooSyncService.fetchDatabases(serverUrl,
            // onSuccess
            function(dbList) {
                databases = dbList
                Qt.callLater(function() {
                    var dialog = root.currentAddAccountDialog || addAccountDialog.item
                    if (dialog) {
                        dialog.step = 2
                    }
                })
            },
            // onError
            function(errorType, errorMessage) {
                root.dialogMessage = i18n.tr("Error fetching databases: ") + errorMessage + 
                                    i18n.tr("\n\nPlease try entering the database name manually.")
                PopupUtils.open(errorDialog, null)
                var dialog = root.currentAddAccountDialog
                if (dialog) {
                    dialog.step = 3
                }
            }
        )
    }
    
    // Start sync for an account
    function startSync(accountId) {
        if (isSyncing) {
            root.dialogMessage = "Sync already in progress"
            PopupUtils.open(errorDialog, null)
            return
        }
        
        isSyncing = true
        syncProgress = 0
        syncMessage = "Starting sync..."
        currentAccountId = accountId
        showSyncedData = false
        
        // Get account details
        var account = odooSyncService.getAccountById(accountId)
        if (!account) {
            root.dialogMessage = "Account not found"
            PopupUtils.open(errorDialog, null)
            isSyncing = false
            return
        }
        
        // Start sync process
        odooSyncService.syncContactsFromOdoo(account,
            // onProgress
            function(progress, message) {
                syncProgress = progress
                syncMessage = message
            },
            // onComplete
            function(contacts) {
                syncProgress = 100
                syncMessage = "Sync completed successfully!"
                isSyncing = false
                fetchSyncedContacts(accountId)
            },
            // onError
            function(errorType, errorMessage) {
                syncMessage = "Error: " + errorMessage
                isSyncing = false
            }
        )
    }
    
    // Fetch and display synced contacts
    function fetchSyncedContacts(accountId) {
        syncedContacts = odooSyncService.getSyncedContacts(accountId)
        showSyncedData = true
    }
    
    // Import contacts from Odoo cache to local contacts
    function importContactsToLocal() {
        var importedCount = odooSyncService.importContactsToLocal(currentAccountId)
        root.dialogMessage = i18n.tr("Imported ") + importedCount + i18n.tr(" contacts successfully!")
        PopupUtils.open(successDialog, null)
    }
    
    Flickable {
        anchors.fill: parent
        anchors.topMargin: header.height
        contentWidth: width
        contentHeight: contentColumn.height + units.gu(4)
        clip: true
        
        Column {
            id: contentColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(2)
            spacing: units.gu(2)
            
            // Accounts section
            Label {
                text: i18n.tr("Odoo Accounts")
                font.bold: true
                font.pixelSize: units.gu(2)
                width: parent.width
            }
            
            Button {
                text: i18n.tr("Add Account")
                width: parent.width
                onClicked: {
                    var dialog = PopupUtils.open(addAccountDialog, null)
                    root.currentAddAccountDialog = dialog
                }
            }
            
            // Accounts list
            ListView {
                width: parent.width
                height: Math.min(accountsModel.count * units.gu(7), units.gu(30))
                visible: accountsModel.count > 0
                spacing: units.gu(1)
                model: accountsModel
                delegate: Rectangle {
                    width: parent.width
                    height: units.gu(7)
                    color: "transparent"
                    
                    Column {
                        anchors.left: parent.left
                        anchors.right: actionButtons.left
                        anchors.rightMargin: units.gu(1)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: units.gu(0.3)
                        
                        Label {
                            text: model.name || "Unnamed Account"
                            font.bold: true
                            font.pixelSize: units.gu(1.8)
                            color: theme.palette.normal.baseText
                            elide: Text.ElideRight
                            width: parent.width
                        }
                        
                        Label {
                            text: model.server_url || ""
                            font.pixelSize: units.gu(1.4)
                            color: theme.palette.normal.backgroundSecondaryText
                            elide: Text.ElideMiddle
                            width: parent.width
                        }
                    }
                    
                    // Action buttons
                    Row {
                        id: actionButtons
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: units.gu(0.5)
                        
                        Button {
                            text: i18n.tr("Sync")
                            height: units.gu(3.5)
                            width: units.gu(7)
                            onClicked: root.startSync(model.id)
                        }
                        Button {
                            text: i18n.tr("Edit")
                            height: units.gu(3.5)
                            width: units.gu(6)
                            onClicked: PopupUtils.open(editAccountDialog, null, {
                                accountId: model.id,
                                account: model
                            })
                        }
                        Button {
                            text: i18n.tr("Delete")
                            height: units.gu(3.5)
                            width: units.gu(7)
                            color: "#E95420"
                            onClicked: PopupUtils.open(deleteConfirmDialog, null, {
                                accountId: model.id,
                                accountName: model.name || "Unnamed Account"
                            })
                        }
                    }
                }
            }
            
            // Empty state
            Label {
                text: i18n.tr("No accounts configured")
                font.pixelSize: units.gu(1.6)
                color: theme.palette.normal.backgroundSecondaryText
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                visible: accountsModel.count === 0
            }
            
            // Sync Status Section
            Column {
                width: parent.width
                spacing: units.gu(1)
                visible: isSyncing || syncProgress > 0
                
                Label {
                    text: i18n.tr("Sync Status")
                    font.bold: true
                    font.pixelSize: units.gu(2)
                    width: parent.width
                }
                
                ProgressBar {
                    width: parent.width
                    value: syncProgress
                    maximumValue: 100
                    visible: isSyncing
                }
                
                Label {
                    text: syncMessage
                    width: parent.width
                    font.pixelSize: units.gu(1.6)
                    color: isSyncing ? theme.palette.normal.backgroundSecondaryText : "#2ECC40"
                    visible: syncMessage !== ""
                }
            }
            
            // Synced Data Section
            Column {
                width: parent.width
                spacing: units.gu(1)
                visible: showSyncedData
                
                Label {
                    text: i18n.tr("Synced Contacts")
                    font.bold: true
                    font.pixelSize: units.gu(2)
                    width: parent.width
                }
                
                Button {
                    text: i18n.tr("Import to Contacts")
                    width: parent.width
                    visible: syncedContacts.length > 0
                    onClicked: {
                        importContactsToLocal()
                    }
                }
            }
            
            // Contacts display
            Column {
                width: parent.width
                spacing: units.gu(1)
                visible: showSyncedData && syncedContacts.length > 0
                
                Label {
                    text: i18n.tr("Contacts") + " (" + syncedContacts.length + ")"
                    font.bold: true
                    font.pixelSize: units.gu(1.8)
                    width: parent.width
                }
                
                Repeater {
                    model: syncedContacts.length > 20 ? 20 : syncedContacts.length
                    delegate: Column {
                        width: parent.width
                        spacing: units.gu(0.3)
                        
                        Label {
                            text: syncedContacts[index].name || "Unnamed Contact"
                            font.pixelSize: units.gu(1.7)
                            font.bold: true
                            color: theme.palette.normal.baseText
                            width: parent.width
                        }
                        
                        Row {
                            spacing: units.gu(2)
                            visible: syncedContacts[index].phone || syncedContacts[index].email
                            
                            Label {
                                text: syncedContacts[index].phone || ""
                                font.pixelSize: units.gu(1.4)
                                color: theme.palette.normal.backgroundSecondaryText
                                visible: syncedContacts[index].phone
                            }
                            
                            Label {
                                text: syncedContacts[index].email || ""
                                font.pixelSize: units.gu(1.4)
                                color: theme.palette.normal.backgroundSecondaryText
                                elide: Text.ElideMiddle
                                visible: syncedContacts[index].email
                            }
                        }
                    }
                }
                
                Label {
                    text: syncedContacts.length > 20 ? i18n.tr("... and ") + (syncedContacts.length - 20) + " more" : ""
                    font.pixelSize: units.gu(1.4)
                    color: "#666"
                    width: parent.width
                    visible: syncedContacts.length > 20
                }
            }
        }
    }
    
    // Add Account Dialog
    Component {
        id: addAccountDialog
        Dialog {
            id: dialog
            title: i18n.tr("Add Odoo Account")
            property int step: 1 // 1 = name/url, 2 = database, 3 = username, 4 = auth
            
            property string accountName: ""
            property string serverUrl: ""
            property string selectedDatabase: ""
            property string username: ""
            property string apiKey: ""
            property string password: ""
            property bool useApiKey: true
            
            Column {
                width: parent.width
                spacing: units.gu(2)
                
                // Step 1: Account name and server URL
                Column {
                    width: parent.width
                    spacing: units.gu(1)
                    visible: dialog.step === 1
                    
                    Label {
                        text: i18n.tr("Account Name")
                        width: parent.width
                    }
                    TextField {
                        id: accountNameField
                        width: parent.width
                        placeholderText: i18n.tr("My Company Odoo")
                    }
                    
                    Label {
                        text: i18n.tr("Server URL")
                        width: parent.width
                    }
                    TextField {
                        id: serverUrlField
                        width: parent.width
                        placeholderText: i18n.tr("https://yourcompany.odoo.com")
                    }
                    
                    Button {
                        id: fetchButton
                        text: i18n.tr("Fetch Databases")
                        width: parent.width
                        enabled: serverUrlField.text.trim() !== ""
                        onClicked: {
                            if (serverUrlField.text.trim() !== "") {
                                dialog.serverUrl = serverUrlField.text.trim()
                                fetchButton.text = i18n.tr("Fetching...")
                                fetchButton.enabled = false
                                root.fetchDatabases(dialog.serverUrl)
                                
                                // Re-enable button after a delay
                                Qt.callLater(function() {
                                    fetchButton.text = i18n.tr("Fetch Databases")
                                    fetchButton.enabled = true
                                })
                            }
                        }
                    }
                    
                    Label {
                        text: i18n.tr("Or continue without fetching to enter database name manually")
                        width: parent.width
                        font.pixelSize: units.gu(1.4)
                        color: "#666"
                        wrapMode: Text.Wrap
                        visible: serverUrlField.text.trim() !== ""
                    }
                    
                    Button {
                        text: i18n.tr("Skip - Enter Manually")
                        width: parent.width
                        visible: serverUrlField.text.trim() !== ""
                        onClicked: {
                            dialog.serverUrl = serverUrlField.text.trim()
                            dialog.step = 3 // Skip to username step
                        }
                    }
                }
                
                // Step 2: Database selection
                Column {
                    width: parent.width
                    spacing: units.gu(1)
                    visible: dialog.step === 2
                    
                    Label {
                        text: i18n.tr("Select Database")
                        width: parent.width
                    }
                    
                    Label {
                        text: root.databases.length > 0 ? (i18n.tr("Found ") + root.databases.length + i18n.tr(" database(s). Select one:")) : i18n.tr("No databases found")
                        width: parent.width
                        font.pixelSize: units.gu(1.6)
                        color: root.databases.length > 0 ? "#2ecc71" : "#e74c3c"
                        wrapMode: Text.Wrap
                    }
                    
                    ListView {
                        id: databaseListView
                        width: parent.width
                        height: Math.min(root.databases.length * units.gu(5), units.gu(20))
                        model: root.databases
                        visible: root.databases.length > 0
                        delegate: Rectangle {
                            width: parent.width
                            height: units.gu(5)
                            color: ListView.isCurrentItem ? theme.palette.normal.base : "transparent"
                            
                            Label {
                                text: modelData
                                anchors.left: parent.left
                                anchors.leftMargin: units.gu(1)
                                anchors.verticalCenter: parent.verticalCenter
                                color: ListView.isCurrentItem ? theme.palette.normal.baseText : theme.palette.normal.backgroundSecondaryText
                                font.pixelSize: units.gu(1.6)
                                font.bold: ListView.isCurrentItem
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    databaseListView.currentIndex = index
                                    if (dialog) {
                                        dialog.selectedDatabase = modelData
                                    } else if (root.currentAddAccountDialog) {
                                        root.currentAddAccountDialog.selectedDatabase = modelData
                                    }
                                }
                            }
                        }
                    }
                    
                    Label {
                        text: root.databases.length === 0 ? i18n.tr("Click 'Next' to enter database name manually") : ""
                        width: parent.width
                        font.pixelSize: units.gu(1.4)
                        color: "#666"
                        wrapMode: Text.Wrap
                        visible: root.databases.length === 0
                    }
                }
                
                // Step 3: Username and Database (if not selected)
                Column {
                    width: parent.width
                    spacing: units.gu(1)
                    visible: dialog.step === 3
                    
                    Label {
                        text: dialog.selectedDatabase ? (i18n.tr("Database: ") + dialog.selectedDatabase) : i18n.tr("Enter Database Name")
                        width: parent.width
                        font.bold: true
                    }
                    
                    TextField {
                        id: databaseField
                        width: parent.width
                        placeholderText: i18n.tr("Database name")
                        visible: !dialog.selectedDatabase
                        text: dialog.selectedDatabase || ""
                        onTextChanged: {
                            if (text) {
                                dialog.selectedDatabase = text
                            }
                        }
                    }
                    
                    Label {
                        text: i18n.tr("Username")
                        width: parent.width
                    }
                    TextField {
                        id: usernameField
                        width: parent.width
                        placeholderText: i18n.tr("your.email@company.com")
                    }
                }
                
                // Step 4: Authentication
                Column {
                    width: parent.width
                    spacing: units.gu(1)
                    visible: dialog.step === 4
                    
                    Label {
                        text: i18n.tr("Authentication Method")
                        width: parent.width
                    }
                    
                    Row {
                        width: parent.width
                        spacing: units.gu(2)
                        
                        Button {
                            text: i18n.tr("API Key")
                            width: parent.width / 2 - units.gu(1)
                            color: dialog.useApiKey ? "#3498db" : "#cccccc"
                            onClicked: dialog.useApiKey = true
                        }
                        Button {
                            text: i18n.tr("Password")
                            width: parent.width / 2 - units.gu(1)
                            color: !dialog.useApiKey ? "#3498db" : "#cccccc"
                            onClicked: dialog.useApiKey = false
                        }
                    }
                    
                    Label {
                        text: dialog.useApiKey ? i18n.tr("API Key") : i18n.tr("Password")
                        width: parent.width
                    }
                    TextField {
                        id: authField
                        width: parent.width
                        placeholderText: dialog.useApiKey ? i18n.tr("Enter API key") : i18n.tr("Enter password")
                        echoMode: dialog.useApiKey ? TextInput.Normal : TextInput.Password
                    }
                }
                
                // Navigation buttons
                Row {
                    width: parent.width
                    spacing: units.gu(1)
                    visible: dialog.step > 1
                    
                    Button {
                        text: i18n.tr("Back")
                        width: parent.width / 2 - units.gu(0.5)
                        onClicked: dialog.step--
                    }
                    Button {
                        text: dialog.step === 4 ? i18n.tr("Connect") : i18n.tr("Next")
                        width: parent.width / 2 - units.gu(0.5)
                        onClicked: {
                            if (dialog.step === 4) {
                                // Save account - collect all field values
                                dialog.accountName = accountNameField.text.trim()
                                dialog.serverUrl = serverUrlField.text.trim()
                                dialog.username = usernameField.text.trim()
                                
                                // Ensure database is set (from selection or manual entry)
                                if (!dialog.selectedDatabase && databaseField.visible && databaseField.text) {
                                    dialog.selectedDatabase = databaseField.text.trim()
                                }
                                
                                // Set authentication
                                if (dialog.useApiKey) {
                                    dialog.apiKey = authField.text.trim()
                                    dialog.password = ""
                                } else {
                                    dialog.password = authField.text.trim()
                                    dialog.apiKey = ""
                                }
                                
                                // Validate all required fields
                                var missingFields = []
                                if (!dialog.accountName) missingFields.push("Account Name")
                                if (!dialog.serverUrl) missingFields.push("Server URL")
                                if (!dialog.selectedDatabase) missingFields.push("Database")
                                if (!dialog.username) missingFields.push("Username")
                                if (!dialog.apiKey && !dialog.password) missingFields.push("API Key or Password")
                                
                                if (missingFields.length === 0) {
                                    root.saveAccount(dialog.accountName, dialog.serverUrl, dialog.selectedDatabase, dialog.username, dialog.apiKey, dialog.password)
                                    PopupUtils.close(dialog)
                                } else {
                                    root.dialogMessage = i18n.tr("Please fill all required fields:\n") + missingFields.join(", ")
                                    PopupUtils.open(errorDialog, null)
                                }
                            } else {
                                if (dialog.step === 2 && !dialog.selectedDatabase) {
                                    root.dialogMessage = i18n.tr("Please select a database")
                                    PopupUtils.open(errorDialog, null)
                                } else if (dialog.step === 3) {
                                    // Validate step 3
                                    if (!dialog.selectedDatabase && (!databaseField.text || databaseField.text.trim() === "")) {
                                        root.dialogMessage = i18n.tr("Please enter database name")
                                        PopupUtils.open(errorDialog, null)
                                    } else if (!usernameField.text || usernameField.text.trim() === "") {
                                        root.dialogMessage = i18n.tr("Please enter username")
                                        PopupUtils.open(errorDialog, null)
                                    } else {
                                        if (databaseField.visible && databaseField.text) {
                                            dialog.selectedDatabase = databaseField.text
                                        }
                                        dialog.username = usernameField.text
                                        dialog.step++
                                    }
                                } else {
                                    dialog.step++
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Edit Account Dialog
    Component {
        id: editAccountDialog
        Dialog {
            id: dialog
            title: i18n.tr("Edit Account")
            
            property int accountId: 0
            property var account: null
            
            Column {
                width: parent.width
                spacing: units.gu(2)
                
                TextField {
                    id: editAccountNameField
                    width: parent.width
                    placeholderText: i18n.tr("Account Name")
                    text: account ? account.name : ""
                }
                
                TextField {
                    id: editServerUrlField
                    width: parent.width
                    placeholderText: i18n.tr("Server URL")
                    text: account ? account.server_url : ""
                }
                
                TextField {
                    id: editDatabaseField
                    width: parent.width
                    placeholderText: i18n.tr("Database Name")
                    text: account ? account.database : ""
                }
                
                TextField {
                    id: editUsernameField
                    width: parent.width
                    placeholderText: i18n.tr("Username")
                    text: account ? account.username : ""
                }
                
                TextField {
                    id: editApiKeyField
                    width: parent.width
                    placeholderText: i18n.tr("API Key (optional)")
                    text: account ? (account.api_key || "") : ""
                }
                
                TextField {
                    id: editPasswordField
                    width: parent.width
                    placeholderText: i18n.tr("Password (optional)")
                    echoMode: TextInput.Password
                    text: account ? (account.password || "") : ""
                }
            }
            
            Button {
                text: i18n.tr("Save")
                width: parent.width
                onClicked: {
                    if (editAccountNameField.text && editServerUrlField.text && editDatabaseField.text && editUsernameField.text) {
                        root.updateAccount(
                            accountId,
                            editAccountNameField.text,
                            editServerUrlField.text,
                            editDatabaseField.text,
                            editUsernameField.text,
                            editApiKeyField.text,
                            editPasswordField.text
                        )
                        PopupUtils.close(dialog)
                    }
                }
            }
            
            Button {
                text: i18n.tr("Cancel")
                width: parent.width
                onClicked: PopupUtils.close(dialog)
            }
        }
    }
    
    // Delete Confirmation Dialog
    Component {
        id: deleteConfirmDialog
        Dialog {
            id: dialog
            title: i18n.tr("Delete Account")
            
            property int accountId: 0
            property string accountName: ""
            
            Label {
                text: i18n.tr("Are you sure you want to delete account '") + accountName + i18n.tr("'? This action cannot be undone.")
                width: parent.width
                wrapMode: Text.Wrap
            }
            
            Button {
                text: i18n.tr("Delete")
                color: "#e74c3c"
                width: parent.width
                onClicked: {
                    root.deleteAccount(accountId)
                    PopupUtils.close(dialog)
                }
            }
            
            Button {
                text: i18n.tr("Cancel")
                width: parent.width
                onClicked: PopupUtils.close(dialog)
            }
        }
    }
    
    // Success Dialog
    Component {
        id: successDialog
        Dialog {
            id: dialog
            title: i18n.tr("Success")
            
            Label {
                text: root.dialogMessage || i18n.tr("Operation completed successfully")
                width: parent.width
                wrapMode: Text.Wrap
            }
            
            Button {
                text: i18n.tr("OK")
                width: parent.width
                onClicked: PopupUtils.close(dialog)
            }
        }
    }
    
    // Error Dialog
    Component {
        id: errorDialog
        Dialog {
            id: dialog
            title: i18n.tr("Error")
            
            Label {
                text: root.dialogMessage || i18n.tr("An error occurred")
                width: parent.width
                wrapMode: Text.Wrap
            }
            
            Button {
                text: i18n.tr("OK")
                width: parent.width
                onClicked: PopupUtils.close(dialog)
            }
        }
    }
}

