//
//  CanvasLoopViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasLoopViewController: ResizableCanvasObjectViewController {
   
  
    override func loadView() {
        if let loop = self.tool as? Loop {
            view = CanvasLoopView(frame: loop.frameOnCanvas)
        }
        
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? CanvasLoopView else { return }
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        view.backgroundColor = preferencesManager.canvasLoopBackgroundColor?.withAlphaComponent(0.2)
        
    }
    
    override func actionButtonClicked(_ button: ActionButton) {
        
    }

    
}
