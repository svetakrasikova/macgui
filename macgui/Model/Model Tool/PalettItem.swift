//
//  PalettItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PalettItem: NSObject, Codable, NSCoding {

    var name: String
    
    enum Key: String {
        case name = "name"
    }
    
    init(name: String) {
        self.name = name
    }

//   MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
    }
}


