//
//  DestinationView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

//Methods to be implemented by the drag and drop delegate of the destination view
protocol DestinationViewDelegate {
    func processImageURLs(_ urls: [URL], center: NSPoint)
    func processImage(_ image: NSImage, center: NSPoint)
}

class DestinationView: NSView {
   
    enum Appearance {
        static let selectionLineWidth: CGFloat = 10.0
    }
    
    var delegate: DestinationViewDelegate?
    
    //Define the data types that the destination view accepts in a dragging operation.
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [NSPasteboard.PasteboardType.URL] }

    //Create a dictionary to define the desired URL types
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    //Accept drags of the acceptable type - urls
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func awakeFromNib() {
        setup()
    }

    //  If the pasteboard has images, accept the drag
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
        return allow ? .copy : NSDragOperation()
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
    
    override func draw(_ dirtyRect: NSRect) {
        
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            let path = NSBezierPath(rect: bounds)
            path.lineWidth = Appearance.selectionLineWidth
            path.stroke()
        }
    }
    
    //Override hitTest so that this view which sits at the top of the view hierachy
    //appears transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
    
}


