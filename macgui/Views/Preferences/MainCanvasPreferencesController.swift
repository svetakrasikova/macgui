//
//  MainCanvasPreferencesController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MainCanvasPreferencesController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        NotificationCenter.default.post(name: .didChangeSettings,
        object: nil,
        userInfo: ["magnification": 0.0])

    }
}
