//
//  ConnectorItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/21/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItemArrow: ConnectorItem {
    
    override var connector: Connector? {
        didSet{
            guard isViewLoaded else { return }
            if let type = connector {
                let fillColor = type.getColor()
                if let view = self.view as? ConnectorItemArrowView {
                    view.drawArrow(color: fillColor)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ConnectorItemView {
            view.delegate = self
        }
    }
    
}
