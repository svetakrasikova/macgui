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
    
    var canvasObjectDimension: CGFloat? {
        return preferencesManager.canvasObjectDimension
    }
    weak var delegate: GenericCanvasViewController? = nil
    
//    let backgroundLayer = CALayer()
    var selectionStartPoint: NSPoint?
    var selectionBox: CAShapeLayer!
    
    override var acceptsFirstResponder: Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    
    func setup() {
        wantsLayer = true
        registerForDraggedTypes(Array(acceptableTypes))
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override func mouseDown(with event: NSEvent) {
        delegate?.mouseDownOnCanvasView()
        selectionStartPoint = self.convert(event.locationInWindow, from: nil)
        selectionBox = CAShapeLayer()
        selectionBox.lineWidth = 1.0
        selectionBox.fillColor = NSColor.lightGray.cgColor
        selectionBox.opacity = 0.3
        self.layer?.addSublayer(selectionBox)
    }
    
       
    
    override func mouseDragged(with event: NSEvent) {
        let point : NSPoint = self.convert(event.locationInWindow, from: nil)
        let path = CGMutablePath()
        guard let selectionStartPoint = self.selectionStartPoint else { return }
        path.move(to: selectionStartPoint)
        path.addLine(to: NSPoint(x: selectionStartPoint.x, y: point.y))
        path.addLine(to: point)
        path.addLine(to: NSPoint(x:point.x,y:selectionStartPoint.y))
        path.closeSubpath()
        selectionBox.path = path
        let selectedArea = selectionStartPoint.selectedAreaTo(point: point)
        delegate?.selectBySelectionBox(selectedArea: selectedArea)
    }

    override func mouseUp(with event: NSEvent) {
        if selectionBox != nil {
            selectionBox.removeFromSuperlayer()
        }
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
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let selectionWidth = preferencesManager.canvasSelectionWidth {
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
    func selectBySelectionBox(selectedArea: CGRect)
}
