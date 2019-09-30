//
//  Summarize.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSet: Connectable {
    override init(name: String, frameOnCanvas: NSRect) {
        super.init(name: name, frameOnCanvas: frameOnCanvas)
        
        self.inlets = [Connector(color:ConnectorColor.red)]
        self.outlets = [Connector(color:ConnectorColor.orange)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
