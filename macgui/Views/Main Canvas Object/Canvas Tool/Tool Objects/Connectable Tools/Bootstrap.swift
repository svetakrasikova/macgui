//
//  Bootstrap.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/15/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Bootstrap: Connectable {
    
   override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
    super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green1 = Connector(color:ConnectorType.alignedData)
        let green2 = Connector(color:ConnectorType.alignedData)
        self.inlets = [green1]
        self.outlets = [green2]
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
