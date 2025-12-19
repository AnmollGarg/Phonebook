// User Profile Page - Display user profile information
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

Page {
    id: userProfilePage

    header: PageHeader {
        title: i18n.tr("Profile")
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
                text: i18n.tr("User Name")
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
                    text: i18n.tr("user@example.com")
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
                    text: i18n.tr("+1 234 567 8900")
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
                    text: i18n.tr("Phonebook Account")
                    fontSize: "medium"
                    width: parent.width
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
