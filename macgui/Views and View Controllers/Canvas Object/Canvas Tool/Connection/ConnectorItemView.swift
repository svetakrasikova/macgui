//
//  ConnectorItemArrowView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItemView: CanvasObjectView {
    
    let shapeLayer = CAShapeLayer()
    
    var connectionColor: NSColor?

    weak var concreteDelegate: ConnectorItemViewDelegate? = nil
    override var delegate: CanvasObjectViewController?  {
        didSet{
            concreteDelegate = delegate as? ConnectorItemViewDelegate
        }
    }
    
    override func makeBackingLayer() -> CALayer {
           return shapeLayer
       }
    
    override func mouseDown(with event: NSEvent) {
        (concreteDelegate as! ConnectorItem).mouseDown(with: event)
    }
    
//   MARK: - Dragging Source
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint != nil else { return [] }
        guard let source = (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint as? ConnectorItemView else { return [] }
        guard source.connectionColor == self.connectionColor else { return [] }
        guard (source.concreteDelegate?.isOutlet())!  else { return [] }
        guard !(self.concreteDelegate?.isOutlet())!  else { return [] }
        return super.draggingEntered(sender)
    }
    
}

protocol ConnectorItemViewDelegate: class {
    func getTool() -> Any?
    func getConnector() -> Any?
    func isOutlet() -> Bool
}
