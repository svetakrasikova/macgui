//
//  ToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InfoToolViewController: NSViewController {
    
    weak var tool: ToolObject?
    var tabViewController: NSTabViewController?
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TabViewController"){
            tabViewController = (segue.destinationController as! NSTabViewController)
        }
    }
    
    func getTabContentController(index: Int) -> NSViewController? {
        return tabViewController?.tabViewItems[index].viewController
    }
    
       
    
}
