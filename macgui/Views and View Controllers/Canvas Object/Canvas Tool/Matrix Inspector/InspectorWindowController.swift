//
//  InspectorWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InspectorWindowController: NSWindowController {
    
    var dataMatrices: [DataMatrix]?
    var toolType: String? {
        didSet {
            self.window?.title = (toolType ?? "Data Tool") + " Inspector"
        }
    }
    
    var matrixViewerItem: NSSplitViewItem? {
        if let matrixViewer = (contentViewController as? InspectorViewController)?.splitViewItems[0] {
            return matrixViewer
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
        guard let  matrixViewerItem = self.matrixViewerItem else {
            return
        }
        if matrixViewerItem.isCollapsed {
            matrixViewerItem.isCollapsed = false
        } else {
            matrixViewerItem.isCollapsed = true
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

    }
    
}
