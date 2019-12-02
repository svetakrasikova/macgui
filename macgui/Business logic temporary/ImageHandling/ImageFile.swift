//
//  ImageFile.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa


class ImageFile: NSObject {
    
    
    var name: ToolType
    var image: NSImage? {
        return NSImage(named: self.name.rawValue)
    }
    
    init(name: ToolType){
        self.name = name
    }
}
