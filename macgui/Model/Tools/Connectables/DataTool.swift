//
//  DataTool.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/25/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class DataTool: Connectable {
    
    var dataMatrices: [DataMatrix]? = []
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(dataMatrices, forKey: "dataMatrices")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataMatrices = aDecoder.decodeObject(forKey: "dataMatrices") as? [DataMatrix]
    }
    
}
