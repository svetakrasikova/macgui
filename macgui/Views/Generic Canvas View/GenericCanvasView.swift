//
//  GenericCanvasView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/5/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class GenericCanvasView: NSView {
    
      
    // MARK: - View Appearance
        
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [.string] }
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    var toolDimension: CGFloat? {
        return preferencesManager.toolDimension
    }
    weak var delegate: GenericCanvasViewController? = nil
    
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
    
    
    override func mouseDown(with event: NSEvent) {
        delegate?.mouseDownOnCanvasView()
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let backgroundColor = preferencesManager.mainCanvasBackroundColor, let gridColor = preferencesManager.mainCanvasGridColor, let selectionWidth = preferencesManager.canvasSelectionWidth {
            makeGridBackground(dirtyRect: dirtyRect, gridColor: gridColor, backgroundColor: backgroundColor)
            if isReceivingDrag {
                delegate?.selectContentView(width: selectionWidth)
                needsDisplay = true
            }
        }
        
    }
}

// MARK: - GenericCanvasViewDelegate

protocol GenericCanvasViewDelegate: class {
    func selectContentView(width: CGFloat)
    func mouseDownOnCanvasView()
    func isMouseDownOnArrowView(event: NSEvent, point: NSPoint) -> Bool
}
