//
//  ParameterType.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/13/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaletteCategory: NSObject {
    
    enum ParameterType: String {
        case variables = "Variables"
        case plates = "Plates"
    }
    
    let name: String
    var children = [PalettItem]()
    
    
    init(name: String) {
        self.name = name
    }
    
    class func paletteCategoryList(palettItemsList: [PalettItem]) -> [PaletteCategory] {
        
        let variables = PaletteCategory(name: ParameterType.variables.rawValue)
        let plates = PaletteCategory(name: ParameterType.plates.rawValue)

        
        for palettItem in palettItemsList {
            if palettItem.isKind(of: PaletteVariable.self) {
                variables.children.append(palettItem)
            }
        }
        plates.children.append(PalettItem(name: PalettItem.plateType))
        plates.children.append(PalettItem(name: PalettItem.treePlateType))
        
        return [variables, plates]
    }
}
