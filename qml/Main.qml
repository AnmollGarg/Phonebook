import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "./ui/pages" as Pages

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'phonebook.anmolgarg'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property bool splashScreenVisible: true
    
    // Theme settings with persistence
    Settings {
        id: appSettings
        property string themeMode: "light" // "light" or "dark"
        
        onThemeModeChanged: {
            updateTheme()
        }
    }
    
    // Apply theme based on settings - use theme.name property
    theme.name: appSettings.themeMode === "dark" ? 
                "Lomiri.Components.Themes.SuruDark" : 
                "Lomiri.Components.Themes.Ambiance"
    
    // Initialize theme on startup
    Component.onCompleted: {
        updateTheme()
    }
    
    // Function to update theme
    function updateTheme() {
        if (appSettings.themeMode === "dark") {
            theme.name = "Lomiri.Components.Themes.SuruDark"
        } else {
            theme.name = "Lomiri.Components.Themes.Ambiance"
        }
    }
    
    // Function to change theme (called from SettingsPage)
    function setTheme(mode) {
        appSettings.themeMode = mode
        // Explicitly update theme immediately
        updateTheme()
    }

    // Splash Screen
    Loader {
        id: splashLoader
        anchors.fill: parent
        source: "ui/pages/SplashScreen.qml"
        active: splashScreenVisible
        z: 2

        onLoaded: {
            if (item) {
                item.finished.connect(function() {
                    splashScreenVisible = false
                })
            }
        }
        
        Timer {
            interval: 100
            running: splashLoader.status === Loader.Ready && pageStack.primaryPage
            onTriggered: {
                if (splashLoader.item) {
                    splashLoader.item.loaderReady = true
                }
            }
        }
    }

    // Page Stack for Navigation
    AdaptivePageLayout {
        id: pageStack
        anchors.fill: parent
        visible: !splashScreenVisible
        z: 1

        // Layouts per form factor: phone default single column, tablet two, desktop three
        layouts: [
            PageColumnsLayout {
                // Desktop/laptop: three columns on very wide windows
                when: pageStack.width >= units.gu(130)

                PageColumn {
                    minimumWidth: units.gu(30)
                    maximumWidth: units.gu(50)
                    preferredWidth: units.gu(40)
                }
                PageColumn {
                    minimumWidth: units.gu(70)
                    maximumWidth: units.gu(100)
                    preferredWidth: units.gu(80)
                    fillWidth: true
                }
                PageColumn {
                    fillWidth: true
                }
            },
            PageColumnsLayout {
                // Tablet: two columns between 80 and 130 gu
                when: pageStack.width > units.gu(80) && pageStack.width < units.gu(130)

                PageColumn {
                    minimumWidth: units.gu(50)
                    maximumWidth: units.gu(80)
                    preferredWidth: pageStack.width > units.gu(90) ? units.gu(20) : units.gu(15)
                }
                PageColumn {
                    minimumWidth: units.gu(50)
                    maximumWidth: units.gu(80)
                    preferredWidth: units.gu(80)
                    fillWidth: true
                }
            },
            PageColumnsLayout {
                // Mobile / small widths: single column fallback below 80 gu
                PageColumn { fillWidth: true }
            }
        ]

        primaryPage: Pages.MainPage {
            id: mainPage
            onAvatarClicked: {
                console.log("Main: Opening UserProfilePage")
                pageStack.addPageToNextColumn(mainPage, Qt.resolvedUrl("ui/pages/UserProfilePage.qml"))
            }
            onSettingsClicked: {
                console.log("Main: Opening SettingsPage")
                pageStack.addPageToNextColumn(mainPage, Qt.resolvedUrl("ui/pages/SettingsPage.qml"))
            }
        }
        
    }
}
