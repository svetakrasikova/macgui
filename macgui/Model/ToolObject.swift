//
//  ToolObject.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

//Generic class for tools
class ToolObject: NSObject{
    
    var name: String?
    var frameOnCanvas: NSRect
    
    init(name: String, frameOnCanvas: NSRect){
        self.name = name
        self.frameOnCanvas = frameOnCanvas
    }
}
