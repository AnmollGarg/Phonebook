// Contact List Item Delegate - Reusable component for contact list items
import QtQuick 2.7
import Lomiri.Components 1.3

ListItem {
    id: contactListItem
    height: units.gu(8)

    property var contactData: null
    
    signal callClicked()
    signal messageClicked()
    signal deleteClicked()

    leadingActions: ListItemActions {
        actions: [
            Action {
                iconName: "call-start"
                text: i18n.tr("Call")
                onTriggered: {
                    contactListItem.callClicked()
                }
            },
            Action {
                iconName: "message"
                text: i18n.tr("Message")
                onTriggered: {
                    contactListItem.messageClicked()
                }
            }
        ]
    }

    trailingActions: ListItemActions {
        actions: [
            Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                onTriggered: {
                    contactListItem.deleteClicked()
                }
            }
        ]
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: units.gu(2)
        anchors.rightMargin: units.gu(2)
        spacing: units.gu(1.5)

        // Avatar
        Avatar {
            id: contactAvatar
            name: contactData ? contactData.fullName : ""
            size: units.gu(4)
            anchors.verticalCenter: parent.verticalCenter
        }

        // Contact Info
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - contactAvatar.width - units.gu(1.5)
            spacing: units.gu(0.25)

            Label {
                text: contactData ? contactData.fullName : ""
                fontSize: "medium"
                font.bold: true
                width: parent.width
                elide: Text.ElideRight
            }

            Label {
                text: contactData ? contactData.phone : ""
                fontSize: "small"
                color: theme.palette.normal.backgroundSecondaryText
                width: parent.width
                elide: Text.ElideRight
            }
        }
    }
}

