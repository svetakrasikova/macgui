//
//  Summarize.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSet: Connectable {
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        self.inlets = [Connector(type: .red)]
        self.outlets = [Connector(type: .orange)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
