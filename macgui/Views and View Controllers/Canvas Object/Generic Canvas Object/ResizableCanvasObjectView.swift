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
        case topLeft, topRight, bottomLeft, bottomRight, up, down, left, right
    }
    
    var frameOffset: CGFloat = 2.0
    
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
        return NSPoint(x: insetFrame.maxX, y: insetFrame.maxY)
    }

    var topCenter: NSPoint {
        return NSPoint(x: insetFrame.minX + frame.width/2, y: insetFrame.maxY)
    }
    
    var bottomCenter: NSPoint {
        return NSPoint(x: insetFrame.minX + frame.width/2, y: insetFrame.minY)
    }
    
    var leftCenter: NSPoint {
        return NSPoint(x: insetFrame.minX, y: insetFrame.minY + frame.height/2)
    }
    
    var rightCenter: NSPoint {
        return NSPoint(x: insetFrame.maxX, y: insetFrame.minY + frame.height/2)
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
    
    var topCenterAnchor: CGPath {
        anchorPath(startPoint: topCenter)
    }
    
    var bottomCenterAnchor: CGPath {
        anchorPath(startPoint: bottomCenter)
    }
    
    var leftCenterAnchor: CGPath {
        anchorPath(startPoint: leftCenter)
    }
    
    var rightCenterAnchor: CGPath {
        anchorPath(startPoint: rightCenter)
    }
    
    var combinedAnchorPath: CGPath {
        let combined = CGMutablePath()
        combined.addPath(bottomLeftAnchor)
        combined.addPath(bottomRightAnchor)
        combined.addPath(topLeftAnchor)
        combined.addPath(topRightAnchor)
        combined.addPath(leftCenterAnchor)
        combined.addPath(rightCenterAnchor)
        combined.addPath(bottomCenterAnchor)
        combined.addPath(topCenterAnchor)
        return combined
    }
    
    var anchorFrames: [resizeDirection : NSRect] {
        let bl: resizeDirection = .bottomLeft
        let br: resizeDirection = .bottomRight
        let tl: resizeDirection = .topLeft
        let tr: resizeDirection = .topRight
        let u: resizeDirection = .up
        let d: resizeDirection = .down
        let l: resizeDirection = .left
        let r: resizeDirection = .right
        
        return [ bl : anchorRect(startPoint: bottomLeftCorner),
                 br : anchorRect(startPoint: bottomRightCorner),
                 tl : anchorRect(startPoint: topLeftCorner),
                 tr : anchorRect(startPoint: topRightCorner),
                 u : anchorRect(startPoint: topCenter),
                 d : anchorRect(startPoint: bottomCenter),
                 l : anchorRect(startPoint: leftCenter),
                 r : anchorRect(startPoint: rightCenter)
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
            case .left: anchorsLayer.path = leftCenterAnchor
            case .right: anchorsLayer.path = rightCenterAnchor
            case .up: anchorsLayer.path = topCenterAnchor
            case .down: anchorsLayer.path = bottomCenterAnchor
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
        } else if topCenterAnchor.contains(point) {
            return .up
        } else if bottomCenterAnchor.contains(point) {
            return .down
        } else if leftCenterAnchor.contains(point) {
            return .left
        }else if rightCenterAnchor.contains(point) {
            return .right
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
        
        guard let directionUD = NSImage(named: "ResizeUpDown") else { return NSCursor.arrow }
        
        guard let directionLR = NSImage(named: "ResizeLeftRight") else { return NSCursor.arrow }
        
        switch direction {
        case .bottomLeft: return NSCursor(image: directionNESW, hotSpot: NSPoint(x: 8, y: 8))
        case .bottomRight: return NSCursor(image: directionNWSE, hotSpot: NSPoint(x: 8, y: 8))
        case .topLeft: return NSCursor(image: directionNWSE, hotSpot: NSPoint(x: 8, y: 8))
        case .topRight: return NSCursor(image: directionNESW, hotSpot: NSPoint(x: 8, y: 8))
        case .left: return NSCursor(image: directionLR, hotSpot: NSPoint(x: 8, y: 8))
        case .right: return NSCursor(image: directionLR, hotSpot: NSPoint(x: 8, y: 8))
        case .up: return NSCursor(image: directionUD, hotSpot: NSPoint(x: 8, y: 8))
        case .down: return NSCursor(image: directionUD, hotSpot: NSPoint(x: 8, y: 8))
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
        if let direction = self.resizeDirection,  let canvasView = self.superview as? GenericCanvasView {
            let point = canvasView.convert(event.locationInWindow, from: nil)
            resizeFrame(direction: direction, point: point)
            window?.invalidateCursorRects(for: self)
            self.autoscroll(with: event)
           
        } else {
            super.mouseDragged(with: event)
        }
        
    }
    
    func resizeFrame(direction: resizeDirection, point: NSPoint) {
        switch direction {
        case .bottomLeft :
            let offsetPoint = point.offsetBy(x: -frameOffset, y: -frameOffset)
            if offsetPoint.x < frame.minX && offsetPoint.y < frame.minY {
                let diffX = frame.minX - offsetPoint.x
                let diffY = frame.minY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin.insetBy(x: diffX, y: diffY), size: NSSize(width: frame.width + diffX, height: frame.height + diffY))
               
            } else if offsetPoint.x > frame.minX && offsetPoint.y > frame.minY {
                let diffX = offsetPoint.x - frame.minX
                let diffY = offsetPoint.y - frame.minY
                self.frame = NSRect(origin: self.frame.origin.offsetBy(x: diffX, y: diffY), size: NSSize(width: frame.width - diffX, height: frame.height - diffY))
            }
        case .bottomRight :
            let offsetPoint = point.offsetBy(x: frameOffset, y: -frameOffset)
            if offsetPoint.x > frame.maxX && offsetPoint.y < frame.minY {
                let diffX = offsetPoint.x - frame.maxX
                let diffY = frame.minY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin.insetBy(x: 0, y: diffY), size: NSSize(width: frame.width + diffX, height: frame.height + diffY))
                
            } else if offsetPoint.x < frame.maxX && offsetPoint.y > frame.minY {
                let diffX = frame.maxX - offsetPoint.x
                let diffY = offsetPoint.y - frame.minY
                self.frame = NSRect(origin: self.frame.origin.offsetBy(x: 0, y: diffY), size: NSSize(width: frame.width - diffX, height: frame.height - diffY))
            }
        case .topRight :
            let offsetPoint = point.offsetBy(x: frameOffset, y: frameOffset)
            if offsetPoint.x > frame.maxX && offsetPoint.y > frame.maxY {
                let diffX = offsetPoint.x - frame.maxX
                let diffY = offsetPoint.y - frame.maxY
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width + diffX, height: frame.height + diffY))
               
            } else if offsetPoint.x < frame.maxX && offsetPoint.y < frame.maxY {
                let diffX = frame.maxX - offsetPoint.x
                let diffY = frame.maxY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width - diffX, height: frame.height - diffY))
            }
        case .topLeft :
            let offsetPoint = point.offsetBy(x: -frameOffset, y: frameOffset)
            if offsetPoint.x < frame.minX && offsetPoint.y > frame.maxY {
                let diffX = frame.minX - offsetPoint.x
                let diffY = offsetPoint.y - frame.maxY
                self.frame = NSRect(origin: self.frame.origin.insetBy(x: diffX, y: 0), size: NSSize(width: frame.width + diffX, height: frame.height + diffY))
               
            } else if offsetPoint.x > frame.minX && offsetPoint.y < frame.maxY {
                let diffX = offsetPoint.x - frame.minX
                let diffY = frame.maxY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin.offsetBy(x: diffX, y: 0), size: NSSize(width: frame.width - diffX, height: frame.height - diffY))
            }
        case .up:
            let offsetPoint = point.offsetBy(x: -frameOffset, y: frameOffset)
            if offsetPoint.y > frame.maxY {
                let diffY = offsetPoint.y - frame.maxY
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width, height: frame.height + diffY))
               
            } else if  offsetPoint.y < frame.maxY {
                let diffY = frame.maxY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width, height: frame.height - diffY))
            }
        case .down:
            let offsetPoint = point.offsetBy(x: 0, y: -frameOffset)
            if offsetPoint.y < frame.minY {
                let diffY = frame.minY - offsetPoint.y
                self.frame = NSRect(origin: self.frame.origin.insetBy(x: 0, y: diffY), size: NSSize(width: frame.width, height: frame.height + diffY))
               
            } else if  offsetPoint.y > frame.minY {
                let diffY = offsetPoint.y - frame.minY
                self.frame = NSRect(origin: self.frame.origin.offsetBy(x: 0, y: diffY), size: NSSize(width: frame.width, height: frame.height - diffY))
            }
        case .left:
            let offsetPoint = point.offsetBy(x: -frameOffset, y: 0 )
            if offsetPoint.x < frame.minX {
                let diffX = frame.minX - offsetPoint.x
                self.frame = NSRect(origin: self.frame.origin.insetBy(x: diffX, y: 0), size: NSSize(width: frame.width + diffX, height: frame.height))

               
            } else if  offsetPoint.x > frame.minX {
                let diffX = offsetPoint.x - frame.minX
                self.frame = NSRect(origin: self.frame.origin.offsetBy(x: diffX, y: 0), size: NSSize(width: frame.width - diffX, height: frame.height))
            }
        case .right:
            let offsetPoint = point.offsetBy(x: -frameOffset, y: 0)
            if offsetPoint.x > frame.maxX {
                let diffX = offsetPoint.x - frame.maxX
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width + diffX, height: frame.height))
               
            } else if  offsetPoint.x < frame.maxX {
                let diffX = frame.maxX - offsetPoint.x
                self.frame = NSRect(origin: self.frame.origin, size: NSSize(width: frame.width - diffX, height: frame.height))
            }
        
        }
        needsDisplay = true
        
    }
    
    override func mouseUp(with event: NSEvent) {
        if let _ = self.resizeDirection {
            self.resizeDirection = nil
            needsDisplay = true
        } else {
            super.mouseUp(with: event)
        }
    }
    
    
    
    
    
}
