//
//  Connectable.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/9/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa


class Connectable: ToolObject {
    
    var inlets: [Connector] = []
    var outlets: [Connector] = []
    
    enum Key: String {
        case inlets = "inlets"
        case outlets = "outlets"
    }
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis){
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(inlets, forKey: Key.inlets.rawValue)
        coder.encode(outlets, forKey: Key.outlets.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inlets = aDecoder.decodeObject(forKey: Key.inlets.rawValue) as! [Connector]
        outlets = aDecoder.decodeObject(forKey: Key.outlets.rawValue) as! [Connector]
    }
  
    var unconnectedInlets: [Connector] {
        get {
            return inlets.filter{!$0.isConnected}
        }
        
    }
    
    var unconnectedOutlets: [Connector] {
        get {
            return outlets.filter{!$0.isConnected}
        }
    }
    
    var connectedInlets: [Connector] {
        get {
            return inlets.filter{$0.isConnected}
        }
    }
    
    var connectedOutlets: [Connector] {
        get {
            return outlets.filter{$0.isConnected}
        }
    }
    
    var isConnected: Bool {
        get {
            for link in outlets {
                if !link.isConnected {return false}
            }
            for link in inlets {
                if !link.isConnected {return false}
            }
            return true
        }
    }
    
    func addNeighbor(connectionType: ConnectorType, linkType: LinkType){
        switch linkType {
        case .inlet:
             for connector in inlets {
                if connector.type == connectionType && !connector.isConnected {
                    connector.isConnected = true
                    break
                }
            }
        case .outlet:
            for connector in outlets{
                if connector.type == connectionType && !connector.isConnected {
                    connector.isConnected = true
                    break
                }
            }
        }

    }
    
    func removeNeighbor(connectionType: ConnectorType, linkType: LinkType){
        switch linkType {
        case .inlet:
            for connector in inlets {
                if connector.type == connectionType && connector.isConnected {
                    connector.isConnected = false
                    break
                }
            }
        case .outlet:
            for connector in outlets {
                if connector.type == connectionType && connector.isConnected {
                    connector.isConnected = false
                    break
                }
            }
        }
        
    }
    
    
    
}

enum LinkType {
    case inlet, outlet
}

protocol ResolveStateOnExecution: AnyObject {
    func execute()
}


