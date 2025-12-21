// Groups Page - Display and manage contact groups
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../logic" 1.0

Page {
    id: groupsPage

    property var allGroups: []

    GroupsService {
        id: groupsService
    }

    Component.onCompleted: {
        allGroups = groupsService.getAllGroups()
    }

    function refreshGroups() {
        allGroups = groupsService.getAllGroups()
    }

    header: PageHeader {
        title: i18n.tr("Groups")
        
        trailingActionBar.actions: [
            Action {
                iconName: "add"
                text: i18n.tr("New Group")
                onTriggered: {
                    var pageStack = findPageStack(groupsPage)
                    if (pageStack) {
                        console.log("Opening NewGroupPage")
                        var pageUrl = Qt.resolvedUrl("NewGroupPage.qml")
                        pageStack.addPageToNextColumn(groupsPage, pageUrl)
                    }
                }
            }
        ]
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
                text: i18n.tr("Contact Groups")
                fontSize: "large"
                font.bold: true
                width: parent.width
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(0, 0, 0, 0.1)
            }

            // Groups List
            Column {
                id: groupsList
                width: parent.width
                spacing: units.gu(1)

                Repeater {
                    model: allGroups
                    
                    delegate: ListItem {
                        id: groupItem
                        height: groupLayout.height + units.gu(2)
                        width: groupsList.width
                        divider.visible: true

                        Row {
                            id: groupLayout
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: units.gu(1)
                            spacing: units.gu(2)

                            // Group info
                            Column {
                                width: parent.width
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: units.gu(0.5)

                                Label {
                                    text: modelData.name || i18n.tr("Unnamed Group")
                                    fontSize: "medium"
                                    font.bold: true
                                    width: parent.width
                                }

                                Label {
                                    text: {
                                        var count = modelData.contactIds ? modelData.contactIds.length : 0
                                        if (count === 1) {
                                            return i18n.tr("1 contact")
                                        } else {
                                            return i18n.tr("%1 contacts").arg(count)
                                        }
                                    }
                                    fontSize: "small"
                                    color: theme.palette.normal.backgroundSecondaryText
                                    width: parent.width
                                }

                                Label {
                                    text: modelData.description || ""
                                    fontSize: "small"
                                    color: theme.palette.normal.backgroundSecondaryText
                                    width: parent.width
                                    visible: modelData.description && modelData.description.trim() !== ""
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        onClicked: {
                            var pageStack = findPageStack(groupsPage)
                            if (pageStack) {
                                console.log("Opening GroupInfoPage for group ID:", modelData.id)
                                var pageUrl = Qt.resolvedUrl("GroupInfoPage.qml")
                                pageStack.addPageToNextColumn(groupsPage, pageUrl, {groupId: modelData.id})
                            }
                        }

                        leadingActions: ListItemActions {
                            actions: [
                                Action {
                                    iconName: "delete"
                                    text: i18n.tr("Delete")
                                    onTriggered: {
                                        if (groupsService.deleteGroup(modelData.id)) {
                                            refreshGroups()
                                        }
                                    }
                                }
                            ]
                        }
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: i18n.tr("No groups yet. Create one to get started!")
                    visible: allGroups.length === 0
                    fontSize: "medium"
                    color: theme.palette.normal.backgroundSecondaryText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

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
}

