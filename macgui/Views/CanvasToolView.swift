//
//  CanvasToolView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolView: NSView {
    
    var image: NSImage
    var firstMouseDownPoint: NSPoint?
    var delegate: CanvasToolViewDelegate? = nil
    
    
    init(image: NSImage, frame: NSRect){
        self.image = image
        super.init(frame: frame)
        self.wantsLayer = true
     
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func mouseDown(with event: NSEvent) {
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
        let offset = NSPoint(x: newPoint.x - firstMouseDownPoint!.x, y: newPoint.y - firstMouseDownPoint!.y)
        let origin = self.frame.origin
        let newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
        self.setFrameOrigin(newOrigin)
    }
    
    override func mouseUp(with event: NSEvent) {
          delegate?.updateFrame()
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}

protocol CanvasToolViewDelegate {
    func updateFrame()
}