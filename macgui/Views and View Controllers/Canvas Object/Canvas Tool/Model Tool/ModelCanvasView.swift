//
//  ModelToolCanvasView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasView: GenericCanvasView {
    
    weak var concreteDelegate: ModelCanvasViewDelegate? = nil
    override var acceptableTypes: Set<NSPasteboard.PasteboardType> { return [.string] }

    override var delegate: GenericCanvasViewController? {
        didSet {
            concreteDelegate = delegate as? ModelCanvasViewDelegate
        }
    }
    override func draw(_ dirtyRect: NSRect) {
           super.draw(dirtyRect)
        if let backgroundColor = preferencesManager.modelCanvasBackgroundColor {
            self.wantsLayer = true
            layer?.backgroundColor = backgroundColor.cgColor
           }
           
       }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        
        let point = convert(draggingInfo.draggingLocation, from: nil)
        let pasteboard = draggingInfo.draggingPasteboard
        if let paletteVariableNameAndType = pasteboard.readObjects(forClasses: [NSString.self], options: nil)?.first as? String {
            concreteDelegate?.insertParameter(center: point, item: paletteVariableNameAndType)
            return true
        }
        return false
        
    }
}

protocol ModelCanvasViewDelegate: class {
    func insertParameter(center: NSPoint, item: String)
    
}
