//
//  Distribution.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/30/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Distribution: NSObject, Codable, NSCoding {
    
    
    enum Key: String {
        case name = "name"
        case domain = "domain"
        case descriptiveString = "descriptiveString"
        case parameters = "parameters"
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case domain
        case descriptiveString
        case parameters
    }
    
    enum DistributionError: Error {
        case decodingError
        case encodingError
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
    
    required init (from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self,    forKey: .name)
            self.domain = try container.decode(String.self,    forKey: .domain)
            self.descriptiveString  = try container.decode(String.self,    forKey: .descriptiveString)
            self.parameters = try container.decode([Parameter].self,    forKey: .parameters)
            
        }
        catch {
            throw DistributionError.decodingError
        }
    }
    
}


