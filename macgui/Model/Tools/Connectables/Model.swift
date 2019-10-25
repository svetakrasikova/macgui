//
//  Model.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Model: Connectable {
   
    override init(name: String, frameOnCanvas: NSRect) {
        super.init(name: name, frameOnCanvas: frameOnCanvas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
