//
//  ModelToolCanvasView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        makeGridBackground(dirtyRect: dirtyRect)
    }
    
}
