//
//  CanvasToolView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolView: CanvasObjectView {

    var firstMouseDownPoint: NSPoint?
    var canvasViewToolDelegate: CanvasToolViewDelegate? = nil
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
        let offset = NSPoint(x: newPoint.x - firstMouseDownPoint!.x, y: newPoint.y - firstMouseDownPoint!.y)
        let origin = self.frame.origin
        let newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
        canvasViewToolDelegate?.updateFrame()
        self.setFrameOrigin(newOrigin)
   
    }
    
    override func mouseUp(with event: NSEvent) {
        canvasViewToolDelegate?.updateFrame()
    }
    
    
    override func updateLayer() {
        layer?.cornerRadius = Appearance.selectionCornerRadius
        layer?.borderWidth = Appearance.selectionWidth
        if isSelected {
            layer?.borderColor = Appearance.selectionColor
        } else {
            layer?.borderColor = NSColor.clear.cgColor
        }
    }

}

//the delegate is the tool view controller that wants to be notified about its view selection
protocol CanvasToolViewDelegate {
    func updateFrame()
}
