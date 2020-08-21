//
//  Parsimony.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parsimony: Connectable, ResolveStateOnExecution {
    
    var options: PaupOptions?
        
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        let green = Connector(color: .alignedData)
        let red = Connector(color: .red)
        self.inlets = [green]
        self.outlets = [red]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    MARK: -- Resolve State on Execution
    
    func execute() {
        
       }

}


