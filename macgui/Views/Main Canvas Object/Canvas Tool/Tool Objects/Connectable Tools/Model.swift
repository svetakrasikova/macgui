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
    
    var palettItems: [PalettItem] = []
    
    
    
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
    }
    
    func initPalettItemsFromCore() throws {
        
        guard let jsonStringArray = revbayesBridge.getPalletItems() as? [String]
            else {
                throw DataToolError.readError
        }
        
        let palettItemsData: [Data] = JsonCoreBridge(jsonArray: jsonStringArray).encodeJsonStringArray()
        
        for data in palettItemsData {
            
            do {
                let newPalettItem = try JSONDecoder().decode(PalettItem.self, from: data)
                self.palettItems.append(newPalettItem)
            } catch  {
                throw ReadDataError.dataDecodingError
            }
        }
    }
    
    
}
