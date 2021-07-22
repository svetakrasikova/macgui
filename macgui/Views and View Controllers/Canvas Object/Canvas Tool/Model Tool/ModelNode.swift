//
//  ModelNode.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/25/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers

class ModelNode: Connectable {
    
    var node: PalettItem
    
    var nodeType: PaletteVariable.VariableType?
    
    var treePlate: TreePlate?

   
    dynamic var parameterName: String? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var defaultParameterName: String? {
        didSet {
            parameterName = defaultParameterName
        }
    }
    var distribution: Distribution? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
   
    var distributionParameters: [ModelNode] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
   
    dynamic var constantValue: Double = 0.0 {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var observedValue: NumberList = NumberList() {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var clamped: Bool {
        return !observedValue.isEmpty
    }
    
    enum CodingKeys: String {
        case node, nodeType, parameterName, distribution, distributionParameters, constantValue, observedValue, treePlate
    }
    
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis, node: PalettItem){
        self.node = node
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
    }
    
    
    func resetToDefaults() {
        constantValue = 0.0
        distributionParameters = []
        distribution = nil
        if let defaultParameterName = self.defaultParameterName {
            parameterName = defaultParameterName
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.node = aDecoder.decodeObject(forKey: CodingKeys.node.rawValue) as? PalettItem ?? PaletteVariable()
        self.treePlate = aDecoder.decodeObject(forKey: CodingKeys.treePlate.rawValue) as? TreePlate
        self.nodeType = PaletteVariable.VariableType(rawValue: aDecoder.decodeObject(forKey: CodingKeys.nodeType.rawValue) as! String)
        self.parameterName = aDecoder.decodeObject(forKey: CodingKeys.parameterName.rawValue) as? String
        self.distribution = aDecoder.decodeObject(forKey: CodingKeys.distribution.rawValue) as? Distribution
        self.distributionParameters = aDecoder.decodeObject(forKey: CodingKeys.distributionParameters.rawValue) as? [ModelNode] ?? []
        self.constantValue = aDecoder.decodeDouble(forKey: CodingKeys.constantValue.rawValue)
        self.observedValue = aDecoder.decodeObject(forKey: CodingKeys.observedValue.rawValue) as? NumberList ?? NumberList()
        super.init(coder: aDecoder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(node, forKey: CodingKeys.node.rawValue)
        coder.encode(treePlate, forKey: CodingKeys.treePlate.rawValue)
        coder.encode(nodeType?.rawValue, forKey: CodingKeys.nodeType.rawValue)
        coder.encode(parameterName, forKey: CodingKeys.parameterName.rawValue)
        coder.encode(distribution, forKey: CodingKeys.distribution.rawValue)
        coder.encode(distributionParameters, forKey: CodingKeys.distributionParameters.rawValue)
        coder.encode(constantValue, forKey: CodingKeys.constantValue.rawValue)
        coder.encode(observedValue, forKey: CodingKeys.observedValue.rawValue)
        super.encode(with: coder)
    }
    
    
    override func setNilValueForKey(_ key: String) {
        switch key {
        case CodingKeys.constantValue.rawValue:
            self.constantValue = 0.0
        default: super.setNilValueForKey(key)
        }
       
    }
    
    func changeObservedValueTo(_ value: NumberList?) {
        if let list = value {
            list.observed = true
            observedValue = list
        } else {
            observedValue = NumberList()
        }
    }
    
    
}
