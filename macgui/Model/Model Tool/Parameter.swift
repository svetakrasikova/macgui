//
//  ParameterType.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/13/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parameter: NSObject {
    
    let name: String
    var children = [PalettItem]()
    
    init(name: String) {
        self.name = name
    }
    
    class func parameterList(palettItemsList: [PalettItem]) -> [Parameter] {
        
        var parameters = [PalettItemType: Parameter]()
        
        for palettItem in palettItemsList {
            let type = palettItem.type
            if let parameter = parameters[type] {
                parameter.children.append(palettItem)
            } else {
                parameters[type] = Parameter(name: type.rawValue)
            }
        }
        
        return Array(parameters.values)
    }
}
