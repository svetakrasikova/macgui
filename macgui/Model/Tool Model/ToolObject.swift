//
//  ToolObject.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolObject: NSObject, NSCoding {
    
    @objc dynamic var frameOnCanvas: NSRect
    var name: String
    var descriptiveName: String {
        return getDescriptiveNameString(name: name)
    }
   
    init(name: String, frameOnCanvas: NSRect){
        self.name = name
        self.frameOnCanvas = frameOnCanvas
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(frameOnCanvas, forKey: "frameOnCanvas")
        aCoder.encode(descriptiveName, forKey: "descriptiveName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        frameOnCanvas = aDecoder.decodeRect(forKey: "frameOnCanvas")
        name = aDecoder.decodeObject(forKey: "name") as! String
        
    }
}


