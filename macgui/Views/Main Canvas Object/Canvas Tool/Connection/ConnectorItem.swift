//
//  ConnectorItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItem: NSCollectionViewItem, ConnectorItemViewDelegate {
    
    var connector: Connector?
    weak var parentTool: Connectable?
    
    override func mouseDown(with mouseDownEvent: NSEvent) {
        guard
            let window = view.window,
            let source = window.dragEndpoint(at: mouseDownEvent.locationInWindow)
            else { return super.mouseDown(with: mouseDownEvent) }
        let controller = ConnectionDragController()
        controller.trackDrag(forMouseDownEvent: mouseDownEvent, in: source)
    }
    
    func getTool() -> Any? {
        if let parentTool = parentTool {
            return parentTool
        } else {return nil}
    }
    
    func getConnector() -> Any? {
        if let connector = connector {
            return connector
        } else {return nil}
    }
    
    func isOutlet() -> Bool {
        if let parentTool = parentTool, let connector = connector {
            return parentTool.outlets.contains(connector)
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ConnectorItemView {
            view.concreteDelegate = self
        }
    }
    
}


