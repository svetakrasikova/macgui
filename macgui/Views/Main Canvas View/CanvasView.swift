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
    
    weak var delegate: CanvasViewDelegate?
    
    //Define data types that canvas view accepts in a dragging operation.
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [.string] }
    
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
        if let types = pasteBoard.types, acceptableTypes.intersection(types).count > 0 {
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
        if let pasteboarditems = pasteBoard.readObjects(forClasses: [NSString.self], options: nil) as? [String], pasteboarditems.count != 0, let name =  pasteboarditems.first  {
            delegate?.processImage(center: point, name: name)
            return true
        }
        return false
        
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.mouseDownOnCanvasView()
    }
    

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        makeGridBackground(dirtyRect: dirtyRect)
        if isReceivingDrag {
            delegate?.selectContentView(width: Appearance.selectionWidth)
            needsDisplay = true
        }
    }
}

protocol CanvasViewDelegate: class {
    func processImage(center: NSPoint, name: String)
    func selectContentView(width: CGFloat)
    func mouseDownOnCanvasView()
    func isMouseDownOnArrowView(event: NSEvent, point: NSPoint) -> Bool
}
