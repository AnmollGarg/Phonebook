// Settings Page - Application settings
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

Page {
    id: settingsPage

    property var accountOptions: [
        i18n.tr("Account 1"),
        i18n.tr("Account 2"),
        i18n.tr("Account 3")
    ]

    header: PageHeader {
        title: i18n.tr("Settings")
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height
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

            // Account Selection
            Column {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Select an Account:")
                    fontSize: "medium"
                    font.bold: true
                    width: parent.width
                }

                OptionSelector {
                    id: accountSelector
                    model: settingsPage.accountOptions
                    width: parent.width
                    onSelectedIndexChanged: {
                        console.log("Selected account index:", selectedIndex, "text:", accountOptions[selectedIndex])
                        // Handle account selection change here
                    }
                }
            }
        }
    }}