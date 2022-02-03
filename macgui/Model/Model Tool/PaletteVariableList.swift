//
//  PalettVariableList.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaletteVariableList: NSObject, NSCoding {
    
    enum Key: String {
        case variables = "variables"
    }

    // MARK: - Instance variables -

    var variables : [PaletteVariable]

    // MARK: - Initializers -

    override init() {
        
        self.variables = []
        super.init()
    }

    // MARK: - NSCoding -
    
    func encode(with coder: NSCoder) {
        
        coder.encode(self.variables, forKey: Key.variables.rawValue)
    }
    
    required init?(coder: NSCoder) {
    
        self.variables = coder.decodeObject(forKey: Key.variables.rawValue) as! [PaletteVariable]
    }

    override var description: String {
    
        var str : String = ""
        for v in variables {
            str += "Variable: \(v.type)\n"
            str += "   Dimension = \(v.dimension)\n"
            str += "   Symbol    = \(v.symbol)\n"
        }
        return str
    }

    // MARK: - Functions -

    func addVariableToList(variable: PaletteVariable) {
    
        if isVariableInList(variable: variable) == false {
            variables.append(variable)
        }
    }
    
    func isVariableInList(variable: PaletteVariable) -> Bool {
    
        for v in variables {
            if v == variable {
                return true
            }
        }
        return false
    }
}
