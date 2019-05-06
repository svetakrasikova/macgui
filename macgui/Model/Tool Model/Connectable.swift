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
    var isConnected: Bool = false
    
}

enum ConnectorColor {
    case green, blue, red, orange, magenta
}

struct Connector {
    var color: ConnectorColor
    var neighbor: Connectable?
    
    init(color: ConnectorColor){
        self.color = color
        self.neighbor = nil
    }
}
