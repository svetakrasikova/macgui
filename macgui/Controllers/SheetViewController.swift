//
//  SheetViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class SheetViewController: NSViewController {
    
    weak var tool: ToolObject?
    
    var contentViewController: NSViewController {
        return getChildSheetViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
    }
    
    func getChildSheetViewController() -> NSViewController {
        switch tool {
        case _ as ReadData:
            return NSStoryboard.load(.readData)
        default:
            return self
        }
        
    }
    
}
