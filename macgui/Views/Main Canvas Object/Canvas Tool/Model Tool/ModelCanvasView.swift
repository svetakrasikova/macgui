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
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {

        return false

    }
    
}

protocol ModelCanvasViewDelegate: class {
    
}
