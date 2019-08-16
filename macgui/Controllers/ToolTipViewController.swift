//
//  ToolTipViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolTipViewController: NSViewController {
    
    override func awakeFromNib() {
        // does not help to make the popover transparent
        view.window?.isOpaque = false
        view.window?.backgroundColor = NSColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
}
