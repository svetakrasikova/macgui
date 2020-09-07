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
            if let type = connector?.type {
                let fillColor = Connector.getColor(type: type)
                if let view = self.view as? ConnectorItemArrowView {
                    view.drawArrow(color: fillColor)
                }
            }
        }
    }
    
}
