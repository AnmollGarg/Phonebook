// NotesEditor - Reusable notes editing component
import QtQuick 2.7
import Lomiri.Components 1.3

Item {
    id: notesEditor
    
    // Properties
    property string notes: ""
    property string placeholderText: i18n.tr("Add notes...")
    property string labelText: i18n.tr("Notes")
    property int textAreaHeight: units.gu(25)
    property bool isEditMode: false
    property bool isExpanded: false
    property int collapsedLines: 3 // Number of lines to show when collapsed
    
    // Signal emitted when notes text changes (using different name to avoid conflict with property change signal)
    signal textChanged(string newText)
    
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: notesColumn.width
        contentHeight: Math.max(notesColumn.height + units.gu(4), height)
        flickableDirection: Flickable.VerticalFlick
        clip: true
        
        Behavior on contentHeight {
            NumberAnimation { duration: 300 }
        }
    
    Column {
        id: notesColumn
        width: notesEditor.width - units.gu(4)
        x: units.gu(2)
        y: units.gu(2)
        spacing: units.gu(2)
        
        Label {
            text: notesEditor.labelText
            fontSize: "small"
            color: theme.palette.normal.backgroundSecondaryText
            width: parent.width
        }
        
        // Read-only view with expansion (when not in edit mode)
        Item {
            visible: !notesEditor.isEditMode
            width: parent.width
            height: notesLabel.height
            clip: !notesEditor.isExpanded
            
            Behavior on height {
                NumberAnimation { duration: 300 }
            }
            
            Text {
                id: notesLabel
                text: notesEditor.notes || notesEditor.placeholderText
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.gu(2)
                color: notesEditor.notes ? theme.palette.normal.baseText : theme.palette.normal.backgroundSecondaryText
                maximumLineCount: notesEditor.isExpanded ? 0 : notesEditor.collapsedLines
                elide: notesEditor.isExpanded ? Text.ElideNone : Text.ElideRight
            }
        }
        
        // Editable TextArea (when in edit mode)
        TextArea {
            id: notesField
            visible: notesEditor.isEditMode
            width: parent.width
            height: notesEditor.textAreaHeight
            placeholderText: notesEditor.placeholderText
            text: notesEditor.notes
            
            onTextChanged: {
                if (notesEditor.isEditMode) {
                    notesEditor.notes = text
                }
            }
        }
        }
    }
    
    // Floating Expansion Button
    FloatingExpansionButton {
        id: expansionButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: units.gu(1.5)
        z: 10
        visible: !notesEditor.isEditMode && notesEditor.notes && notesEditor.notes.trim() !== ""
        expanded: notesEditor.isExpanded
        
        onClicked: {
            notesEditor.isExpanded = !notesEditor.isExpanded
        }
    }
}

