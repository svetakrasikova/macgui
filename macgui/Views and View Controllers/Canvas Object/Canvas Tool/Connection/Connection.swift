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
    
    var to: Connectable
    var from: Connectable
    var type: ConnectorType
    
    enum Key: String {
        case to, from, type
    }
    
    init(to: Connectable, from: Connectable, type: ConnectorType) {
        to.addNeighbor(connectionType: type, linkType: LinkType.inlet)
        from.addNeighbor(connectionType: type, linkType: LinkType.outlet)
        self.to = to
        self.from = from
        self.type = type
        switch self.type {
        case .alignedData:
            guard let to = to as? DataTool, let from = from as? DataTool else { return }
            to.connectAlignedData(from: from)
        case .unalignedData:
            guard let to = to as? DataTool, let from = from as? DataTool else { return }
            to.connectUnalignedData(from: from)
        default:
            print("No action defined for connection type", self.type)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(to, forKey: Key.to.rawValue)
        aCoder.encode(from, forKey: Key.from.rawValue)
        aCoder.encode(type.rawValue, forKey: Key.type.rawValue)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        to = aDecoder.decodeObject(forKey: Key.to.rawValue) as! Connectable
        from = aDecoder.decodeObject(forKey: Key.from.rawValue ) as! Connectable
        type = ConnectorType(rawValue: aDecoder.decodeObject(forKey: Key.type.rawValue) as! String) ?? .generic
    }
    

    
}
