//
//  CanvasToolView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolView: NSView {

    enum Appearance {
        static let selectionCornerRadius: CGFloat = 5.0
        static let selectionWidth: CGFloat = 2.0
        static let selectionColor: CGColor = NSColor.gray.cgColor
        
    }
    
    var firstMouseDownPoint: NSPoint?
    var canvasViewToolDelegate: CanvasToolViewDelegate? = nil
    
    // MARK: - First Responder
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {return true}
    override func resignFirstResponder() -> Bool {return true}
    
    
    var isSelected: Bool = false
    { didSet{
          needsDisplay = true
        }
    }
    
    override var wantsUpdateLayer: Bool {return true}
    
    override func mouseDown(with event: NSEvent) {
        let shiftKeyDown = (event.modifierFlags.rawValue &  NSEvent.ModifierFlags.shift.rawValue) != 0
        canvasViewToolDelegate?.setViewSelected(flag: shiftKeyDown)
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
        canvasViewToolDelegate?.updateFrame()
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    
    func mouseDownOnCanvas() {
        isSelected = false
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
    func setViewSelected(flag: Bool)
}
