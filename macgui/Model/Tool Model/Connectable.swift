//
//  Connectable.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/9/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum Connector{
    case green, blue, red, brown, turcuoise
}

class Connectable: ToolObject {
    
    var inlets: [Connector] = []
    var outlets: [Connector] = []
    var predecessors: [Connectable] = []
    var successors: [Connectable] = []
    var isConnected: Bool = true
    
}
