//
//  ModelToolWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolWindowController: NSWindowController {
    
    weak var tool: ToolObject?
    
        var canvas: NSSplitViewItem? {
            if let canvas = (contentViewController as? ModelToolViewController)?.splitViewItems[1] {
                return canvas
            }
            return nil
        }
    
        var palette: NSSplitViewItem? {
            if let palette = (contentViewController as? ModelToolViewController)?.splitViewItems[0] {
                return palette
            }
            return nil
        }
    
        @IBAction func collapseExpandSidebar(_ sender: NSButton) {
               guard let  palette = self.palette else {
                   return
               }
               if palette.isCollapsed {
                   palette.isCollapsed = false
               } else {
                   palette.isCollapsed = true
               }
           }
    

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
