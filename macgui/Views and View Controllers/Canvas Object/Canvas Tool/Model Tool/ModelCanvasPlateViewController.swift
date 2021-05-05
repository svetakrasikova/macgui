//
//  ModelCanvasPlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/23/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasPlateViewController: ResizableCanvasObjectViewController {

    lazy var loopController: ModelPlateController = {
        let loopController = NSStoryboard.loadVC(StoryBoardName.plateController) as! ModelPlateController
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
             view = ModelCanvasPlateView(frame: loop.frameOnCanvas)
         }
         
     }
     
     override func  setBackgroundColor() {
         guard let view = view as? ModelCanvasPlateView else { return }
         let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
         view.backgroundColor = preferencesManager.modelCanvasBackgroundColor
         
     }
     
     override func actionButtonClicked(_ button: ActionButton) {
         self.presentAsModalWindow(loopController)
     }
}
