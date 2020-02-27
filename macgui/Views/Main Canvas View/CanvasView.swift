//
//  DestinationView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/7/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasView: GenericCanvasView {
    
   weak var concreteDelegate: CanvasViewDelegate? = nil

   override var delegate: GenericCanvasViewController? {
       didSet {
        concreteDelegate = delegate as? CanvasViewDelegate
       }
   }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard
        let point = convert(draggingInfo.draggingLocation, from: nil)
        if let pasteboarditems = pasteBoard.readObjects(forClasses: [NSString.self], options: nil) as? [String], pasteboarditems.count != 0, let name =  pasteboarditems.first  {
            concreteDelegate?.processImage(center: point, name: name)
            return true
        }

        return false
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if let backgroundColor = preferencesManager.mainCanvasBackroundColor, let gridColor = preferencesManager.mainCanvasGridColor {
            makeGridBackground(dirtyRect: dirtyRect, gridColor: gridColor, backgroundColor: backgroundColor)
        }
         super.draw(dirtyRect)
        
    }
}

protocol CanvasViewDelegate: class {
    func processImage(center: NSPoint, name: String)
}
