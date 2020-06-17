//
//  ToolObject.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ToolObject: NSObject, NSCoding {
    
    @objc dynamic var frameOnCanvas: NSRect
    var name: String
    var descriptiveName: String {
        return getDescriptiveNameString(name: name)
    }
    unowned let analysis: Analysis
    weak var delegate: ToolObjectDelegate?
    
    enum Key: String {
        case name = "name"
        case frameOnCanvas = "frameOnCanvas"
        case descriptiveName = "descriptiveName"
        case analysis = "analysis"
    }
    
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        self.name = name
        self.frameOnCanvas = frameOnCanvas
        self.analysis = analysis
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(frameOnCanvas, forKey: Key.frameOnCanvas.rawValue)
        aCoder.encode(analysis, forKey: Key.analysis.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        analysis = aDecoder.decodeObject(forKey: Key.analysis.rawValue) as! Analysis
        frameOnCanvas = aDecoder.decodeRect(forKey: Key.frameOnCanvas.rawValue)
        name = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        
    }
}

extension ToolObject {

func getStoryboardName() -> String {
    switch self {
    case _ as Model:
        return StoryBoardName.modelTool.rawValue
    case _ as Align:
        return StoryBoardName.alignTool.rawValue
    default:
        return StoryBoardName.modelTool.rawValue
        }
    }
    
}

protocol ToolObjectDelegate: class {
    func startProgressIndicator()
    func endProgressIndicator()
}



