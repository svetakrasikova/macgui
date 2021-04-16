//
//  Loop.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/9/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Loop: ToolObject {
    
    enum CodingKeys: String {
        case outerLoop, embeddedLoops, index, upperRange
    }
  
    var outerLoop: Loop?
    var embeddedLoops: [Loop] = []
    var index: String = "i"
    var upperRange: Int = 1
    
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis){
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(outerLoop, forKey: CodingKeys.outerLoop.rawValue)
        coder.encode(embeddedLoops, forKey: CodingKeys.embeddedLoops.rawValue)
        coder.encode(index, forKey: CodingKeys.index.rawValue)
        coder.encode(upperRange, forKey: CodingKeys.upperRange.rawValue)
    }
    
    required init?(coder decoder: NSCoder) {
        
        outerLoop = decoder.decodeObject(forKey: CodingKeys.outerLoop.rawValue) as? Loop
        embeddedLoops = decoder.decodeObject(forKey: CodingKeys.embeddedLoops.rawValue) as? [Loop] ?? []
        index = decoder.decodeObject(forKey: CodingKeys.index.rawValue) as? String ?? "i"
        upperRange = decoder.decodeInteger(forKey: CodingKeys.upperRange.rawValue)
        super.init(coder: decoder)
    }

}
