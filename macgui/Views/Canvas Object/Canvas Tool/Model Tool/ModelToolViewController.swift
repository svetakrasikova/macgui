//
//  ReadDataViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolViewController: NSSplitViewController {
    
    weak var tool: ToolObject?
    
    override func viewWillAppear() {
           super.viewWillAppear()
        
           if let modelToolWC = view.window?.windowController as? ModelToolWindowController {
               self.tool = modelToolWC.tool
           }
           
       }
    
}




