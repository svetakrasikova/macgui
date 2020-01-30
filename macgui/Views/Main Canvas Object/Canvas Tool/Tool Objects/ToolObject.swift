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
   
    init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        self.name = name
        self.frameOnCanvas = frameOnCanvas
        self.analysis = analysis
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(frameOnCanvas, forKey: "frameOnCanvas")
        aCoder.encode(descriptiveName, forKey: "descriptiveName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        analysis = aDecoder.decodeObject(forKey: "analysis") as! Analysis
        frameOnCanvas = aDecoder.decodeRect(forKey: "frameOnCanvas")
        name = aDecoder.decodeObject(forKey: "name") as! String
        
    }
}

extension ToolObject {

func getStroyboardName() -> String {
    switch self {
    case _ as Model:
        return StoryBoardName.modelTool.rawValue
    default:
        return StoryBoardName.modelTool.rawValue
        }
    }
    
}

protocol ToolObjectDelegate: class {
    func startProgressIndicator()
    func endProgressIndicator()
}



