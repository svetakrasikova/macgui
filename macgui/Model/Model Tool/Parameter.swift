//
//  Parameter.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/30/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parameter: NSObject, NSCoding {
    
    enum Key: String {
        case name = "name"
        case type = "type"
        case descriptiveString = "descriptiveString"
    }
    
    var name: String
    var type: String
    var descriptiveString: String
    
    init(name: String, type: String, description: String) {
        
        self.name = name
        self.type = type
        self.descriptiveString = description
    }
  
//    MARK: -- NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(type, forKey: Key.type.rawValue)
        coder.encode(descriptiveString, forKey: Key.descriptiveString.rawValue)
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: Key.name.rawValue) as! String
        type = coder.decodeObject(forKey: Key.type.rawValue) as! String
        descriptiveString = coder.decodeObject(forKey: Key.descriptiveString.rawValue) as! String
    }
    
    
}
