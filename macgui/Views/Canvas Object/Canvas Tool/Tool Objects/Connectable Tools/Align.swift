//
//  Align.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Align: Connectable {
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    
        let green = Connector(color:ConnectorType.alignedData)
        let blue = Connector(color: ConnectorType.unalignedData)
        inlets = [blue]
        outlets = [green]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}