// Settings Page - Application settings
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.7 as Controls

Page {
    id: settingsPage

    property var accountOptions: [
        i18n.tr("Account 1"),
        i18n.tr("Account 2"),
        i18n.tr("Account 3")
    ]
    
    property string selectedTheme: "light" // "light" or "dark"
    property bool hasChanges: false
    
    // Function to find MainView to access theme settings
    function findMainView(item) {
        var current = item
        while (current) {
            // Check if this is the MainView by checking for objectName
            if (current.objectName === 'mainView') {
                return current
            }
            // Also check if it has setTheme function and appSettings
            if (current.setTheme && current.appSettings) {
                return current
            }
            current = current.parent
            // Safety check to avoid infinite loops
            if (!current || current === settingsPage) {
                break
            }
        }
        return null
    }
    
    // Function to find PageStack for navigation
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
    
    // Load current theme on page load
    Component.onCompleted: {
        var mainView = findMainView(settingsPage)
        if (mainView && mainView.appSettings) {
            var currentTheme = mainView.appSettings.themeMode
            if (currentTheme) {
                selectedTheme = currentTheme
            } else {
                selectedTheme = "light"
            }
            console.log("Loaded theme from settings:", selectedTheme)
        } else {
            console.log("Warning: Could not find MainView or appSettings")
        }
    }
    
    // Save theme settings
    function saveSettings() {
        var mainView = findMainView(settingsPage)
        if (mainView && mainView.setTheme) {
            mainView.setTheme(selectedTheme)
            hasChanges = false
            console.log("Theme saved:", selectedTheme)
        } else {
            console.log("Error: Could not find MainView or setTheme function")
        }
    }
    
    Action {
        id: saveAction
        iconName: "tick"
        text: i18n.tr("Save")
        enabled: hasChanges
        onTriggered: {
            saveSettings()
        }
    }

    header: PageHeader {
        title: i18n.tr("Settings")
        trailingActionBar.actions: [saveAction]
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height + units.gu(2)
        anchors.leftMargin: units.gu(1)
        anchors.rightMargin: units.gu(1)
        anchors.bottomMargin: units.gu(2)
        contentWidth: column.width
        contentHeight: column.height
        clip: true

        Column {
            id: column
            width: flickable.width
            spacing: units.gu(2)
            anchors.top: parent.top
            anchors.topMargin: units.gu(2)

            Label {
                text: i18n.tr("General")
                fontSize: "medium"
                font.bold: true
                width: parent.width
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Theme Selection
            Column {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Theme")
                    fontSize: "medium"
                    font.bold: true
                    width: parent.width
                }

                Row {
                    width: parent.width
                    spacing: units.gu(2)

                    Row {
                        spacing: units.gu(1)
                        Controls.RadioButton {
                            id: lightThemeRadio
                            checked: selectedTheme === "light"
                            onCheckedChanged: {
                                if (checked) {
                                    selectedTheme = "light"
                                    hasChanges = true
                                }
                            }
                        }
                        Label {
                            text: i18n.tr("Light")
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    lightThemeRadio.checked = true
                                }
                            }
                        }
                    }

                    Row {
                        spacing: units.gu(1)
                        Controls.RadioButton {
                            id: darkThemeRadio
                            checked: selectedTheme === "dark"
                            onCheckedChanged: {
                                if (checked) {
                                    selectedTheme = "dark"
                                    hasChanges = true
                                }
                            }
                        }
                        Label {
                            text: i18n.tr("Dark")
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    darkThemeRadio.checked = true
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Odoo Sync Section
            Label {
                text: i18n.tr("Odoo Sync")
                fontSize: "medium"
                font.bold: true
                width: parent.width
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            Button {
                text: i18n.tr("Manage Odoo Sync")
                width: parent.width
                onClicked: {
                    var pageStack = findPageStack(settingsPage)
                    if (pageStack) {
                        pageStack.addPageToNextColumn(settingsPage, Qt.resolvedUrl("OdooSyncPage.qml"))
                    }
                }
            }

            Label {
                text: i18n.tr("Sync your contacts with Odoo server")
                fontSize: "small"
                color: "#666"
                width: parent.width
                wrapMode: Text.Wrap
            }
        }
    }
}