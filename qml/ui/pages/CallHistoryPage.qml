// Call History Page - Display call history for a specific contact
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../logic" 1.0
import "../components/display" 1.0

Page {
    id: callHistoryPage

    property int contactId: -1
    property var contact: null
    property var callHistory: []

    header: PageHeader {
        title: i18n.tr("Call History")
    }

    ContactsService {
        id: contactsService
    }

    Component.onCompleted: {
        loadCallHistory()
    }

    function loadCallHistory() {
        if (contactId > 0) {
            contact = contactsService.getContactById(contactId);
            if (contact) {
                callHistory = contactsService.getCallHistoryByContactId(contactId);
            }
        }
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: header.height
        anchors.leftMargin: units.gu(2)
        anchors.rightMargin: units.gu(2)
        anchors.bottomMargin: units.gu(2)

        Column {
            id: headerColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(2)

            // Contact Info Header
            Row {
                id: contactHeader
                width: parent.width
                spacing: units.gu(2)
                visible: contact !== null

                Avatar {
                    id: contactAvatar
                    name: contact ? contact.fullName : ""
                    size: units.gu(8)
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: units.gu(0.5)
                    width: parent.width - contactAvatar.width - parent.spacing

                    Label {
                        text: contact ? contact.fullName : ""
                        fontSize: "large"
                        font.bold: true
                        width: parent.width
                        elide: Text.ElideRight
                    }

                    Label {
                        text: contact ? contact.phone : ""
                        fontSize: "medium"
                        color: theme.palette.normal.backgroundSecondaryText
                        width: parent.width
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                id: divider
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
                visible: contact !== null
            }

            // Call History Section Header
            Label {
                id: sectionHeader
                text: i18n.tr("Call History")
                fontSize: "medium"
                font.bold: true
                visible: callHistory.length > 0
            }
        }

        // Call History List - uses ListView for better performance with many items
        ListView {
            id: callHistoryList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: headerColumn.bottom
            anchors.topMargin: units.gu(2)
            anchors.bottom: parent.bottom
            clip: true
            spacing: units.gu(0.5)
            model: callHistory

            delegate: RecentCallItemDelegate {
                callData: modelData
                onClicked: {
                    // Could open contact info page here if needed
                }
            }

            // Empty state
            Label {
                anchors.centerIn: parent
                text: i18n.tr("No call history")
                visible: callHistoryList.count === 0
                fontSize: "medium"
                color: theme.palette.normal.backgroundSecondaryText
            }
        }
    }
}

