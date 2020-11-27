//
//  PaupSearchOptionsViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupSearchOptionsViewController: NSViewController {
    

    @objc dynamic var options: PaupOptions?

    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
    }
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        if let windowController = view.window?.windowController as? TablessWindowController,  let parsimonyTool = windowController.tool as? Parsimony {
            self.options = parsimonyTool.options
        }
        
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }
    
    
    
    




    
    
    
    
}
