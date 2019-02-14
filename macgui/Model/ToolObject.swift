//
//  ToolObject.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

//Generic class for the tools
class ToolObject: NSObject{
    
    var name: String?
    
    init(name: String){
        self.name = name
    }
}
