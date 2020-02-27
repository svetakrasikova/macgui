//
//  ModelCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasViewController: GenericCanvasViewController {
    
    
    @IBOutlet weak var invitationLabel: NSTextField!
 
    weak var model: Model? {
        if let modelToolVC = parent as? ModelToolViewController {
            return modelToolVC.tool ?? nil
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    
    func addParameterView(node: ModelNode) {
        guard let modelCanvasItemVC = NSStoryboard.loadVC(.modelCanvasItem) as? ModelCanvasItemViewController else { return }
        modelCanvasItemVC.node = node
        addChild(modelCanvasItemVC)
        canvasView.addSubview(modelCanvasItemVC.view)
    }
    
    func addNodeToModel(frame: NSRect, item: PalettItem){
        if let model = self.model {
            let newModelNode = ModelNode(name: item.name, frameOnCanvas: frame, analysis: model.analysis, nodeType: item)
            model.nodes.append(newModelNode)
            addParameterView(node: newModelNode)
        }
    }
    
}

extension ModelCanvasViewController: ModelCanvasViewDelegate {
    func insertParameter(center: NSPoint, item: PalettItem) {
        guard let toolDimension = self.canvasView.canvasObjectDimension
            else { return }
        invitationLabel.isHidden = true
        let size = NSSize(width: toolDimension, height: toolDimension)
        let frame = NSRect(x: center.x - size.width/2, y: center.y - size.height/2, width: size.width, height: size.height)
        addNodeToModel(frame: frame, item: item)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)
        }
    }
    
   
    
}

