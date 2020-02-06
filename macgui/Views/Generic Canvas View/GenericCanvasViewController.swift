//
//  GenericCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/5/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class GenericCanvasViewController: NSViewController, NSWindowDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let window = NSApp.windows.first{
            window.delegate = self
        }
        

    }
    
}

    
