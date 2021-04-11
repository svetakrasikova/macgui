//
//  CanvasLoopViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasLoopViewController: CanvasObjectViewController, ActionButtonDelegate {
   
  
    
    
    override func loadView() {
        if let loop = self.tool as? Loop {
            view = CanvasLoopView(frame: loop.frameOnCanvas)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = view as? CanvasLoopView else { return }
        view.wantsLayer = true
        if let backgroundColor = view.backgroundColor {
            view.drawBorderAndAnchors(fillcolor: backgroundColor.withAlphaComponent(0.2), strokeColor: NSColor.systemGray, dash: false, anchors: false)
            
        }
    }
    
    func actionButtonClicked(_ button: ActionButton) {
        
    }

    
}
