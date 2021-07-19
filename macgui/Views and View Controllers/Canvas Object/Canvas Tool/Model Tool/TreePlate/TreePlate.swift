//
//  TreePlate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlate: Plate {
    
    enum Keys: String {
        case model
    }
    weak var model: Model?
   
    override init(frameOnCanvas: NSRect, analysis: Analysis, index: String){
        super.init(frameOnCanvas: frameOnCanvas, analysis: analysis, index: index)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(model, forKey: Keys.model.rawValue)
    }
    
    required init?(coder: NSCoder) {
        model = coder.decodeObject(forKey: Keys.model.rawValue) as? Model
        super.init(coder: coder)
    }
    

   
    
    
}
