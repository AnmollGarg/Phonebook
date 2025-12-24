// ConfirmationDialog - Reusable confirmation dialog component
import QtQuick 2.7
import Lomiri.Components 1.3

Item {
    id: confirmationDialog
    
    // Properties
    property string title: i18n.tr("Confirm")
    property string message: i18n.tr("Are you sure?")
    property string confirmText: i18n.tr("Confirm")
    property string cancelText: i18n.tr("Cancel")
    property color confirmButtonColor: theme.palette.normal.negative
    
    // Signal emitted when user confirms
    signal confirmed()
    // Signal emitted when user cancels
    signal cancelled()
    
    // Visibility property
    property bool dialogVisible: false
    
    anchors.fill: parent
    visible: dialogVisible
    z: 1000
    
    function show() {
        dialogVisible = true
    }
    
    function hide() {
        dialogVisible = false
    }
    
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)
        visible: dialogVisible
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                confirmationDialog.cancelled()
                confirmationDialog.hide()
            }
        }
    }
    
    Rectangle {
        id: dialogBox
        width: Math.min(units.gu(40), parent.width - units.gu(4))
        height: dialogColumn.height + units.gu(4)
        anchors.centerIn: parent
        color: theme.palette.normal.background
        radius: units.gu(1)
        border.color: theme.palette.normal.base
        border.width: 1
        visible: dialogVisible
        
        Column {
            id: dialogColumn
            width: parent.width - units.gu(4)
            anchors.centerIn: parent
            spacing: units.gu(2)
            
            Label {
                text: confirmationDialog.title
                fontSize: "large"
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
            
            Label {
                text: confirmationDialog.message
                fontSize: "medium"
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
            
            Row {
                width: parent.width
                spacing: units.gu(2)
                
                Button {
                    text: confirmationDialog.cancelText
                    width: (parent.width - parent.spacing) / 2
                    onClicked: {
                        confirmationDialog.cancelled()
                        confirmationDialog.hide()
                    }
                }
                
                Button {
                    text: confirmationDialog.confirmText
                    width: (parent.width - parent.spacing) / 2
                    color: confirmationDialog.confirmButtonColor
                    onClicked: {
                        confirmationDialog.confirmed()
                        confirmationDialog.hide()
                    }
                }
            }
        }
    }
}
