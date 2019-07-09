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
    
   
    
    lazy var tabViewController: NSTabViewController = {
        return self.storyboard!.instantiateController(withIdentifier: "TabViewController")
        }() as! NSTabViewController
    
    lazy var contentViewController: NSViewController = {
        return getChildSheetViewController()
    }()

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPushCancel(notification:)),
                                               name: .dismissToolSheet,
                                               object: nil)
    }
    
    @objc func didPushCancel(notification: NSNotification) {
        presentingViewController?.dismiss(self)
    }
    
    func addContentController(){
        if let tabItem = tabViewController.tabViewItem(for: contentViewController) {
            let index = (tabViewController.view as! NSTabView).indexOfTabViewItem(tabItem)
            tabViewController.selectedTabViewItemIndex = index
        }
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
