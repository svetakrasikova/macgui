//
//  Simulate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Simulate: Connectable {

   init(frameOnCanvas: NSRect, analysis: Analysis) {
    super.init(name: ToolType.simulate.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
    
        let green = Connector(type: .alignedData)
        self.inlets = []
        self.outlets = [green]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
