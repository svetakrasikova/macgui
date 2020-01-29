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
    
    
    var color: ConnectorColor
    var neighbor: Connectable?
    
    init(color: ConnectorColor, neighbor: Connectable){
        self.color = color
        self.neighbor = neighbor
    }
    init(color: ConnectorColor){
        self.color = color
        self.neighbor = nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(color.rawValue, forKey: "color")
        if let neighbor = neighbor {
            aCoder.encode(neighbor, forKey: "neighbor")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        color = ConnectorColor(rawValue: aDecoder.decodeObject(forKey: "color") as! String) ?? .clear
        neighbor = aDecoder.decodeObject(forKey: "neighbor") as? Connectable
    }
    
    
    func setNeighbor(neighbor: Connectable){
        self.neighbor = neighbor
    }

    func getColor() -> NSColor {
        switch self.color {
        case .blue: return NSColor.blue
        case .green: return NSColor.green
        case .orange: return NSColor.orange
        case .red: return NSColor.red
        case .magenta: return NSColor.magenta
        case .clear: return NSColor.clear
        case .purple: return NSColor.purple
        }
    }
    
}

enum ConnectorColor: String {
    case green = "green"
    case blue = "blue"
    case red = "red"
    case orange = "orange"
    case magenta = "magenta"
    case purple = "purple"
    case clear = "clear"
}
