//
//  MovingCanvasObjectView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 3/3/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MovingCanvasObjectView: CanvasObjectView {

    
    var firstMouseDownPoint: NSPoint?
    
    var isMouseDragged = false
    var isMouseDown = false
    
//   MARK: - Mouse and Key Events
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
        isMouseDown = true

    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        if isMouseDragged {
            addCursorRect(self.visibleRect, cursor: NSCursor.closedHand)
        }
    }

    override func mouseDragged(with event: NSEvent) {
        isMouseDragged = true
        if let newPoint = self.window?.contentView?.convert(event.locationInWindow, to: self), let firstMouseDownPoint = firstMouseDownPoint, let canvas = self.superview as? GenericCanvasView{
            let offset = NSPoint(x: newPoint.x - firstMouseDownPoint.x, y: newPoint.y - firstMouseDownPoint.y)
            let origin = self.frame.origin
            var newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
            newOrigin = newOrigin.adjustOriginToFitContentSize(content: canvas.frame.size , dimension: canvas.canvasObjectDimension ?? 50.0)
            self.setFrameOrigin(newOrigin)
        }
        delegate?.updateFrame()
        self.autoscroll(with: event)
        window?.invalidateCursorRects(for: self)
    }
      
      override func mouseUp(with event: NSEvent) {
        isMouseDragged = false
        window?.invalidateCursorRects(for: self)
        isMouseDown = false
        delegate?.updateFrame()
      }
      
      override func viewDidEndLiveResize() {
          super.viewDidEndLiveResize()
          delegate?.updateFrame()
      }
    
    override func updateTrackingAreas() {
        let trackingArea = NSTrackingArea(rect: bounds,
                                          options: [NSTrackingArea.Options.activeInKeyWindow,
                                                    NSTrackingArea.Options.mouseEnteredAndExited],
                                          owner: self,
                                          userInfo: nil)
        addTrackingArea(trackingArea)
    }
}

//   MARK: - CanvasObjectViewDelegate Protocol

protocol CanvasObjectViewDelegate: class {
    func setObjectViewSelected(flag: Bool)
    func updateFrame()
}
