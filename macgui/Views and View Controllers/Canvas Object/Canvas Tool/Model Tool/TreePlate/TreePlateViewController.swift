//
//  TreePlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateViewController: ResizableCanvasObjectViewController {

    override func loadView() {
        if let treePlate = self.tool as? TreePlate {
            view = TreePlateView(frame: treePlate.frameOnCanvas)
        }
        
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? TreePlateView else { return }
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        view.backgroundColor = preferencesManager.modelCanvasBackgroundColor
        
    }
    
    
}
