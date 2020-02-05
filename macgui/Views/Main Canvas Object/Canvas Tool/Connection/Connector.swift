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
    var neighbor: Connectable?
    
    init(color: ConnectorType, neighbor: Connectable){
        self.type = color
        self.neighbor = neighbor
    }
    init(color: ConnectorType){
        self.type = color
        self.neighbor = nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type.rawValue, forKey: "type")
        if let neighbor = neighbor {
            aCoder.encode(neighbor, forKey: "neighbor")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = ConnectorType(rawValue: aDecoder.decodeObject(forKey: "type") as! String) ?? .generic
        neighbor = aDecoder.decodeObject(forKey: "neighbor") as? Connectable
    }
    
    
    func setNeighbor(neighbor: Connectable){
        self.neighbor = neighbor
    }

    func getColor() -> NSColor {
        switch self.type {
        case .alignedData: return NSColor.green
        case .unalignedData: return NSColor.blue
        case .orange: return NSColor.orange
        case .red: return NSColor.red
        case .magenta: return NSColor.magenta
        case .purple: return NSColor.purple
        case .generic: return NSColor.clear
        }
    }
  
      // MARK: - Operations
    
    func connectAlignedData(to: Connector) throws {
        guard let sourceTool = to.neighbor as? DataTool
            else { return }
        if !sourceTool.dataMatrices.isEmpty {
            let alignedMatrices =  sourceTool.dataMatrices.filter{$0.homologyEstablished == true}
            if alignedMatrices.isEmpty {
                throw ConnectionError.noAlignedData
            } else {
                sourceTool.propagateAlignedData(data: alignedMatrices)
            }
        } else {
            throw ConnectionError.noData
        }
    }
    
}

enum ConnectorType: String {
    case alignedData = "green"
    case unalignedData = "blue"
    case red = "red"
    case orange = "orange"
    case magenta = "magenta"
    case purple = "purple"
    case generic = "clear"
}

enum ConnectionError: Error {
    case noData
    case noAlignedData
}
