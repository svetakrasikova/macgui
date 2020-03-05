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
     
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var arrowColor: NSColor? {
        if  let color = preferencesManager.modelCanvasArrowColor {
            return color
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(didConnectNodes(notification:)),
                                                      name: .didConnectNodes,
                                                      object: nil)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    @objc func didConnectNodes(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: ModelCanvasItemView]
            else { return }
        
        guard let target = userInfo["target"]?.delegate as? ModelCanvasItemViewController else { return }

        guard let source = userInfo["source"]?.delegate as? ModelCanvasItemViewController else { return }
        
        guard let arrowColor = arrowColor else { return }
        
        if userInfo["target"]?.window == self.view.window, let targetNode = target.tool, let sourceNode = source.tool {
            let arrowController = setUpConnection(frame: canvasView.bounds, color: arrowColor, sourceNode: sourceNode as! Connectable, targetNode: targetNode as! Connectable)
            addChild(arrowController)
            canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
        }
    }
    
    func setUpConnection(frame: NSRect, color: NSColor, sourceNode: Connectable, targetNode: Connectable) -> ArrowViewController {
        let arrowController = ArrowViewController()
        arrowController.frame = frame
        arrowController.color = color
        arrowController.sourceTool = sourceNode
        arrowController.targetTool = targetNode
        return arrowController
    }
    
    
    func addParameterView(node: ModelNode) {
        guard let modelCanvasItemVC = NSStoryboard.loadVC(.modelCanvasItem) as? ModelCanvasItemViewController else { return }
        modelCanvasItemVC.tool = node
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

