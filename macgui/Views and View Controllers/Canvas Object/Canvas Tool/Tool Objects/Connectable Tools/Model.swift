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
    
    override var dataToolType: DataTool.DataToolType {
        return .matrixData
    }
    
    dynamic var palettItems: [PalettItem] = []
    dynamic var distributions: [Distribution] = []
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
    
    enum Key: String {
        case palettItems, nodes, edges, distributions, plates
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
            try initMockupDistributions()
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
        nodes = aDecoder.decodeObject(forKey: Key.nodes.rawValue) as? [ModelNode] ?? []
        edges = aDecoder.decodeObject(forKey: Key.edges.rawValue) as? [Connection] ?? []
        plates = aDecoder.decodeObject(forKey: Key.plates.rawValue) as? [Plate] ?? []
        
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(palettItems, forKey: Key.palettItems.rawValue)
        coder.encode(distributions, forKey: Key.distributions.rawValue)
        coder.encode(nodes, forKey: Key.nodes.rawValue)
        coder.encode(edges, forKey: Key.edges.rawValue)
        coder.encode(plates, forKey: Key.plates.rawValue)
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
        let jsonDistributionStringArray: [String] = [ TestDataConstants.gammaDistribution, TestDataConstants.normalDistribution, TestDataConstants.poissonDistribution, TestDataConstants.exponentialDistribution ]

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
    
    
}
