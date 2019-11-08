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
    
    init(to: Connector, from: Connector){
        self.to = to
        self.from = from
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(to, forKey: "to")
        aCoder.encode(from, forKey: "from")
    }
    
    required init?(coder aDecoder: NSCoder) {
        to = aDecoder.decodeObject(forKey: "to") as! Connector
        from = aDecoder.decodeObject(forKey: "from") as! Connector
    }
    
    
}
