//
//  ReadDataViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/6/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadDataViewController: NSViewController {
    
    
    var tabViewController: NSTabViewController {
        return self.storyboard!.instantiateController(withIdentifier: "TabViewController") as! NSTabViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
