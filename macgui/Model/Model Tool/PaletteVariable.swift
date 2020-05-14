//
//  PalettVariable.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa



class PaletteVariable : PalettItem {
    
    enum Key: String {
        case symbol = "symbol"
        case dimension = "dimension"
    }
    
    enum VariableType: String {
        case randomVariable = "randomVariable"
        case constant = "constant"
        case function = "function"
    }
    
    private enum CodingKeys: String, CodingKey {
        case symbol
        case dimension
    }
    
    enum PaletteVariableError: Error {
        case decodingError
        case encodingError
    }

    // MARK: - Instance variables -

    var symbol : String {
        
        switch self.type {
        case "Real":
            return Symbol.doubleStruckCapitalR.rawValue
        case "RealPos":
            return Symbol.doubleStruckCapitalR.rawValue + Symbol.plus.rawValue
        case "Simplex":
            return  Symbol.capitalDelta.rawValue
        case "Probability":
            return Symbol.doubleStruckCapitalP.rawValue
        case "Natural":
            return Symbol.doubleStruckCapitalN.rawValue
        case "Integer":
            return Symbol.doubleStruckCapitalZ.rawValue
        default:
            return "#"
        }
    }
    var dimension : Int
    
    // MARK: - Initializers and operators -

    init() {
        self.dimension = 0
        super.init(name: "")
    }

    init(name: String, dimension: Int) {
        self.dimension = dimension
        super.init(name: name)
    }

    static func == (left: PaletteVariable, right: PaletteVariable) -> Bool {

        if left.type != right.type {
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
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.dimension, forKey: Key.dimension.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.dimension = coder.decodeInteger(forKey: Key.dimension.rawValue)
        super.init(coder: coder)
    }
    
    
    required init (from decoder: Decoder) throws {
       do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.dimension     = try container.decode(Int.self,    forKey: .dimension)
            try super.init(from: decoder)
        }
        catch {
            throw PaletteVariableError.decodingError
        }
    }
    
    
    
   override var description: String {
    
        var str : String = ""
        str += "Variable: \(type)\n"
        str += "   Dimension = \(dimension)\n"
        str += "   Symbol    = \(symbol)\n"
        return str
    }
}


