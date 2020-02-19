//
//  ReadDataViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/1/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolViewController: NSSplitViewController, ModelPaletteViewControllerDelegate {
    
    weak var tool: ToolObject?
    var parameters: [Parameter]?
    
    weak var paletteViewController: ModelPaletteViewController? {
        for child in self.children {
            if child.isKind(of: ModelPaletteViewController.self) {
                return child as? ModelPaletteViewController
            }
        }
        return nil
    }
    
    weak var canvasViewController: ModelCanvasViewController? {
        for child in self.children {
            if child.isKind(of: ModelCanvasViewController.self){
                return child as? ModelCanvasViewController
            }
        }
        return nil
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let modelToolWC = view.window?.windowController as? ModelToolWindowController {
            self.tool = modelToolWC.tool
            self.parameters = modelToolWC.parameters
        }
        
        paletteViewController?.delegate = self
        
    }
    
}




