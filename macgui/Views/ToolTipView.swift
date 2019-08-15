//
//  ToolTipView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/15/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolTipView: NSView {
    
    override var isOpaque: Bool {return false}
//    not showing as opaque!
    override func draw(_ dirtyRect: NSRect) {
        dirtyRect.fill(using: NSCompositingOperation.clear)
    }
    
}
