//
//  ModelCanvasItemViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemViewController: CanvasObjectViewController {
   
    weak var node: ModelNode?
    var frame: NSRect {
        guard let node = self.node else {
            return NSZeroRect
        }
        return node.frameOnCanvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        setFrame()
    }
    
    func setFrame () {
        view.frame = self.frame
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
}
