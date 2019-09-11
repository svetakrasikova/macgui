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
    
    func initToolObjectWithName(_ name: String, image: NSImage, frame: NSRect) -> ToolObject {
        let toolType = ToolType(rawValue: name)!
        switch toolType {
        case  .bootstrap:
            return Bootstrap(image: image, frameOnCanvas: frame)
        case .align:
            return Align(image: image, frameOnCanvas: frame)
        case .readdata:
            return ReadData(image: image, frameOnCanvas: frame)
        case .treeset:
            return TreeSet(image: image, frameOnCanvas: frame)
        case .simulate:
            return Simulate(image: image, frameOnCanvas: frame)
        case .model:
            return Model(image: image, frameOnCanvas: frame)
            
        }
    }
}
