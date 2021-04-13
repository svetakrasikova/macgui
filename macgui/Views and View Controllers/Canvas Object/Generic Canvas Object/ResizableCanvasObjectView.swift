//
//  ResizableCanvasObjectView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ResizableCanvasObjectView: MovingCanvasObjectView {
    
    enum resizeDirection {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    var frameOffset: CGFloat = 4.0
    
    var insetFrame: NSRect {
        bounds.insetBy(dx: frameOffset, dy: frameOffset)
    }
    
    var resizeDirection: resizeDirection?
    
    var bottomLeftCorner: NSPoint {
        return insetFrame.origin
    }
    
    var bottomRightCorner: NSPoint {
        return NSPoint(x: insetFrame.maxX, y: insetFrame.minY)
    }
    
    var topLeftCorner: NSPoint {
        return NSPoint(x: insetFrame.minX, y: insetFrame.maxY)
    }
    
    var topRightCorner: NSPoint {
        return NSPoint(x: insetFrame.maxY, y: insetFrame.maxY)
    }
    var bottomLeftAnchor: CGPath {
       anchorPath(startPoint: bottomLeftCorner)
    }
    
    var bottomRightAnchor: CGPath {
        anchorPath(startPoint: bottomRightCorner)
    }
   
    var topLeftAnchor: CGPath {
        anchorPath(startPoint: topLeftCorner)
    }
   
    var topRightAnchor: CGPath {
        anchorPath(startPoint: topRightCorner)
    }
    
    var combinedAnchorPath: CGPath {
        let combined = CGMutablePath()
        combined.addPath(bottomLeftAnchor)
        combined.addPath(bottomRightAnchor)
        combined.addPath(topLeftAnchor)
        combined.addPath(topRightAnchor)
        return combined
    }
    
    var anchorFrames: [resizeDirection : NSRect] {
        let bl: resizeDirection = .bottomLeft
        let br: resizeDirection = .bottomRight
        let tl: resizeDirection = .topLeft
        let tr: resizeDirection = .topRight
        return [ bl : anchorRect(startPoint: bottomLeftCorner),
                           br : anchorRect(startPoint: bottomRightCorner),
                           tl : anchorRect(startPoint: topLeftCorner),
                           tr : anchorRect(startPoint: topRightCorner)
        ]
                           
    }
    
    func anchorPath(startPoint: NSPoint) -> CGMutablePath {
        return  CGMutablePath(rect: anchorRect(startPoint: startPoint), transform: nil)
    }
    
    func anchorRect(startPoint: NSPoint) -> NSRect {
        let origin =  startPoint.offsetBy(x: -2.0, y: -2.0)
        return NSRect(x: origin.x, y: origin.y, width: 4.0, height: 4.0)
    }
    
    
    
    func drawBorderAndAnchors(fillcolor: NSColor, strokeColor: NSColor, dash: Bool = false, anchors: Bool) {
        
        let borderLayer = CAShapeLayer()
        let borderPath = NSBezierPath(rect: self.bounds.insetBy(dx: frameOffset, dy: frameOffset)).cgPath
        borderLayer.path = borderPath
        if dash { borderLayer.lineDashPattern = [4,2] }
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = fillcolor.cgColor
        borderLayer.lineWidth = 0.5
        layer?.addSublayer(borderLayer)
        if anchors { drawAnchors() }
    }
    
    func drawAnchors() {
        let anchorsLayer = CAShapeLayer()
        anchorsLayer.strokeColor = NSColor.black.cgColor
        anchorsLayer.fillColor = NSColor.white.cgColor
        anchorsLayer.lineWidth = 0.5
        
        if let direction = self.resizeDirection  {
            switch direction {
            case .bottomLeft: anchorsLayer.path = bottomLeftAnchor
            case .bottomRight: anchorsLayer.path = bottomRightAnchor
            case .topLeft: anchorsLayer.path = topLeftAnchor
            case .topRight: anchorsLayer.path = topRightAnchor
            }
        } else {
            anchorsLayer.path = combinedAnchorPath
        }
        layer?.addSublayer(anchorsLayer)
    }
    
    func clearSublayers(){
        if let sublayers = layer?.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    
    //   MARK: - Mouse and Key Events
    
    func isMouseOnAnchor(point: NSPoint) -> resizeDirection? {
        
        if bottomRightAnchor.contains(point) {
            return .bottomRight
        } else if bottomLeftAnchor.contains(point) {
            return .bottomLeft
        } else if topRightAnchor.contains(point) {
            return .topRight
        } else if topLeftAnchor.contains(point) {
            return .topLeft
        }
        return nil
    }
    
    override func resetCursorRects() {
        
        for (direction, anchorFrame) in anchorFrames {
            addCursorRect(anchorFrame, cursor: directionCursor(direction: direction))
        }
        if isMouseDragged {
            addCursorRect(self.bounds.insetBy(dx: frameOffset*2, dy: frameOffset*2), cursor: NSCursor.closedHand)
        }
        
    }
    
    func directionCursor(direction: resizeDirection)  -> NSCursor {
        guard let directionNWSE = NSImage(named: "ResizeNorthWestSouthEast") else { return NSCursor.arrow }
       
        guard let directionNESW = NSImage(named: "ResizeNorthEastSouthWest") else { return NSCursor.arrow }
        
        switch direction {
        case .bottomLeft: return NSCursor(image: directionNESW, hotSpot: NSPoint(x: 5, y: 5))
        case .bottomRight: return NSCursor(image: directionNWSE, hotSpot: NSPoint(x: 5, y: 5))
        case .topLeft: return NSCursor(image: directionNWSE, hotSpot: NSPoint(x: 5, y: 5))
        case .topRight: return NSCursor(image: directionNESW, hotSpot: NSPoint(x: 5, y: 5))
        }
        
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if let point = self.window?.contentView?.convert(event.locationInWindow, to: self) {
            self.resizeDirection = isMouseOnAnchor(point: point)
        }
    }
    
  
    
    override func mouseDragged(with event: NSEvent) {
        isMouseDragged = true
        if let direction = self.resizeDirection {
//            TODO: resize the frame using the new point
            self.autoscroll(with: event)
            window?.invalidateCursorRects(for: self)
        } else {
            super.mouseDragged(with: event)
        }
        
    }
    
    override func mouseUp(with event: NSEvent) {
        if let direction = self.resizeDirection {
            self.resizeDirection = nil
//            todo resize the frame, change the cursor back to normal
        } else {
            super.mouseUp(with: event)
        }
    }
    
    
    
    
    
}
