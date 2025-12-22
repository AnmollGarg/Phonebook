// NotesEditor - Reusable notes editing component
import QtQuick 2.7
import Lomiri.Components 1.3

Flickable {
    id: notesEditor
    
    // Properties
    property string notes: ""
    property string placeholderText: i18n.tr("Add notes...")
    property string labelText: i18n.tr("Notes")
    property int textAreaHeight: units.gu(25)
    property bool isEditMode: false
    
    // Signal emitted when notes text changes (using different name to avoid conflict with property change signal)
    signal textChanged(string newText)
    
    contentWidth: notesColumn.width
    contentHeight: Math.max(notesColumn.height + units.gu(4), height)
    flickableDirection: Flickable.VerticalFlick
    clip: true
    
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
        
        // Read-only view (when not in edit mode)
        Label {
            visible: !notesEditor.isEditMode
            text: notesEditor.notes || notesEditor.placeholderText
            width: parent.width
            wrapMode: Text.WordWrap
            fontSize: "medium"
            color: notesEditor.notes ? theme.palette.normal.baseText : theme.palette.normal.backgroundSecondaryText
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

