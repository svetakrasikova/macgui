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
    case variableController = "VariableController"
    case functionController = "FunctionController"
    case constantController = "ConstantController"
    case alignTool = "AlignTool"
    case alignTabView = "AlignTabView"
    case treesetTool = "TreeSetTool"
    case treeInspector = "TreeInspector"
    case paup = "PaupOverview"
    case loopController = "LoopController"
    case plateController = "PlateController"
    case treePlateController = "TreePlateController"
    case readNumbersInspector = "ReadNumbersInspector"
    case treeTopologyController = "TreeTopologyController"

}

extension ToolObject {
    
    func getStoryboardName() -> String {
        switch self {
        case _ as Model:
            return StoryBoardName.modelTool.rawValue
        case _ as Align:
            return StoryBoardName.alignTool.rawValue
        case _ as TreeSet:
            return StoryBoardName.treesetTool.rawValue
        default:
            return StoryBoardName.modelTool.rawValue
        }
    }
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


