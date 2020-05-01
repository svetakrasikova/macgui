//
//  Distribution.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/30/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Distribution: NSObject, NSCoding {
    
    enum Key: String {
        case name = "name"
        case domain = "domain"
        case descriptiveString = "descriptiveString"
        case parameters = "parameters"
    }
    
    var name: String
    var domain: String
    var descriptiveString: String
    var parameters: [Parameter]
    
    
    
//    MARK:  -- NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(domain, forKey: Key.domain.rawValue)
        coder.encode(descriptiveString, forKey: Key.descriptiveString.rawValue)
        coder.encode(parameters, forKey: Key.parameters.rawValue)
        
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: Key.name.rawValue) as! String
        domain = coder.decodeObject(forKey: Key.domain.rawValue) as! String
        descriptiveString = coder.decodeObject(forKey: Key.descriptiveString.rawValue) as! String
        parameters = coder.decodeObject(forKey: Key.parameters.rawValue) as! [Parameter]
    }
    
}


