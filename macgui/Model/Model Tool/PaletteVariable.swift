//
//  PalettVariable.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa



class PaletteVariable : NSObject, Codable, NSCoding {
    
    enum Key: String {
        case name = "name"
        case symbol = "symbol"
        case dimension = "dimension"
    }

    // MARK: - Instance variables -

    var name : String
    var symbol : String
    var dimension : Int

    // MARK: - Initializers and operators -

    override init() {
        
        self.name = ""
        self.symbol = ""
        self.dimension = 0
        super.init()
    }

    init(name: String, symbol: String, dimension: Int) {
    
        self.name = name
        self.symbol = symbol
        self.dimension = dimension
        super.init()
    }

    static func == (left: PaletteVariable, right: PaletteVariable) -> Bool {

        if left.name != right.name {
            return false
        }
        if left.symbol != right.symbol {
            return false
        }
        if left.dimension != right.dimension {
            return false
        }
        return true
    }

    // MARK: - NSCoding -
    
    func encode(with coder: NSCoder) {
        
        coder.encode(self.name,      forKey: Key.name.rawValue)
        coder.encode(self.symbol,    forKey: Key.symbol.rawValue)
        coder.encode(self.dimension, forKey: Key.dimension.rawValue)
    }
    
    required init?(coder: NSCoder) {
    
        self.name      = coder.decodeObject(forKey: Key.name.rawValue) as! String
        self.symbol    = coder.decodeObject(forKey: Key.symbol.rawValue) as! String
        self.dimension = coder.decodeInteger(forKey: Key.dimension.rawValue)
    }

   override var description: String {
    
        var str : String = ""
        str += "Variable: \(name)\n"
        str += "   Dimension = \(dimension)\n"
        str += "   Symbol    = \(symbol)\n"
        return str
    }
}
