//
//  Helpers.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

extension NSImage {

/**
 Derives new size for an image constrained to a maximum dimension while keeping AR constant
 
 - parameter maxDimension: maximum horizontal or vertical dimension for new size
 
 - returns: new size
 */
func aspectFitSizeForMaxDimension(_ maxDimension: CGFloat) -> NSSize {
    var width =  size.width
    var height = size.height
    if size.width > maxDimension || size.height > maxDimension {
        let aspectRatio = size.width/size.height
        width = aspectRatio > 0 ? maxDimension : maxDimension*aspectRatio
        height = aspectRatio < 0 ? maxDimension : maxDimension/aspectRatio
    }
    return NSSize(width: width, height: height)
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
    
    func makeGridBackground(dirtyRect: NSRect){
        
        //Fill background with white color
        if let context = NSGraphicsContext.current?.cgContext {
            NSColor.white.setFill()
            context.fill(dirtyRect)
            context.flush()
        }
        
        //Draw Lines: Horizontal
        for i in 1...(Int(self.bounds.size.height) / 10) {
            if i % 10 == 0 {
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.3).set()
            }else if i % 5 == 0 {
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.2).set()
            }else{
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(0, CGFloat(i) * 10 - 0.5), to: NSMakePoint(self.bounds.size.width, CGFloat(i) * 10 - 0.5))
        }
        
        
        //Draw Lines: Vertical
        for i in 1...(Int(self.bounds.size.width) / 10) {
            if i % 10 == 0 {
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.3).set()
            }else if i % 5 == 0 {
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.2).set()
            }else{
                NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.1).set()
            }
            
            NSBezierPath.strokeLine(from: NSMakePoint(CGFloat(i) * 10 - 0.5, 0), to: NSMakePoint(CGFloat(i) * 10 - 0.5, self.bounds.size.height))
        }
        
    }
    
}

extension NSNotification.Name {
    static let didChangeMagnification = Notification.Name("didChangeMagnification")
    static let didSelectToolController = Notification.Name("didSelectToolController")
    
}

