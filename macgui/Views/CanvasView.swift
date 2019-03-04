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
        static let selectionLineWidth: CGFloat = 10.0
    }
    
    var delegate: CanvasViewDelegate?
    
    //Define the data types that the destination view accepts in a dragging operation.
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [.URL, .tiff] }

    //Create a dictionary to define the desired URL types
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    func setup() {
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func awakeFromNib() {
        setup()
    }
    

    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard
        if pasteBoard.canReadObject(forClasses: [NSURL.self, NSPasteboardItem.self], options: filteringOptions) {
            canAccept = true
        }
        else if let types = pasteBoard.types, acceptableTypes.intersection(types).count > 0 {
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
        let sourcePoint = convert(draggingInfo.draggedImageLocation, from: nil)
        let destinationPoint = convert(draggingInfo.draggingLocation, from: nil)
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self, NSPasteboardItem.self], options:filteringOptions) as? [URL], urls.count > 0 {
            delegate?.processImageURLs(urls, center: destinationPoint, source: sourcePoint)
            return true
        } else if let image = NSImage(pasteboard: pasteBoard) {
            delegate?.processImageTiff(image, center: destinationPoint, source: sourcePoint)
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
    
}


protocol CanvasViewDelegate {
    func processImageURLs(_ urls: [URL], center: NSPoint, source: NSPoint)
    func processImageTiff(_ image: NSImage, center: NSPoint, source: NSPoint)
    func processImage(_ image: NSImage, center: NSPoint, source: NSPoint, action: ((NSImage, NSRect, NSPoint) -> Void))
}


