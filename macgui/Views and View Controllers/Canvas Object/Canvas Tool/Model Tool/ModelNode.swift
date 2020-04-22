//
//  ModelNode.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/25/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelNode: Connectable {
    
    var node: PalettItem
    var nodeType: PaletteVariable.VariableType?
    
    enum Key: String {
        case node = "node"
        case nodeType = "nodeType"
    }
    
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis, node: PalettItem){
        self.node = node
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.node = aDecoder.decodeObject(forKey: Key.node.rawValue) as? PalettItem ?? PaletteVariable()
        self.nodeType = PaletteVariable.VariableType(rawValue: aDecoder.decodeObject(forKey: Key.nodeType.rawValue) as! String)
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(node, forKey: Key.node.rawValue)
        coder.encode(nodeType?.rawValue, forKey: Key.nodeType.rawValue)
        super.encode(with: coder)
    }
    
}
