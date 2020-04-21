//
//  Model.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Model: DataTool {
    
    let revbayesBridge =  (NSApp.delegate as! AppDelegate).coreBridge
    
    @objc dynamic var palettItems: [PalettItem] = []
    @objc dynamic var variables = PaletteVariableList()
    @objc dynamic var nodes: [ModelNode] = []
    @objc dynamic var edges: [Connection] = []
    
    enum Key: String {
        case palettItems = "palettItems"
        case nodes = "nodes"
        case edges = "edges"
    }
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
    
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        let green = Connector(color:ConnectorType.alignedData)
        let purple = Connector(color:ConnectorType.purple)
        self.inlets = [green]
        self.outlets = [purple]
        
        do {
            try initPalettItemsFromCore()
        } catch DataToolError.readError {
            print("Error reading json data from the core. Model Tool palette items could not be loaded.")
        } catch ReadDataError.dataDecodingError {
            print("Error decoding Model Tool palette items from json.")
        } catch {
            print("Error. Model Tool palette items could not be loaded.")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        palettItems = aDecoder.decodeObject(forKey: Key.palettItems.rawValue) as! [PalettItem]
        nodes = aDecoder.decodeObject(forKey: Key.nodes.rawValue) as! [ModelNode]
        edges = aDecoder.decodeObject(forKey: Key.edges.rawValue) as! [Connection]
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(palettItems, forKey: Key.palettItems.rawValue)
        coder.encode(nodes, forKey: Key.nodes.rawValue)
        coder.encode(edges, forKey: Key.edges.rawValue)
    }
    
    func initPalettItemsFromCore() throws {
    
        // find all of the variables
        guard let jsonVariableStringArray = revbayesBridge.getVariablesFromCore() as? [String]
        else {
            throw DataToolError.readError
        }
        let variableDataArray: [Data] = JsonCoreBridge(jsonArray: jsonVariableStringArray).encodeJsonStringArray()

        for data in variableDataArray {
        
            do {
                let newVariable = try JSONDecoder().decode(PaletteVariable.self, from: data)
                self.variables.addVariableToList(variable: newVariable)
            } catch  {
                throw ReadDataError.dataDecodingError
            }
        }
        
        // match symbols to the variables
        for v in self.variables.variables {
            
            if v.name == "Real" {
                v.symbol = Symbol.doubleStruckCapitalR.rawValue
            } else if v.name == "RealPos" {
                v.symbol = Symbol.doubleStruckCapitalR.rawValue
                v.symbol += Symbol.plus.rawValue
            } else if v.name == "Simplex" {
                v.symbol = Symbol.capitalDelta.rawValue
            } else if v.name == "Probability" {
                v.symbol = Symbol.doubleStruckCapitalP.rawValue
            } else if v.name == "Natural" {
                v.symbol = Symbol.doubleStruckCapitalN.rawValue
            } else if v.name == "Integer" {
                v.symbol = Symbol.doubleStruckCapitalZ.rawValue
            }
            
            palettItems.append(v)
        }
    }
    
    
}
