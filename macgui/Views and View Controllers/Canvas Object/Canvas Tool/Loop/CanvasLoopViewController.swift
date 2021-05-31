//
//  CanvasLoopViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasLoopViewController: ResizableCanvasObjectViewController {
   
    lazy var loopController: LoopController = {
        let loopController = NSStoryboard.loadVC(StoryBoardName.loopController) as! LoopController
        if let loop = self.tool as? Loop {
            loopController.loop = loop
        }
        if let canvasVC = self.parent as? GenericCanvasViewController {
            loopController.delegate = canvasVC
        }
        return loopController
    }()
  
    override func loadView() {
        if let loop = self.tool as? Loop {
            view = CanvasLoopView(frame: loop.frameOnCanvas)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopOver()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        closePopover()
        invalidatePopoverTimers()
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? CanvasLoopView else { return }
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        view.backgroundColor = preferencesManager.canvasLoopBackgroundColor?.withAlphaComponent(0.2)
        
    }
    
    override func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(loopController)
    }
    
    
}
