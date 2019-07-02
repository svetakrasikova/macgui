//
//  CanvasToolView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolView: CanvasObjectView {
   
    enum Appearance {
        static let selectionCornerRadius: CGFloat = 5.0
        static let selectionWidth: CGFloat = 0.5
        static let selectionColor: CGColor = NSColor.selectedKnobColor.cgColor
        static let selectionShadowOpacity: Float = 1.0
        static let selectionShadowRadius: CGFloat = 5.0
        static let defaultShadowOpacity: Float = 0.0
        static let defaultShadowRadius: CGFloat = 3.0
        
    }
    
    var firstMouseDownPoint: NSPoint?
    var canvasViewToolDelegate: CanvasToolViewDelegate? = nil
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let newPoint = self.window?.contentView?.convert(event.locationInWindow, to: self), let firstMouseDownPoint = firstMouseDownPoint {
            let offset = NSPoint(x: newPoint.x - firstMouseDownPoint.x, y: newPoint.y - firstMouseDownPoint.y)
            let origin = self.frame.origin
            let newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
            canvasViewToolDelegate?.updateFrame()
            self.setFrameOrigin(newOrigin)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        canvasViewToolDelegate?.updateFrame()
    }
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        canvasViewToolDelegate?.updateFrame()
        
    }
    
    override func updateLayer() {
        layer?.cornerRadius = Appearance.selectionCornerRadius
        if isSelected {
            layer?.shadowOpacity = Appearance.selectionShadowOpacity
            layer?.shadowRadius = Appearance.selectionShadowRadius
        } else {
            layer?.shadowOpacity = Appearance.defaultShadowOpacity
            layer?.shadowRadius = Appearance.defaultShadowRadius
        }
    }
}

protocol CanvasToolViewDelegate {
    func updateFrame()
}
