//
//  TreeInspectorWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/14/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeInspectorWindowController: NSWindowController {
    
    var trees: [Tree]?
    var toolType: String? {
        didSet {
            self.window?.title = (toolType ?? "Tree") + " Viewer"
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
    }

}
