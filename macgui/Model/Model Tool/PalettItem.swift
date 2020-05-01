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
        case type = "type"
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
}


