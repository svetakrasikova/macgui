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
}


extension NSStoryboard{
    class func load(_ storyboard: StoryBoardName) -> NSViewController{
        return NSStoryboard(name: storyboard.rawValue, bundle: nil).instantiateController(withIdentifier: storyboard.rawValue) as! NSViewController
    }
}
