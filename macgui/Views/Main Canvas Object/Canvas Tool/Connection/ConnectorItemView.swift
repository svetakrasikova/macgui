//
//  ConnectorItemView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItemView: NSView {
    
    enum State {
        case idle
        case source
        case target
    }
    
    var state: State = State.idle { didSet { needsLayout = true } }
    
    let shapeLayer = CAShapeLayer()
    
    var connectionColor: NSColor?

    weak var delegate: ConnectorItemViewDelegate?
    
//   MARK: - Initialisation
    
    override init(frame: NSRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder decoder: NSCoder) {
           super.init(coder: decoder)
           commonInit()
       }
       
       private func commonInit() {
           wantsLayer = true
           registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: kUTTypeData as String)])
       }
    
    
    override func makeBackingLayer() -> CALayer {
           return shapeLayer
       }
    
//   MARK: - Dragging Source
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard case .idle = state else { return [] }
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint != nil else { return [] }
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint?.connectionColor == self.connectionColor else { return [] }
        guard ((sender.draggingSource as? ConnectionDragController)?.sourceEndpoint?.delegate?.isOutlet())!  else { return [] }
        guard !(self.delegate?.isOutlet())!  else { return [] }
        state = .target
        return sender.draggingSourceOperationMask
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }
    
    public override func draggingEnded(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let controller = sender.draggingSource as? ConnectionDragController {
            controller.connect(to: self)
            return true
        } else { return false }
    }    
}

protocol ConnectorItemViewDelegate: class {
    func getTool() -> Any?
    func getConnector() -> Any?
    func isOutlet() -> Bool
}
