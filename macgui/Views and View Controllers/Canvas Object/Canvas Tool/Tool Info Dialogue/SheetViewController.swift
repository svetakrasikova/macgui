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
    
    lazy var tabViewController: NSTabViewController = {
        return NSStoryboard.loadVC(StoryBoardName.modalSheetTabView)
        }() as! NSTabViewController
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tool?.descriptiveName
        addContentController()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPushCancel(notification:)),
                                               name: .dismissToolSheet,
                                               object: nil)
    }
    
    @objc func didPushCancel(notification: NSNotification) {
        presentingViewController?.dismiss(self)
    }
    
    func addContentController(){
        let tabIndex = findTabIndex()
        tabViewController.selectedTabViewItemIndex = tabIndex
        let contentController = tabViewController.tabViewItems[tabIndex].viewController as! InfoToolViewController
        contentController.tool = self.tool
    }

    func findTabIndex() -> Int {
        for (index, tabItem) in tabViewController.tabViewItems.enumerated() {
            let name = tool?.getStroyboardName()
            if tabItem.identifier as? String == name {
                return index
            }
        }
        return 0
    }
    
}