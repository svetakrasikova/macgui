//
//  InspectorWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InspectorWindowController: NSWindowController {
    
    var fileViewerItem: NSSplitViewItem? {
        if let fileViewer = (contentViewController as? InspectorViewController)?.splitViewItems[0] {
            return fileViewer
        }
        return nil
    }
    
    var infoInspectorItem: NSSplitViewItem? {
        if let infoInspector = (contentViewController as? InspectorViewController)?.splitViewItems[2] {
            return infoInspector
        }
        return nil
    }

    @IBAction func collapseExpandSidebar(_ sender: NSButton) {
        guard let fileViewerItem = self.fileViewerItem else {
            return
        }
        if fileViewerItem.isCollapsed {
            fileViewerItem.isCollapsed = false
        } else {
            fileViewerItem.isCollapsed = true
        }
    }
    
    @IBAction func collapseExpandInfoInspector(_ sender: NSButton) {
        guard let infoInspectorItem = self.infoInspectorItem else {
                   return
               }
               if infoInspectorItem.isCollapsed {
                   infoInspectorItem.isCollapsed = false
               } else {
                   infoInspectorItem.isCollapsed = true
               }
    }
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
