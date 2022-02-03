//
//  Model.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers

class Model: DataTool {
    
    enum Key: String {
        case palettItems, nodes, edges, distributions, functions, plates, errors
    }

    
    override var dataToolType: DataTool.DataToolType {
        return .matrixData
    }
    
    dynamic var palettItems: [PalettItem] = []
    dynamic var distributions: [Distribution] = []
    dynamic var functions: [Distribution] = []
    
    var errors: [Error]? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var nodes: [ModelNode] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    dynamic var edges: [Connection] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    dynamic var plates: [Plate] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    
    override dynamic var alignedDataMatrices: [DataMatrix] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
            if unalignedDataMatrices.count == 0 && alignedDataMatrices.count == 0 {
                plates.forEach {$0.rangeType = Plate.IteratorRange.number.rawValue}
            }
        }
    }
   
    override dynamic var unalignedDataMatrices: [DataMatrix] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
            if unalignedDataMatrices.count == 0 && alignedDataMatrices.count == 0 {
                plates.forEach {$0.rangeType = Plate.IteratorRange.number.rawValue}
            }
        }
    }
    
   
    init(frameOnCanvas: NSRect, analysis: Analysis) {
        
        super.init(name: ToolType.model.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green = Connector(type: .alignedData)
        let purple = Connector(type: .purple)
        let olive = Connector(type: .readnumbers)
        self.inlets = [green, olive]
        self.outlets = [purple]
        
        do {
            try initPalettItemsFromCore()
            try initMockupPaletteItems()
            try initMockupDistributions()
            try initMockupFunctions()
        } catch DataToolError.readError {
            print("Error reading json data from the core. Model Tool palette items could not be loaded.")
        } catch ReadDataError.dataDecodingError {
            print("Error decoding Model Tool items from json.")
        } catch {
            print("Error. Model Tool palette items could not be loaded.")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        palettItems = aDecoder.decodeObject(forKey: Key.palettItems.rawValue) as? [PalettItem] ?? []
        distributions = aDecoder.decodeObject(forKey: Key.distributions.rawValue) as? [Distribution] ?? []
        functions = aDecoder.decodeObject(forKey: Key.functions.rawValue) as? [Distribution] ?? []
        nodes = aDecoder.decodeObject(forKey: Key.nodes.rawValue) as? [ModelNode] ?? []
        edges = aDecoder.decodeObject(forKey: Key.edges.rawValue) as? [Connection] ?? []
        plates = aDecoder.decodeObject(forKey: Key.plates.rawValue) as? [Plate] ?? []
        errors = aDecoder.decodeObject(forKey: Key.errors.rawValue) as? [Error] ?? []
        
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(palettItems, forKey: Key.palettItems.rawValue)
        coder.encode(distributions, forKey: Key.distributions.rawValue)
        coder.encode(functions, forKey: Key.functions.rawValue)
        coder.encode(nodes, forKey: Key.nodes.rawValue)
        coder.encode(edges, forKey: Key.edges.rawValue)
        coder.encode(plates, forKey: Key.plates.rawValue)
        coder.encode(errors, forKey: Key.errors.rawValue)
    }
    
    func initPalettItemsFromCore() throws {
    
        let variables = PaletteVariableList()
        guard let jsonVariableStringArray = revbayesBridge.getVariablesFromCore() as? [String]
        else {
            throw DataToolError.readError
        }
        let variableDataArray: [Data] = JsonCoreBridge(jsonArray: jsonVariableStringArray).encodeJsonStringArray()

        for data in variableDataArray {
        
            do {
                let newVariable = try JSONDecoder().decode(PaletteVariable.self, from: data)
                variables.addVariableToList(variable: newVariable)
            } catch  {
                throw ReadDataError.dataDecodingError
            }
        }
        
        palettItems += variables.variables
    }
    
    func initMockupDistributions() throws {
        let jsonDistributionStringArray: [String] = TestDataConstants.mockDistributions

        let distributionsDataArray: [Data] = JsonCoreBridge(jsonArray: jsonDistributionStringArray).encodeJsonStringArray()
        
        for data in distributionsDataArray {
            
            do {
                let newDistribution = try JSONDecoder().decode(Distribution.self, from: data)
                self.distributions.append(newDistribution)
                
            } catch ReadDataError.dataDecodingError {
                throw ReadDataError.dataDecodingError
            }
        }
    }
    
    func initMockupFunctions() throws {
        let jsonDistributionStringArray: [String] = TestDataConstants.mockFunctions

        let distributionsDataArray: [Data] = JsonCoreBridge(jsonArray: jsonDistributionStringArray).encodeJsonStringArray()
        
        for data in distributionsDataArray {
            
            do {
                let newDistribution = try JSONDecoder().decode(Distribution.self, from: data)
                self.functions.append(newDistribution)
                
            } catch ReadDataError.dataDecodingError {
                throw ReadDataError.dataDecodingError
            }
        }
    }
    
    
    func initMockupPaletteItems() throws {
        let variables = PaletteVariableList()
        let jsonPaletteItemsStringArray: [String] = TestDataConstants.mockPaletteItems

        let paletteItemsDataArray: [Data] = JsonCoreBridge(jsonArray: jsonPaletteItemsStringArray).encodeJsonStringArray()
        
        for data in paletteItemsDataArray {
            
            do {
                let newVariable = try JSONDecoder().decode(PaletteVariable.self, from: data)
                variables.addVariableToList(variable: newVariable)
                
            } catch ReadDataError.dataDecodingError {
                throw ReadDataError.dataDecodingError
            }
        }
        palettItems += variables.variables
    }
    
    func isValid() -> Bool? {
        var segments: Int = 0
        var undiscovered: [ModelNode] = self.nodes
        for node in self.nodes {
            if undiscovered.contains(node),  let (discovered, errors) = traverse(node: node, undiscovered: undiscovered, dataMatrix: nil) {
                undiscovered = undiscovered.filter {node in !discovered.contains(node) }
                if !isConnected(discovered: discovered)
                {
                    segments += 1
                }
            }
        }
        print(segments)
        return segments == 0
        
    }
    
    func isConnected(discovered: [ModelNode]) -> Bool {
        let undiscovered = self.nodes.filter {node in !discovered.contains(node)}
        return undiscovered.isEmpty
    }
    

    func traverse(node: ModelNode, undiscovered: [ModelNode], dataMatrix: String?) -> ([ModelNode], [Error])? {
        
        guard !self.nodes.isEmpty else { return nil }
      
        let updatedUndiscovered: [ModelNode] = undiscovered.filter {n in n !== node}
        var discovered: [ModelNode] = [node]
        var errors = [Error]()
        // check startNode, return errors and name of data matrix if present
//       let nodeChecker = NodeChecker(node)
//       nodeChecker.runCheck()
//        errors = nodeChecker.errors
//        var dataMatrixName = nodeChecker.linkedData
     
        for edge in self.edges {
            var startNode: ModelNode?
            if edge.from === node, let to = edge.to as? ModelNode, updatedUndiscovered.contains(to) {
                startNode = to
            } else if edge.to === node, let from = edge.from as? ModelNode, updatedUndiscovered.contains(from){
                startNode = from
            }
            if let node = startNode, let result = traverse(node: node, undiscovered: updatedUndiscovered, dataMatrix: nil) {
                discovered.append(contentsOf: result.0)
                errors.append(contentsOf: result.1)
            }
        }
        return (discovered, errors)
    }
    
}
