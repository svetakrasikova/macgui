//
//  File.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Foundation
import Cocoa

class Connector: NSObject, NSCoding {
    
    var type: ConnectorType
//    weak var neighbor: Connectable?
    var isConnected: Bool = false
    
    enum Key: String {
        case type, isConnected
    }
//
//    init(color: ConnectorType, neighbor: Connectable){
//        self.type = color
//        self.neighbor = neighbor
//    }
    
    init(type: ConnectorType) {
        self.type = type
    }
    
//    init(color: ConnectorType){
//        self.type = color
//        self.neighbor = nil
//    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type.rawValue, forKey: Key.type.rawValue)
//        if let neighbor = neighbor {
//            aCoder.encode(neighbor, forKey: Key.neighbor.rawValue)
//        }
        
        aCoder.encode(isConnected, forKey: Key.isConnected.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = ConnectorType(rawValue: aDecoder.decodeObject(forKey: Key.type.rawValue) as! String) ?? .generic
        isConnected = aDecoder.decodeBool(forKey: Key.isConnected.rawValue)
//        neighbor = aDecoder.decodeObject(forKey: Key.neighbor.rawValue) as? Connectable
    }
    
    
//    func setNeighbor(neighbor: Connectable){
//        self.neighbor = neighbor
//    }

    static func getColor(type: ConnectorType) -> NSColor {
        switch type {
        case .alignedData: return NSColor.green
        case .unalignedData: return NSColor.blue
        case .orange: return NSColor.orange
        case .red: return NSColor.red
        case .magenta: return NSColor.magenta
        case .purple: return NSColor.purple
        case .modelParameter: return NSColor.black
        case .generic: return NSColor.clear
        }
    }
  
    
}

enum ConnectorType: String {
    case red
    case orange
    case magenta
    case purple
    case alignedData = "green"
    case unalignedData = "blue"
    case modelParameter = "black"
    case generic = "clear"
}

enum ConnectionError: Error {
    case noData
    case noAlignedData
    case typeError
}
