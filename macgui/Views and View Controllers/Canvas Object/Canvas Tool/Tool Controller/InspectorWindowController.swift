//
//  InspectorWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/3/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

/**
Controlls a window with a three-pane split view and the left and right sidebar buttuns in the tool bar menu to collapse and expand the left and right panel, respectively.
 */
class InspectorWindowController: NSWindowController {

    var tool: Connectable?
    
    var dataMatrices: [DataMatrix]?
    
    var numberData: NumberData?
    
    var toolType: String? {
        didSet {
            self.window?.title = (toolType ?? "Data Tool") + " Inspector"
        }
    }
    
    var contentVC: NSSplitViewController {
        return contentViewController as! NSSplitViewController
    }
    
    
    var leftSidebarItem: NSSplitViewItem? {
        return contentVC.splitViewItems[0]
          
    }
    
    var rightSideBarItem: NSSplitViewItem? {
        return contentVC.splitViewItems[2]
    }

    @IBAction func collapseLeftSidebar(_ sender: NSButton) {
        guard let  left = self.leftSidebarItem else {
            return
        }
        if left.isCollapsed {
            left.isCollapsed = false
        } else {
            left.isCollapsed = true
        }
    }
    
    @IBAction func collapseRightSidebar(_ sender: NSButton) {
        guard let right = self.rightSideBarItem else {
                   return
               }
               if right.isCollapsed {
                   right.isCollapsed = false
               } else {
                   right.isCollapsed = true
               }
    }
    

}
