//
//  TablessWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TablessWindowController: NSWindowController {

    var tool: Connectable?
    
    var toolType: String? {
        didSet {
            self.window?.title = (toolType ?? "Tool") + " Settings"
        }
    }
    
    var contentVC: NSTabViewController? {
        var tabViewController: NSTabViewController?
        if let contentVC = contentViewController as? InfoToolViewController {
            tabViewController =  contentVC.tabViewController
        }
        return tabViewController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func switchToOverview(_ sender: NSButton) {
        if let index = contentVC?.findTabIndexBy(identifierString: "Overview") {
            contentVC?.selectedTabViewItemIndex = index
        }
    }

}
