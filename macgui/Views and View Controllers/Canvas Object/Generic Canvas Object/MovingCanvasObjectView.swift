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
  
    
//   MARK: - Mouse and Key Events
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let newPoint = self.window?.contentView?.convert(event.locationInWindow, to: self), let firstMouseDownPoint = firstMouseDownPoint {
            let offset = NSPoint(x: newPoint.x - firstMouseDownPoint.x, y: newPoint.y - firstMouseDownPoint.y)
            let origin = self.frame.origin
            let newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
            delegate?.updateFrame()
            self.setFrameOrigin(newOrigin)
        }
    }
      
      override func mouseUp(with event: NSEvent) {
          delegate?.updateFrame()
      }
      
      override func viewDidEndLiveResize() {
          super.viewDidEndLiveResize()
          delegate?.updateFrame()
      }
    
    override func updateTrackingAreas() {
        let trackingArea = NSTrackingArea(rect: bounds,
                                          options: [NSTrackingArea.Options.activeAlways ,NSTrackingArea.Options.mouseEnteredAndExited],
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
