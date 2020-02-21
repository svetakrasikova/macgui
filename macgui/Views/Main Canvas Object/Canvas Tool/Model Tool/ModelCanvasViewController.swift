//
//  ModelCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasViewController: GenericCanvasViewController{
    
    
    @IBOutlet weak var invitationLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    
    func addParameterView(frame: NSRect, name: String){
        
    }
    
}

extension ModelCanvasViewController: ModelCanvasViewDelegate {
   
    func insertParameter(center: NSPoint, name: String) {
         guard let toolDimension = self.canvasView.canvasObjectDimension
                   else {
                       return
               }
               invitationLabel.isHidden = true
               let size = NSSize(width: toolDimension, height: toolDimension)
               let frame = NSRect(x: center.x - size.width/2, y: center.y - size.height/2, width: size.width, height: size.height)
               addParameterView(frame: frame, name: name)
               if let window = self.view.window {
                   window.makeFirstResponder(canvasView)
               }
               
    }
    
    
}
