// Favorites component - horizontal scrollable list with avatars and names
import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../../../logic" 1.0

Rectangle {
    id: favoritesContainer
    implicitHeight: units.gu(12)
    color: "transparent"

    signal contactClicked(int contactId)

    ContactsService {
        id: contactsService
    }

    property var favoritesModel: []
    
    // Timer to refresh favorites after component loads
    Timer {
        id: refreshTimer
        interval: 100
        running: true
        onTriggered: {
            favoritesContainer.refreshFavorites()
        }
    }
    
    Component.onCompleted: {
        refreshFavorites()
    }
    
    function refreshFavorites() {
        favoritesModel = contactsService.getFavorites()
    }

    Column {
        anchors.fill: parent

        Label {
            text: i18n.tr("Favorites")
            fontSize: "medium"
            font.bold: true
            anchors.left: parent.left
            anchors.margins: units.gu(1)
        }

        ListView {
            id: favoritesList
            width: parent.width
            height: parent.height - units.gu(1)
            orientation: ListView.Horizontal
            clip: true
            model: favoritesModel

            delegate: FavoriteItemDelegate {
                contactData: modelData
                height: favoritesList.height
                onClicked: {
                    favoritesContainer.contactClicked(modelData.id)
                }
            }
        }
    }
}

