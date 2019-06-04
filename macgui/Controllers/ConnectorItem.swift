//
//  ConnectorItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/21/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItem: NSCollectionViewItem, ConnectorItemViewDelegate {

    
    weak var parentTool: Connectable?
    
    var type: Connector? {
        didSet{
            guard isViewLoaded else { return }
            if let type = type {
                let fillColor = getColor(colorType: type.color)
                (view as! ConnectorItemView).drawArrow(color: fillColor)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! ConnectorItemView).delegate = self
    }
    
    override func mouseDown(with mouseDownEvent: NSEvent) {
        guard
            let window = view.window,
            let source = window.dragEndpoint(at: mouseDownEvent.locationInWindow)
            else { return super.mouseDown(with: mouseDownEvent) }
//        begin of a dragging session
        let controller = ConnectionDragController()
        controller.trackDrag(forMouseDownEvent: mouseDownEvent, in: source)
    }
    
    
    func getColor(colorType: ConnectorColor) -> NSColor {
        switch colorType {
        case .blue: return NSColor.blue
        case .green: return NSColor.green
        case .orange: return NSColor.orange
        case .red: return NSColor.red
        case .magenta: return NSColor.magenta
        }
    }
    
    func addLinkOutlet(source: ConnectorItemView) {
        if let source = source.delegate?.getTool(), let color = type?.color, let neighbor = self.parentTool {
            (source as! Connectable).addNeighbor(color: color, neighbor: neighbor, linkType: .outlet)
        }
    }
    
    func addLinkInlet(source: ConnectorItemView) {
        if let source = source.delegate?.getTool(), let color = type?.color, let target = self.parentTool {
            target.addNeighbor(color: color, neighbor: source as! Connectable, linkType: .inlet)
        }
    }
    
    func getTool() -> Any? {
        if let parentTool = parentTool {
            return parentTool
        } else {return nil}
    }
    
}

private extension NSWindow {
    
    func dragEndpoint(at point: CGPoint) -> ConnectorItemView? {
        var view = contentView?.hitTest(point)
        while let candidate = view {
            if let endpoint = candidate as? ConnectorItemView { return endpoint }
            view = candidate.superview
        }
        return nil
    }
    
}
