//
//  Helpers.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa


extension NSRect {
    /**
    Get the center point of a rectangle
    
    - returns: NSPoint in the center of the given rectangle
    */
    func center() -> NSPoint {
        let x = origin.x + ( size.width / 2 )
        let y = origin.y + ( size.height / 2 )
        return NSPoint(x: x, y: y)
    }
}
extension NSPoint {
        /**
         Mutate an NSPoint with a random amount of noise bounded by maximumDelta
         
         - parameter maximumDelta: change range +/-
         
         - returns: mutated point
         */
        func addRandomNoise(_ maximumDelta: UInt32) -> NSPoint {
            
            var newCenter = self
            let range = 2 * maximumDelta
            let xdelta = arc4random_uniform(range)
            let ydelta = arc4random_uniform(range)
            newCenter.x += (CGFloat(xdelta) - CGFloat(maximumDelta))
            newCenter.y += (CGFloat(ydelta) - CGFloat(maximumDelta))
            
            return newCenter
        }
    
    func CGPointDistanceSquaredTo(to: CGPoint) -> CGFloat {
        return (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)
    }
    
    func CGPointDistanceTo(to: CGPoint) -> CGFloat {
        return sqrt(self.CGPointDistanceSquaredTo(to: to))
        }
    }


extension NSView {
    /**
     Take a snapshot of a current state NSView and return an NSImage
     
     - returns: NSImage representation
     */
    func snapshot() -> NSImage {
        let pdfData = dataWithPDF(inside: bounds)
        let image = NSImage(data: pdfData)
        return image ?? NSImage()
    }
    
    
    public func bringToFront() {
        let superlayer = self.layer?.superlayer
        self.layer?.removeFromSuperlayer()
        superlayer?.addSublayer(self.layer!)
    }

    
    func  makeGridBackground(dirtyRect: NSRect, gridColor: NSColor, backgroundColor: NSColor){
        
        //Fill background with white color
        if let context = NSGraphicsContext.current?.cgContext {
            backgroundColor.setFill()
            context.fill(dirtyRect)
            context.flush()
        }
        
        //Draw Lines: Horizontal
        for i in 1...(Int(self.bounds.size.height) / 10) {
            if i % 10 == 0 {
                gridColor.withAlphaComponent(0.3).set()
            }else if i % 5 == 0 {
                gridColor.withAlphaComponent(0.2).set()
            }else{
                gridColor.withAlphaComponent(0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(0, CGFloat(i) * 10 - 0.5), to: NSMakePoint(self.bounds.size.width, CGFloat(i) * 10 - 0.5))
        }
        
        
        //Draw Lines: Vertical
        for i in 1...(Int(self.bounds.size.width) / 10) {
            if i % 10 == 0 {
                gridColor.withAlphaComponent(0.3).set()
            }else if i % 5 == 0 {
                gridColor.withAlphaComponent(0.2).set()
            }else{
               gridColor.withAlphaComponent(0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(CGFloat(i) * 10 - 0.5, 0), to: NSMakePoint(CGFloat(i) * 10 - 0.5, self.bounds.size.height))
        }
        
    }
    
}

extension NSBezierPath {
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo: path.move(to: points[0])
            case .lineTo: path.addLine(to: points[0])
            case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath: path.closeSubpath()
            @unknown default:
                fatalError()
            }
        }
        return path
    }

    
}



extension UserDefaults {
   
    func color(forKey key: String) -> NSColor? {

        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }

    }
    func set(_ value: NSColor?, forKey key: String) {

        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }

    }

}

extension NSWindow {
    
    func dragEndpoint(at point: CGPoint) -> CanvasObjectView? {
        var view = contentView?.hitTest(point)
        while let candidate = view {
            if let endpoint = candidate as? CanvasObjectView { return endpoint }
            view = candidate.superview
        }
        return nil
    }
}

