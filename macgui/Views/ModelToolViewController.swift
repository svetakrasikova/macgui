//
//  ReadDataViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolViewController: ToolViewController {
    
    @IBAction func cancelPushed(_ sender: NSButton) {
        NotificationCenter.default.post(name: .dismissToolSheet, object: self)
    }
  
    
}




