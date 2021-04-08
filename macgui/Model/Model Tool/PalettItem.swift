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
    
    enum Key: String {
        case type
    }
    
    static let plateType: String = "Plate"
    
      private enum CodingKeys: String, CodingKey {
         case type
     }
    
    enum PaletteItemError: Error {
        case decodingError
        case encodingError
    }
    
    init(name: String) {
        self.type = name
    }

//   MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: Key.type.rawValue)
    }
    
    required init?(coder: NSCoder) {
        type = coder.decodeObject(forKey: Key.type.rawValue) as! String
    }
    
    required init (from decoder: Decoder) throws {
       do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.type     = try container.decode(String.self,    forKey: .type)
        }
        catch {
            throw PaletteItemError.decodingError
        }
    }
}


