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
    
    var tabViewController: NSTabViewController?
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
           if (segue.identifier == "TabViewController")
           { tabViewController = (segue.destinationController as! NSTabViewController) }    }

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
        guard let tabViewController = tabViewController else { return }
        let tabIndex = findTabIndex()
        tabViewController.selectedTabViewItemIndex = tabIndex
        let contentController = tabViewController.tabViewItems[tabIndex].viewController as! InfoToolViewController
        contentController.tool = self.tool
    }

    func findTabIndex() -> Int {
         guard let tabViewController = tabViewController else { return 0 }
        for (index, tabItem) in tabViewController.tabViewItems.enumerated() {
            let name = tool?.getStoryboardName()
            if tabItem.identifier as? String == name {
                return index
            }
        }
        return 0
    }
    
}
