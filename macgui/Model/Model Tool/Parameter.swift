//
//  ParameterType.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/13/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parameter: NSObject {
    
    enum ParameterType: String {
        case variables = "Variables"
        case trees = "Trees"
        case plates = "Plates"
    }
    
    let name: String
    var children = [PalettItem]()
    
    
    init(name: String) {
        self.name = name
    }
    
    class func parameterList(palettItemsList: [PalettItem]) -> [Parameter] {
        let variables = Parameter(name: ParameterType.variables.rawValue)
        let plates = Parameter(name: ParameterType.plates.rawValue)
        let trees = Parameter(name: ParameterType.trees.rawValue)
        for palettItem in palettItemsList {
            if palettItem.isKind(of: PaletteVariable.self) {
                variables.children.append(palettItem)
            }
        }
        
        return [variables, plates, trees]
    }
}
