//
//  Connection.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/5/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation
import Cocoa


class Connection: NSObject, NSCoding {
    
    var to: Connector
    var from: Connector
    var type: ConnectorType
    
    
    init(to: Connector, from: Connector) throws {
        self.to = to
        self.from = from
        self.type = to.type
        switch self.type {
        case .alignedData:
            try self.from.connectAlignedData(to: self.to)
        default:
            print("No action defined for connection type", self.type)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(to, forKey: "to")
        aCoder.encode(from, forKey: "from")
        aCoder.encode(type.rawValue, forKey: "type")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        to = aDecoder.decodeObject(forKey: "to") as! Connector
        from = aDecoder.decodeObject(forKey: "from") as! Connector
        type = ConnectorType(rawValue: aDecoder.decodeObject(forKey: "type") as! String) ?? .generic
    }
    

    
}
