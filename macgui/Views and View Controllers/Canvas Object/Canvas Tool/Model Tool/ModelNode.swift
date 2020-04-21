//
//  ModelNode.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/25/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelNode: Connectable {
    
    var nodeType: PaletteItem
    
    enum Key: String {
        case nodeType = "nodeType"
    }
    
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis, nodeType: PaletteItem){
        self.nodeType = nodeType
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.nodeType = aDecoder.decodeObject(forKey: Key.nodeType.rawValue) as! PaletteItem
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(nodeType, forKey: Key.nodeType.rawValue)
        super.encode(with: coder)
    }
    
}
