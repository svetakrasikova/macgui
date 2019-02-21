//
//  Analysis.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Analysis: NSObject {
    
    @objc dynamic var name: String
    
    override init(){
        name = "untitled analysis"
        super.init()
    }
    
    init(name: String){
        self.name = name
        super.init()
    }

}


