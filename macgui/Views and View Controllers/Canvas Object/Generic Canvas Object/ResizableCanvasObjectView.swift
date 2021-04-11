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
    
    func anchorPath(startPoint: NSPoint) -> CGMutablePath {
        let path = CGMutablePath()
        let origin =  startPoint.offsetBy(x: -2.0, y: -2.0)
        path.addRect(NSRect(x: origin.x, y: origin.y, width: 4.0, height: 4.0))
        return path
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
    
    
    
}
