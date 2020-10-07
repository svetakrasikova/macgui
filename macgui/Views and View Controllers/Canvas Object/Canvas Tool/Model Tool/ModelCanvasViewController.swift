//
//  ModelCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasViewController: GenericCanvasViewController {

 
    weak var model: Model? {
        if let modelToolVC = parent as? ModelToolViewController {
            return modelToolVC.tool ?? nil
        }
        return nil
    }
    
   
    
    var parameterNames: [Bool] = Array(repeating: false, count: 10)
    
    func getParameterName() -> String {
        for i in 0...parameterNames.count-1 {
            if !parameterNames[i] {
                parameterNames[i] = true
                return "Parameter \(i+1)"
            }
        }
        let nextAfterHighest = parameterNames.count
        parameterNames +=  Array(repeating: false, count: 10)
        parameterNames[nextAfterHighest] = true
        return "Parameter \(nextAfterHighest)"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(didConnectNodes(notification:)),
                                                      name: .didConnectNodes,
                                                      object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteSelectedCanvasObjects(notification:)),
                                               name: .didSelectDeleteKey,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChildViewControllerAppearance), name: UserDefaults.didChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeModelParameterName(notification:)), name: .didChangeModelParameterName, object: nil)
    }
    
    @objc func changeModelParameterName(notification: Notification) {
        if let userInfo = notification.userInfo as? [String : String], let index = Int(userInfo["index"]!) {
            parameterNames[index-1] = false
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    @objc func updateChildViewControllerAppearance(notification: Notification){
        guard ((notification.object as? ModelCanvasPreferencesController) != nil) ||
        ((notification.object as? PreferencesManager) != nil) 
        else {
            return
        }
        for child in children {
            child.view.needsDisplay = true
        }
    }
    
    @objc func didConnectNodes(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: ModelCanvasItemView]
            else { return }
        
        guard let target = userInfo["target"]?.delegate as? ModelCanvasItemViewController else { return }

        guard let source = userInfo["source"]?.delegate as? ModelCanvasItemViewController else { return }
        
        if userInfo["target"]?.window == self.view.window, let targetNode = target.tool as? Connectable, let sourceNode = source.tool as? Connectable {
           
            guard let connection = setUpConnection(sourceNode: sourceNode, targetNode: targetNode)
                else { return }
          
           addEdgeToModel(connection: connection)
        }
    }
    
    @objc func deleteSelectedCanvasObjects(notification: Notification){
        
        guard self.view.window?.isMainWindow ?? true else { return }
        
        var numConnectionsToDelete = 0
        for childController in children {
            if childController .isKind(of: ArrowViewController.self) &&
                (childController as! CanvasObjectViewController).viewSelected == true {
                numConnectionsToDelete = numConnectionsToDelete + 1
            }
        }
        if numConnectionsToDelete > 0 {
            for childController in children {
                if childController .isKind(of: ModelCanvasItemViewController.self) &&
                    (childController as! CanvasObjectViewController).viewSelected == true {
                    removeCanvasObjectView(canvasObjectViewController: childController as! CanvasObjectViewController)
                }
            }
            for childController in children {
                if childController .isKind(of: ArrowViewController.self) &&
                    (childController as! CanvasObjectViewController).viewSelected == true {
                    removeCanvasObjectView(canvasObjectViewController: childController as! CanvasObjectViewController)
                }
            }
            
        } else {
            for childController in children {
                if childController .isKind(of: ModelCanvasItemViewController.self) &&
                    (childController as! CanvasObjectViewController).viewSelected == true {
                    removeCanvasObjectView(canvasObjectViewController: childController as! CanvasObjectViewController)
                }
            }
        }
    }
    
    
    func removeCanvasObjectView(canvasObjectViewController: CanvasObjectViewController) {
          if canvasObjectViewController.isKind(of: ArrowViewController.self){
              removeConnectionFromModel(arrowViewController: canvasObjectViewController as! ArrowViewController)
          } else {
              if canvasObjectViewController.isKind(of: ModelCanvasItemViewController.self){
                  removeNodeFromModel(nodeViewController: canvasObjectViewController as! ModelCanvasItemViewController)
              }
          }
          canvasObjectViewController.view.removeFromSuperview()
          canvasObjectViewController.removeFromParent()
      }
    
    func removeConnectionFromModel(arrowViewController: ArrowViewController) {
        if let model = self.model, let connection = arrowViewController.connection, let index = model.edges.firstIndex(of: connection) {
            arrowViewController.willDeleteView()
            model.edges.remove(at: index)
        }
    }
    
    
    func removeNodeFromModel(nodeViewController: ModelCanvasItemViewController) {
        if let model = self.model, let index = model.nodes.firstIndex(of: nodeViewController.tool as! ModelNode)
        {
            let arrowViewControllers = findArrowControllersByTool(tool: nodeViewController.tool!)
            for arrowViewController in arrowViewControllers {
                removeCanvasObjectView(canvasObjectViewController: arrowViewController)
            }
            model.nodes.remove(at: index)
        }
    }
    
    func setUpConnection(sourceNode: Connectable, targetNode: Connectable) -> Connection? {
        let connection = Connection(to: targetNode, from: sourceNode, type: .modelParameter)
        return connection
    }
    
    func setUpArrowViewController(_ connection:  Connection) -> ArrowViewController{
        let arrowController = ArrowViewController()
        arrowController.frame = canvasView.bounds
        arrowController.sourceTool = connection.from
        arrowController.targetTool = connection.to
        arrowController.connection = connection
        return arrowController
    }
    
    
    func addArrowView(connection: Connection) {
        let arrowController = setUpArrowViewController(connection)
        addChild(arrowController)
        canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
    }
    
    func addEdgeToModel(connection: Connection){
        if let model = self.model {
            model.edges.append(connection)
            addArrowView(connection: connection)
        }
    }
    
    
    func addNodeView(node: ModelNode) {
        guard let modelCanvasItemVC = NSStoryboard.loadVC(.modelCanvasItem) as? ModelCanvasItemViewController else { return }
        modelCanvasItemVC.tool = node
        addChild(modelCanvasItemVC)
        canvasView.addSubview(modelCanvasItemVC.view)
    }
    
    func addVariableToModel(frame: NSRect, item: PaletteVariable, type: PaletteVariable.VariableType){
        if let model = self.model {
            let newModelNode = ModelNode(name: item.type, frameOnCanvas: frame, analysis: model.analysis, node: item)
            newModelNode.nodeType = type
            newModelNode.parameterName = getParameterName()
            model.nodes.append(newModelNode)
            addNodeView(node: newModelNode)
        }
    }
    
    func resetCanvasView(){
    
        guard let model = self.model
            else { return }
        
        for subview in canvasView.subviews{
            if subview.isKind(of: CanvasObjectView.self) {
                subview.removeFromSuperview()
            }
        }
        for child in children{
            if child.isKind(of: CanvasObjectViewController.self) {
                child.removeFromParent()
            }
        }
        for node in model.nodes {
            addNodeView(node: node)
        }
        for edge in model.edges {
            addArrowView(connection: edge)
        }
    }
    
    func getPalettVariableWithName(_ name: String) -> PaletteVariable? {
        if let model = self.model {
            for item in model.palettItems {
                guard let item = item as? PaletteVariable else {return nil}
                if item.type == name {
                    return item
                }
            }
        }
        return nil
    }
    
}

extension ModelCanvasViewController: ModelCanvasViewDelegate {
    func insertParameter(center: NSPoint, item: String) {
        guard let toolDimension = self.canvasView.canvasObjectDimension
            else { return }
        let size = NSSize(width: toolDimension, height: toolDimension)
        let frame = NSRect(x: center.x - size.width/2, y: center.y - size.height/2, width: size.width, height: size.height)
        let variableData = item.split(separator: ":")
        guard let variable = getPalettVariableWithName(String(variableData[0])) else { return }
        guard let variableType = PaletteVariable.VariableType(rawValue: String(variableData[1])) else { return }
        addVariableToModel(frame: frame, item: variable, type: variableType)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)
        }
    }
    
   
    
}

extension ModelCanvasViewController: ModelVariableControllerDelegate {
    
    func getDistributionsForParameter(_ modelNode: ModelNode) -> [Distribution] {
        
        guard let distributions = self.model?.distributions else {
            return []
        }
        var resultList: [Distribution] = []
        for distribution in distributions {
            if distribution.domain == modelNode.node.type {
                resultList.append(distribution)
            }
        }
       return resultList
    }
    
    
}

