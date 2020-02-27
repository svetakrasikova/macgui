//
//  Storyboards.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/2/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

enum StoryBoardName: String {
    case main = "Main"
    case canvasTool = "CanvasTool"
    case canvas = "EditorTools"
    case analyses = "AnalysisLogView"
    case modalSheet = "ModalSheet"
    case modelTool = "ModelTool"
    case modalSheetTabView = "ModalSheetTabView"
    case toolTip = "ToolTip"
    case notebook = "Notebook"
    case matrixInspector = "MatrixInspector"
    case modelCanvasItem = "ModelCanvasItem"
}



extension NSStoryboard{
    class func loadVC(_ storyboard: StoryBoardName) -> NSViewController{
        return NSStoryboard(name: storyboard.rawValue, bundle: nil).instantiateController(withIdentifier: storyboard.rawValue) as! NSViewController
    }
    class func loadVC(_ storyboard: StoryBoardName, controller: String) -> NSViewController{
        return NSStoryboard(name: storyboard.rawValue, bundle: nil).instantiateController(withIdentifier: controller) as! NSViewController
    }
    
    class func loadWC(_ storyboard: StoryBoardName, controller: String) -> NSWindowController {
        return NSStoryboard(name: storyboard.rawValue, bundle: nil).instantiateController(withIdentifier: controller) as! NSWindowController
    }
    
    class func loadWC(_ storyboard: StoryBoardName) -> NSWindowController {
        return NSStoryboard(name: storyboard.rawValue, bundle: nil).instantiateController(withIdentifier: storyboard.rawValue) as! NSWindowController
    }
}


