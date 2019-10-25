//
//  Align.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Align: Connectable {
    
    override init(name: String, frameOnCanvas: NSRect) {
        super.init(name: name, frameOnCanvas: frameOnCanvas)
        
        let green = Connector(color:ConnectorColor.green)
        let blue = Connector(color: ConnectorColor.blue)
        inlets = [blue]
        outlets = [green]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
