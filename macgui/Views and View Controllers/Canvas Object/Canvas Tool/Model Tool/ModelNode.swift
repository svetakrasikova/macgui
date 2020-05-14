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
    @objc dynamic var parameterName: String?
    var distribution: Distribution?
    var distributionParameters: [ModelNode] = []
    
    enum Key: String {
        case node = "node"
        case nodeType = "nodeType"
        case parameterName = "parameterName"
        case distribution = "distribution"
        case distributionParameters = "distributionParameters"
    }
    
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis, node: PalettItem){
        self.node = node
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.node = aDecoder.decodeObject(forKey: Key.node.rawValue) as? PalettItem ?? PaletteVariable()
        self.nodeType = PaletteVariable.VariableType(rawValue: aDecoder.decodeObject(forKey: Key.nodeType.rawValue) as! String)
        self.parameterName = aDecoder.decodeObject(forKey: Key.parameterName.rawValue) as? String
        self.distribution = aDecoder.decodeObject(forKey: Key.distribution.rawValue) as? Distribution
        self.distributionParameters = aDecoder.decodeObject(forKey: Key.distributionParameters.rawValue) as? [ModelNode] ?? []
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(node, forKey: Key.node.rawValue)
        coder.encode(nodeType?.rawValue, forKey: Key.nodeType.rawValue)
        coder.encode(parameterName, forKey: Key.parameterName.rawValue)
        coder.encode(distribution, forKey: Key.distribution.rawValue)
        coder.encode(distributionParameters, forKey: Key.distributionParameters.rawValue)
        super.encode(with: coder)
    }
    
}
