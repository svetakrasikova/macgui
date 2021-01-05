//
//  Tools.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/8/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum ToolType: String, CaseIterable {
    case align
    case bootstrap
    case model
    case readdata
    case simulate
    case treeset
    case parsimony
}

extension CanvasViewController {
    
    func initToolObjectWithName(_ name: String, frame: NSRect, analysis: Analysis) -> ToolObject {
        let toolType = ToolType(rawValue: name)!
        switch toolType {
        case .bootstrap:
            return Bootstrap(name: name, frameOnCanvas: frame, analysis: analysis)
        case .align:
            return Align(name: name, frameOnCanvas: frame, analysis: analysis)
        case .readdata:
            return ReadData(name: name, frameOnCanvas: frame, analysis: analysis)
        case .treeset:
            return TreeSet(name: name, frameOnCanvas: frame, analysis: analysis)
        case .simulate:
            return Simulate(name: name, frameOnCanvas: frame, analysis:analysis)
        case .model:
            return Model(name: name, frameOnCanvas: frame, analysis: analysis)
        case .parsimony:
            return Parsimony(name: name, frameOnCanvas: frame, analysis: analysis)
            
        }
    }
}

extension ToolObject {
    
    func getDescriptiveNameString(name: String) -> String {
        let toolType = ToolType(rawValue: name)!
        switch toolType {
        case  .bootstrap:
            return "Bootstrap Tool"
        case .align:
            return "Sequence Alignment Tool"
        case .readdata:
            return "Read Data Tool"
        case .treeset:
            return "Tree Set Tool"
        case .simulate:
            return "Data Simulation Tool"
        case .model:
            return "Data Model Tool"
        case .parsimony:
            return "PAUP* Tool"
            
        }
    }
    
}
