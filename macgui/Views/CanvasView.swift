//
//  DestinationView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasView: NSView {
   
    
    
    enum Appearance {
        static let selectionWidth: CGFloat = 5.0
    }
    
    var delegate: CanvasViewDelegate?
    
    //Define data types that canvas view accepts in a dragging operation.
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [.URL] }

    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    let backgroundLayer = CALayer()
    
    override var acceptsFirstResponder: Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func awakeFromNib() {
        setup()
    }
    

    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        return canAccept
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .generic : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard
        let point = convert(draggingInfo.draggingLocation, from: nil)
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:filteringOptions) as? [URL], urls.count > 0 {
            delegate?.processImageURLs(urls, center: point)
            return true
        }
        return false
        
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.mouseDownOnCanvasView()
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        backgroundLayer.frame = frame
        wantsLayer = true
        layer = backgroundLayer
        setGridBackgroundLayer()
        if isReceivingDrag {
            delegate?.selectContentView(width: Appearance.selectionWidth)
            needsDisplay = true
        }
    }
}


protocol CanvasViewDelegate {
    func processImageURLs(_ urls: [URL], center: NSPoint)
    func processImage(_ image: NSImage, center: NSPoint, name: String)
    func selectContentView(width: CGFloat)
    func mouseDownOnCanvasView()
}



extension CanvasView {
    
    func setGridBackgroundLayer() {
        let firstPath =  CGMutablePath()
        let secondPath = CGMutablePath()
        let thirdPath = CGMutablePath()
        let firstGridLayer = CAShapeLayer()
        let secondGridLayer = CAShapeLayer()
        let thirdGridLayer = CAShapeLayer()
        
        //Draw Lines: Horizontal
        for i in 1...(Int(self.bounds.size.height) / 10) {
            if i % 10 == 0 {
                drawHorizontalLineIn(path: firstPath, i: i)
            }else if i % 5 == 0 {
                drawHorizontalLineIn(path: secondPath, i: i)
            }else{
                drawHorizontalLineIn(path: thirdPath, i: i)
            }
        }
        
        //Draw Lines: Vertical
        for i in 1...(Int(self.bounds.size.width) / 10) {
            if i % 10 == 0 {
                drawVerticalLineIn(path: firstPath, i: i)
            }else if i % 5 == 0 {
                drawVerticalLineIn(path: secondPath, i: i)
            }else{
                drawVerticalLineIn(path: thirdPath, i: i)
            }
            
        }
        
        firstGridLayer.strokeColor = NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.3).cgColor
        secondGridLayer.strokeColor = NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.2).cgColor
        thirdGridLayer.strokeColor = NSColor(srgbRed: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 0.1).cgColor
        
        firstGridLayer.path = firstPath
        secondGridLayer.path = secondPath
        thirdGridLayer.path = thirdPath
        firstGridLayer.lineWidth = 1
        secondGridLayer.lineWidth = 1
        thirdGridLayer.lineWidth = 1
        backgroundLayer.backgroundColor = NSColor.white.cgColor
        backgroundLayer.addSublayer(firstGridLayer)
        backgroundLayer.addSublayer(secondGridLayer)
        backgroundLayer.addSublayer(thirdGridLayer)
    }
    
    func drawHorizontalLineIn(path: CGMutablePath, i: Int) {
        path.move(to: NSMakePoint(0, CGFloat(i) * 10 - 0.5))
        path.addLine(to: NSMakePoint(self.bounds.size.width, CGFloat(i) * 10 - 0.5))
        path.closeSubpath()
    }
    func drawVerticalLineIn(path: CGMutablePath, i: Int) {
        path.move(to: NSMakePoint(CGFloat(i) * 10 - 0.5, 0))
        path.addLine(to:  NSMakePoint(CGFloat(i) * 10 - 0.5, self.bounds.size.height))
        path.closeSubpath()
    }
}

