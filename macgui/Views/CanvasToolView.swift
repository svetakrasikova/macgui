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
         static let borderWidth: CGFloat = 1.8
        static let selectionCornerRadius: CGFloat = 5.0
        
        static let selectionColor: CGColor = NSColor.systemGray.cgColor
        static let defaultColor: CGColor = NSColor.clear.cgColor
        
        static let selectionShadowOpacity: Float = 0.7
        static let defaultShadowOpacity: Float = 0.0
       
        static let selectionShadowRadius: CGFloat = 10.0
        static let defaultShadowRadius: CGFloat = 3.0
        
    }
    

    var firstMouseDownPoint: NSPoint?
    weak var canvasViewToolDelegate: CanvasToolViewDelegate?
    
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
        layer?.borderWidth = Appearance.borderWidth
        layer?.masksToBounds =  false
        if isSelected {
            layer?.shadowOpacity = Appearance.selectionShadowOpacity
            layer?.shadowRadius = Appearance.selectionShadowRadius
            layer?.borderColor = Appearance.selectionColor
        } else {
            layer?.shadowOpacity = Appearance.defaultShadowOpacity
            layer?.shadowRadius = Appearance.defaultShadowRadius
            layer?.borderColor = Appearance.defaultColor
        }
    }
}

protocol CanvasToolViewDelegate: class {
    func updateFrame()
}
