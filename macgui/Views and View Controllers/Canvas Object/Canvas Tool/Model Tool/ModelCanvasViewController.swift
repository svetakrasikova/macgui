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
        if bottomMostNode == nil {
            bottomMostNode = modelCanvasItemVC
        }
        if let topMostPlate = topMostLoop {
            canvasView.addSubview(modelCanvasItemVC.view, positioned: .above, relativeTo: topMostPlate.view)
        } else {
            canvasView.addSubview(modelCanvasItemVC.view)
        }
        modelCanvasItemVC.checkForLoopInclusion()
    }
    
    func addVariableToModel(frame: NSRect, item: PaletteVariable, type: PaletteVariable.VariableType){
        guard let model = self.model else { return }
        let newModelNode = ModelNode(name: item.type, frameOnCanvas: frame, analysis: model.analysis, node: item)
        newModelNode.nodeType = type
        newModelNode.defaultParameterName = getParameterName()
        model.nodes.append(newModelNode)
    }
    
    func addPlateView(plate: Loop) {
        let plateViewController = ModelCanvasPlateViewController()
        plateViewController.tool = plate
        addChild(plateViewController)
        if let bottomMostNode = self.bottomMostNode {
            canvasView.addSubview(plateViewController.view, positioned: .below, relativeTo: bottomMostNode.view)
        } else {
            canvasView.addSubview(plateViewController.view)
        }
        topMostLoop = plateViewController
        plateViewController.checkForLoopInclusion()
    }
    
    func addPlateToModel(frame: NSRect) {
        guard let model = self.model else { return }
        if let index = generateActiveIndex() {
            let plate = Loop(frameOnCanvas: frame, analysis: model.analysis, index: index)
            model.plates.append(plate)
            addPlateView(plate: plate)
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
        for child in children {
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
    
    
//    MARK: -- Plate Management

    let plateIndices: [String] = ["a","b","c","d","e", "f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var activePlateIndices: [Int] {
        var indexTable = [Int]()
        var activeIndicesList = [String]()
        
        if let model = self.model {
            for plate in model.plates {
                activeIndicesList.append(plate.index)
            }
        }
        for index in activeIndicesList {
            if let i = plateIndices.firstIndex(of: index) {
                indexTable.append(i)
            }
        }
        return indexTable
    }
    
    func generateActiveIndex() -> String? {
        var index: String?
        for i in 0..<plateIndices.count {
            if let _ = activePlateIndices.firstIndex(of: i) {
                continue
            } else {
                index = plateIndices[i]
                break
            }
        }
        return index
    }

    
}

extension ModelCanvasViewController: ModelCanvasViewDelegate {
    
    func insertPaletteItem(center: NSPoint, item: String) {
        addCanvasItem(center: center, data: item)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)
        }
    }
    
    func addCanvasItem(center: NSPoint, data: String ){
        let variableData = data.split(separator: ":")
        if variableData[0] != PalettItem.plateType {
            guard let nodeDimension = self.canvasView.canvasObjectDimension else { return }
            guard let variableName = getPalettVariableWithName(String(variableData[0])) else { return }
            guard let variableType = PaletteVariable.VariableType(rawValue: String(variableData[1])) else { return }
            addVariableToModel(frame: canvasItemFrame(center: center, dimension: nodeDimension), item: variableName, type: variableType)
        } else {
            guard let plateDimension = self.canvasView.canvasLoopDimension else { return }
            addPlateToModel(frame: canvasItemFrame(center: center, dimension: plateDimension))
        }
    }
    
    func canvasItemFrame(center: NSPoint, dimension: CGFloat) -> NSRect {
        return NSRect(x: center.x - dimension/2, y: center.y - dimension/2, width: dimension, height: dimension)
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

