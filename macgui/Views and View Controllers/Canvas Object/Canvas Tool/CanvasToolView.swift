//
//  CanvasToolView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasToolView: MovingCanvasObjectView {
    
    weak var concreteDelegate: CanvasToolViewDelegate? = nil

    override var delegate: CanvasObjectViewController? {
        didSet {
         concreteDelegate = delegate as? CanvasToolViewDelegate
        }
    }
    
   let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager

    
    override func mouseUp(with event: NSEvent) {
        if isMouseDragged { delegate?.checkForLoopInclusion() }
        super.mouseUp(with: event)
    }
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return concreteDelegate?.getConnectorItemArrowView(sender)?.draggingEntered(sender) ??  sender.draggingSourceOperationMask
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        if let sender = sender {
            concreteDelegate?.getConnectorItemArrowView(sender)?.draggingExited(sender)
        }
    }
    
    public override func draggingEnded(_ sender: NSDraggingInfo?) {
        if let sender = sender {
            concreteDelegate?.getConnectorItemArrowView(sender)?.draggingEnded(sender)
        }
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let connectorView = concreteDelegate?.getConnectorItemArrowView(sender) {
            return connectorView.performDragOperation(sender)
        } else { return false }
    }
    
//    MARK: - Layer Drawing
    
    override func updateLayer() {
        super.updateLayer()
        layer?.cornerRadius = preferencesManager.canvasToolSelectionCornerRadius!
        layer?.borderWidth = preferencesManager.canvasToolBorderWidth!
        if isSelected {
            layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
            layer?.borderColor = NSColor.systemGray.cgColor
        } else {
            layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
        }
    }
}

protocol CanvasToolViewDelegate: AnyObject {
    func getConnectorItemArrowView(_ sender: NSDraggingInfo) -> ConnectorItemArrowView?
}
