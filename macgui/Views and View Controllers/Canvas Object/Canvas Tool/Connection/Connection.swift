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
    
    enum ConnectionError: Error {
        case NoAlignedData, NoUnalignedData
    }
    
    init?(to: Connectable, from: Connectable, type: ConnectorType) {
        to.addNeighbor(connectionType: type, linkType: LinkType.inlet)
        from.addNeighbor(connectionType: type, linkType: LinkType.outlet)
        self.to = to
        self.from = from
        self.type = type
        do {
        switch self.type {
        case .alignedData:
            guard let to = to as? DataTool, let from = from as? DataTool else { return }
            try to.connectAlignedData(from: from)
        case .unalignedData:
            guard let to = to as? DataTool, let from = from as? DataTool else { return }
            try to.connectUnalignedData(from: from)
        case .readnumbers:
            guard let to = to as? DataTool, let from = from as? DataTool else { return }
            to.connectNumberData(from: from)
        case .treedata:
            guard let to = to as? TreeSet, let from = from as? DataTool else { return }
            to.connectTreeData(from: from)
        default:
            print("No action defined for connection type", self.type)
        }
        } catch ConnectionError.NoAlignedData {
            Connection.runConnectionErrorAlert(message: "No aligned data on the source tool.")
            return nil
        } catch ConnectionError.NoUnalignedData {
            Connection.runConnectionErrorAlert(message: "No unaligned data on the source tool.")
            return nil
        } catch {
            print("Connection error.")
            return nil
        }
    }
    
    class func runConnectionErrorAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = "The tools could not be connected."
        alert.informativeText = message
        alert.runModal()
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
