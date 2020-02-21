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
           let pasteBoard = draggingInfo.draggingPasteboard
           let point = convert(draggingInfo.draggingLocation, from: nil)
           if let pasteboarditems = pasteBoard.readObjects(forClasses: [NSString.self], options: nil) as? [String], pasteboarditems.count != 0, let name =  pasteboarditems.first  {
               concreteDelegate?.insertParameter(center: point, name: name)
               return true
           }

           return false
           
       }
       
    
}

protocol ModelCanvasViewDelegate: class {
    func insertParameter(center: NSPoint, name: String)
    
}
