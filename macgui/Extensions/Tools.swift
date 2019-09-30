//
//  Tools.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/8/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum ToolType: String, CaseIterable {
    case align = "align"
    case bootstrap = "bootstrap"
    case  model = "model"
    case  readdata = "readdata"
    case simulate = "simulate"
    case treeset = "treeset"
}

extension CanvasViewController {
    
    func initToolObjectWithName(_ name: String, frame: NSRect) -> ToolObject {
        let toolType = ToolType(rawValue: name)!
        switch toolType {
        case  .bootstrap:
            return Bootstrap(name: name, frameOnCanvas: frame)
        case .align:
            return Align(name: name, frameOnCanvas: frame)
        case .readdata:
            return ReadData(name: name, frameOnCanvas: frame)
        case .treeset:
            return TreeSet(name: name, frameOnCanvas: frame)
        case .simulate:
            return Simulate(name: name, frameOnCanvas: frame)
        case .model:
            return Model(name: name, frameOnCanvas: frame)
            
        }
    }
}
