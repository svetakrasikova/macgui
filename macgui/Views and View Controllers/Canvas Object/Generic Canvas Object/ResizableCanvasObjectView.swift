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
    
    var resizeDirection: resizeDirection?
    
    var bottomLeftCorner: NSPoint {
        return frame.origin
    }
    
    var bottomRightCorner: NSPoint {
        return frame.origin.offsetBy(x: frame.width, y: 0)
    }
    
    var topLeftCorner: NSPoint {
        return frame.origin.offsetBy(x: 0, y: frame.height)
    }
    
    var topRightCorner: NSPoint {
        return frame.origin.offsetBy(x: frame.width, y: frame.height)
    }
    var bottomLeftAnchor: CGPath {
        let path = CGMutablePath()
        path.addRect(NSRect(x: bottomLeftCorner.x, y: bottomLeftCorner.y, width: 4.0, height: 4.0))
        return path
    }
    
    var bottomRightAnchor: CGPath {
        let path = CGMutablePath()
        let origin =  bottomRightCorner.offsetBy(x: -4.0, y: 0)
        path.addRect(NSRect(x: origin.x, y: origin.y, width: 4.0, height: 4.0))
        return path
    }
   
    var topLeftAnchor: CGPath {
        let path = CGMutablePath()
        let origin =  topLeftCorner.offsetBy(x: 0, y: -4.0)
        path.addRect(NSRect(x: origin.x, y: origin.y, width: 4.0, height: 4.0))
        return path
    }
   
    var topRightAnchor: CGPath {
        let path = CGMutablePath()
        let origin =  topRightCorner.offsetBy(x: -4.0, y: -4.0)
        path.addRect(NSRect(x: origin.x, y: origin.y, width: 4.0, height: 4.0))
        return path
    }
    
    func drawAnchors(resizeDirection: Bool, color: CGColor, width: CGFloat) {
        let anchorsLayer = CAShapeLayer()
        anchorsLayer.strokeColor = color
        anchorsLayer.lineWidth = width
        anchorsLayer.shadowOpacity = 0.7
        anchorsLayer.shadowRadius = 10.0
        let combined = CGMutablePath()
        combined.addPath(bottomLeftAnchor)
        combined.addPath(bottomRightAnchor)
        combined.addPath(topLeftAnchor)
        combined.addPath(topRightAnchor)
        anchorsLayer.path = combined
        layer?.addSublayer(anchorsLayer)
    }
}
