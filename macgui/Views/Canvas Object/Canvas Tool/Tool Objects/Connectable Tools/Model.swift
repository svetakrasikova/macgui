//
//  Model.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Model: Connectable {
   
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        
        let green = Connector(color:ConnectorColor.green)
        let purple = Connector(color:ConnectorColor.purple)
        self.inlets = [green]
        self.outlets = [purple]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
