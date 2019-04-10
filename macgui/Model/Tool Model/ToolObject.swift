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
    
    var frameOnCanvas: NSRect
    var image: NSImage
    
    init(image: NSImage, frameOnCanvas: NSRect){
        self.frameOnCanvas = frameOnCanvas
        self.image = image
    }
}
