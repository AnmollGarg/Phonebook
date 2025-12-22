// TabbedView - Reusable tabbed view component
import QtQuick 2.7
import Lomiri.Components 1.3

Item {
    id: tabbedView
    
    // Properties for tabs configuration
    property var tabs: []  // Array of objects: [{label: "Tab1", key: "tab1"}, ...]
    property string currentTab: tabs.length > 0 ? tabs[0].key : ""
    property int tabHeight: units.gu(6)
    
    // Colors - fully theme-aware, transparent background to blend with page
    property color highlightedTextColor: theme.palette.normal.baseText
    property color normalTextColor: theme.palette.normal.backgroundSecondaryText
    property color highlightIndicatorColor: "#FF6B35" // Orange indicator
    
    // Signal emitted when a tab is selected
    signal tabSelected(string tabKey)
    
    Column {
        id: mainColumn
        width: parent.width
        height: parent.height
        spacing: 0
        
        // Tab buttons
        Row {
            id: tabButtons
            width: parent.width
            height: tabbedView.tabHeight
            spacing: 0
            
            Repeater {
                model: tabbedView.tabs
                
                Item {
                    id: tabButton
                    width: parent.width / tabbedView.tabs.length
                    height: parent.height
                    property bool isHighlighted: tabbedView.currentTab === modelData.key
                    
                    // Highlight indicator at bottom
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: units.gu(0.4)
                        color: parent.isHighlighted ? tabbedView.highlightIndicatorColor : "transparent"
                    }
                    
                    Label {
                        anchors.centerIn: parent
                        text: modelData.label || ""
                        color: parent.isHighlighted ? tabbedView.highlightedTextColor : tabbedView.normalTextColor
                        font.bold: parent.isHighlighted
                        fontSize: "medium"
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            tabbedView.currentTab = modelData.key
                            tabbedView.tabSelected(modelData.key)
                        }
                    }
                }
            }
        }
        
        // Content area - children should be placed here
        Item {
            id: contentArea
            width: parent.width
            height: parent.height - tabButtons.height
        }
    }
    
    // Expose contentArea for anchoring children
    property alias contentArea: contentArea
}

