//
//  ToolObject.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolObject: NSObject, NSCoding {
    
    var image: NSImage
    @objc dynamic var frameOnCanvas: NSRect
    var name: String?
    
    
    init(image: NSImage, frameOnCanvas: NSRect){
        self.frameOnCanvas = frameOnCanvas
        self.image = image
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(frameOnCanvas, forKey: "frameOnCanvas")
        if let name = name {
            aCoder.encode(name, forKey: "name")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        image = aDecoder.decodeObject(forKey: "image") as! NSImage
        frameOnCanvas = aDecoder.decodeObject(forKey: "frameOnCanvas") as! NSRect
        
    }
}
