//
//  SheetViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class SheetViewController: NSViewController {
    
    enum Appearance {
        static let modalSheetWidth: CGFloat = 330.0
        static let modalSheetHight: CGFloat = 330.0
    }
    weak var tool: ToolObject?
    
    var contentViewController: NSViewController {
        return getChildSheetViewController()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewWillLayout() {
        self.preferredContentSize = NSSize(width: Appearance.modalSheetWidth, height: Appearance.modalSheetHight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tool?.name
        addContentController()
    }
    
    
    func addContentController(){
        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
    }
    
    func getChildSheetViewController() -> NSViewController {
        switch tool {
        case _ as ReadData:
            let childVC = NSStoryboard.load(.readData)
            return childVC
        default:
            return NSStoryboard.load(.readData) 
        }
        
    }
    
}
