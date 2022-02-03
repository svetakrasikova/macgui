//
//  ToolTipView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/15/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolTipView: NSView {
    
    //   TODO: still showing as opaque, find a way to make it transparent
    override var isOpaque: Bool {return false}
    
    override func draw(_ dirtyRect: NSRect) {
    }

}
