// User Profile Page - Display user profile information
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import "../../logic" 1.0

Page {
    id: userProfilePage

    header: PageHeader {
        title: i18n.tr("Profile")
    }
    
    // Odoo Sync Service to get account info
    OdooSyncService {
        id: odooSyncService
    }
    
    // Properties for user information
    property string userName: ""
    property string userEmail: ""
    property string userPhone: ""
    property string accountName: ""
    
    // Load user information on page load
    Component.onCompleted: {
        loadUserInfo()
    }
    
    function loadUserInfo() {
        // Get the first active Odoo account (or most recent)
        var accounts = odooSyncService.getAllAccounts()
        if (accounts.length > 0) {
            // Get the most recent account (first in the list as they're sorted DESC)
            var account = accounts[0]
            
            // Extract name from account name or username
            if (account.name && account.name.trim() !== "") {
                userName = account.name
            } else if (account.username && account.username.trim() !== "") {
                // Use username as name, capitalize first letter
                var username = account.username
                userName = username.charAt(0).toUpperCase() + username.slice(1)
            } else {
                userName = i18n.tr("Odoo User")
            }
            
            // Email from username or server URL
            if (account.username && account.username.includes("@")) {
                userEmail = account.username
            } else if (account.username && account.username.trim() !== "") {
                // Try to extract domain from server URL
                var serverUrl = account.server_url || ""
                var domain = ""
                try {
                    if (serverUrl.includes("://")) {
                        domain = serverUrl.split("://")[1].split("/")[0]
                    } else {
                        domain = serverUrl.split("/")[0]
                    }
                    // Remove port if present
                    domain = domain.split(":")[0]
                    userEmail = account.username + "@" + domain
                } catch (e) {
                    userEmail = account.username + "@odoo.local"
                }
            } else {
                userEmail = i18n.tr("Not set")
            }
            
            userPhone = i18n.tr("Not set")
            accountName = account.name || account.database || i18n.tr("Odoo Account")
        } else {
            // No Odoo account, use system defaults
            userName = i18n.tr("User")
            userEmail = i18n.tr("Not configured")
            userPhone = i18n.tr("Not configured")
            accountName = i18n.tr("Local Account")
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height
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

            // Avatar
            Item {
                width: parent.width
                height: units.gu(15)

                Image {
                    id: userAvatar
                    source: Qt.resolvedUrl("../../../assets/avatar.png")
                    width: units.gu(12)
                    height: units.gu(12)
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
            }

            // Name
            Label {
                text: userName || i18n.tr("User")
                fontSize: "x-large"
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
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

                Label {
                    text: userEmail || i18n.tr("Not set")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
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

                Label {
                    text: userPhone || i18n.tr("Not set")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Account Info
            Column {
                width: parent.width
                spacing: units.gu(0.5)

                Label {
                    text: i18n.tr("Account")
                    fontSize: "small"
                    color: theme.palette.normal.backgroundSecondaryText
                }

                Label {
                    text: accountName || i18n.tr("Local Account")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
