//
//  PalettItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PalettItem: NSObject, Codable, NSCoding {

    var type: String
    var superclasses: [String]
    
    enum Key: String {
        case type, superclasses
    }
    
    static let plateType: String = "Plate"
    
      private enum CodingKeys: String, CodingKey {
         case type, superclasses
     }
    
    enum PaletteItemError: Error {
        case decodingError
        case encodingError
    }
    
    enum PaletteVariableType: String {
        case BranchLengthTree
    }
    
    init(name: String, superclasses: [String]?) {
        self.type = name
        self.superclasses = superclasses ?? []
    }
    

    
    func isPlate() -> Bool {
        return self.type == PalettItem.plateType
    }

//   MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: Key.type.rawValue)
    }
    
    required init?(coder: NSCoder) {
        type = coder.decodeObject(forKey: Key.type.rawValue) as? String ?? ""
        superclasses = coder.decodeObject(forKey: Key.superclasses.rawValue) as? [String] ?? []
    }
    
    required init (from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type     = try container.decode(String.self,    forKey: .type)
            self.superclasses = try container.decode([String].self, forKey: .superclasses)
        }
        catch {
            throw PaletteItemError.decodingError
        }
    }
}


