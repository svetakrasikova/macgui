//
//  PalettVariable.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa



class PaletteVariable : PaletteItem {
    
    enum Key: String {
        case symbol = "symbol"
        case dimension = "dimension"
    }
    
    enum variableType {
        case randomVariable
        case constant
        case function
        case unknown
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

    var symbol : String
    var dimension : Int

    // MARK: - Initializers and operators -

    init() {
        self.symbol = ""
        self.dimension = 0
        super.init(name: "")
    }

    init(name: String, symbol: String, dimension: Int) {
        self.symbol = symbol
        self.dimension = dimension
        super.init(name: name)
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
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(self.symbol,    forKey: Key.symbol.rawValue)
        coder.encode(self.dimension, forKey: Key.dimension.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.symbol    = coder.decodeObject(forKey: Key.symbol.rawValue) as! String
        self.dimension = coder.decodeInteger(forKey: Key.dimension.rawValue)
        super.init(coder: coder)
    }
    
    required init(from decoder: Decoder) throws {
       do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.symbol = try container.decode(String.self,    forKey: .symbol)
            self.dimension     = try container.decode(Int.self,    forKey: .dimension)
            try super.init(from: container.superDecoder())
        }
        catch {
            throw PaletteVariableError.decodingError
        }
    }
    
    required convenience init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
       guard let data = propertyList as? Data,
            let paletteVariable = try? PropertyListDecoder().decode(PaletteVariable.self, from: data) else { return nil }
        self.init(name: paletteVariable.name, symbol: paletteVariable.symbol, dimension: paletteVariable.dimension)
    }

    
   override var description: String {
    
        var str : String = ""
        str += "Variable: \(name)\n"
        str += "   Dimension = \(dimension)\n"
        str += "   Symbol    = \(symbol)\n"
        return str
    }
}
