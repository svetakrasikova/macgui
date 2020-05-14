//
//  Parameter.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/30/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Parameter: NSObject, NSCoding, Codable {
    
    enum Key: String {
        case name = "name"
        case type = "type"
        case descriptiveString = "descriptiveString"
    }
    
    private enum CodingKeys: String, CodingKey {
          case name
          case type
          case descriptiveString
      }
      
      enum ParameterError: Error {
          case decodingError
          case encodingError
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
    
    required init (from decoder: Decoder) throws {
           do {
               let container = try decoder.container(keyedBy: CodingKeys.self)
               self.name = try container.decode(String.self,    forKey: .name)
               self.type = try container.decode(String.self,    forKey: .type)
               self.descriptiveString  = try container.decode(String.self,    forKey: .descriptiveString)
               
           }
           catch {
               throw ParameterError.decodingError
           }
       }
    
    
}
