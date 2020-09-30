//
//  Parsimony.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parsimony: Connectable, ResolveStateOnExecution {
    
    var options: PaupOptions = PaupOptions() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    enum Key: String {
        case options
    }
        
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        let green = Connector(type: .alignedData)
        let red = Connector(type: .red)
        self.inlets = [green]
        self.outlets = [red]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        options = aDecoder.decodeObject(forKey: Key.options.rawValue) as? PaupOptions ?? PaupOptions()
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(options, forKey: Key.options.rawValue)
    }
    
//    MARK: -- Resolve State on Execution
    
    func execute() {
        
       }

}


