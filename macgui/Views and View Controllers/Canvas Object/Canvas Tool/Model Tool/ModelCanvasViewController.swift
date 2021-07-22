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
    
    var allPlates: [Plate] {
        guard let model = self.model else { return []}
        return model.plates
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
    
    override var activeLoopIndices: [Int] {
        var indexTable = [Int]()
        var activeIndicesList = [String]()
       
        if let model = model {
            for plate in model.plates {
                activeIndicesList.append(plate.index)
            }
            
            for index in activeIndicesList {
                if let i = loopIndices.firstIndex(of: index) {
                    indexTable.append(i)
                }
            }
        }
        return indexTable
    }
    
    var resettingCanvasView: Bool = false
    
    
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
    
    override func removeConnection(arrowViewController: ArrowViewController) {
        super.removeConnection(arrowViewController: arrowViewController)
        if let model = self.model, let connection = arrowViewController.connection, let index = model.edges.firstIndex(of: connection) {
            model.edges.remove(at: index)
        }
    }
    
    override func removeConnectable(viewController: CanvasObjectViewController) {
        guard let node = viewController.tool as? ModelNode else { return }
        super.removeConnectable(viewController: viewController)
        if let model = self.model, let index = model.nodes.firstIndex(of: node){
            model.nodes.remove(at: index)
        }
    }
    
    @objc override func deleteSelectedCanvasObjects(notification: NSNotification){
        var topologyNodeSelected = false
        for childController in children {
            if let childController = childController as? ModelCanvasItemViewController,
               childController.viewSelected == true, let model = childController.tool as? ModelNode, model.treePlate != nil {
                topologyNodeSelected = true
                
            }
        }
        if !topologyNodeSelected {
            super.deleteSelectedCanvasObjects(notification: notification)
        }
    }
    
    override func removeResizable(viewController: ResizableCanvasObjectViewController) {
        super.removeResizable(viewController: viewController)
        if let treePlateVC = viewController as? TreePlateViewController, let edge = treePlateVC.edgeViewController, let topologyVC = treePlateVC.topologyNodeViewController {
            edge.view.removeFromSuperview()
            edge.removeFromParent()
            removeConnectable(viewController: topologyVC)
        
        }
        guard let plate = viewController.tool as? Plate else { return }
        if let model = self.model, let index = model.plates.firstIndex(of: plate) {
            model.plates.remove(at: index)
        }
    }
    
    func setUpConnection(sourceNode: Connectable, targetNode: Connectable) -> Connection? {
        let connection = Connection(to: targetNode, from: sourceNode, type: .modelParameter)
        return connection
    }
    
    func setUpArrowViewController(_ connection:  Connection) -> ArrowViewController {
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
        canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: bottomMostNonResizableObject?.view)
        bottomMostNonResizableObject = arrowController
    }
    
    func addEdgeToModel(connection: Connection){
        if let model = self.model {
            model.edges.append(connection)
            addArrowView(connection: connection)
        }
    }
    
    override func toolViewController() -> CanvasObjectViewController? {
        return NSStoryboard.loadVC(.modelCanvasItem) as? ModelCanvasItemViewController
    }
    
    override func resizableObjectViewController() -> ResizableCanvasObjectViewController? {
        return ModelCanvasPlateViewController()
    }
    
    func addVariableToModel(frame: NSRect, item: PaletteVariable, type: PaletteVariable.VariableType, treePlate: TreePlate?) {
        guard let model = self.model else { return }
        let node = ModelNode(name: item.type, frameOnCanvas: frame, analysis: model.analysis, node: item)
        node.nodeType = type
        node.defaultParameterName = getParameterName()
        if let treePlate = treePlate {
            node.treePlate = treePlate
        }
        model.nodes.append(node)
        addToolView(tool: node)
    }
    
    func addPlateToModel(frame: NSRect) {
        guard let model = self.model else { return }
        if let index = generateActiveIndex() {
            let plate = Plate(frameOnCanvas: frame, analysis: model.analysis, index: index)
            model.plates.append(plate)
            addLoopView(loop: plate)
        }
    }
    
    func addTreePlateToModel(plateFrame: NSRect, topologyFrame: NSRect) {
        guard let model = self.model else { return }
        guard let index = generateActiveIndex() else { return }
       
        let treePlate = TreePlate(frameOnCanvas: plateFrame, analysis: model.analysis, index: index)
        model.plates.append(treePlate)
        addTreePlateView(treePlate, topologyFrame: topologyFrame)
        
        
    }
    
    func addTreePlateView(_ treePlate: TreePlate , topologyFrame: NSRect?) {
        let treePlateViewController = TreePlateViewController()
        treePlateViewController.tool = treePlate
        addChild(treePlateViewController)
        let view = treePlateViewController.view
        if let bottomMostNode = self.bottomMostNonResizableObject {
            canvasView.addSubview(view, positioned: .below, relativeTo: bottomMostNode.view)
        } else {
            canvasView.addSubview(view)
        }
        topMostLoop = treePlateViewController
        
        if let topologyFrame = topologyFrame {
            addVariableToModel(frame: topologyFrame, item: PaletteVariable(name: PalettItem.treeTopologyType), type: .constant, treePlate: treePlate)
        }
        if let topologyNode = findTopologyNode(treePlate) {
            treePlateViewController.topologyNodeViewController = topologyNode
            addTreePlateEdge(from: topologyNode, to: treePlateViewController)
        }
        
    }
    
    func findTopologyNode(_ treePlate: TreePlate) -> ModelCanvasItemViewController? {
        for vc in children {
            if let nodeVC = vc as? ModelCanvasItemViewController, let node = nodeVC.tool as? ModelNode {
                if node.treePlate === treePlate {
                    return nodeVC
                }
            }
        }
        return nil
        
    }
    
    func addTreePlateEdge(from: CanvasObjectViewController, to: TreePlateViewController) {
        let edgeViewController = EdgeViewController()
        edgeViewController.frame = canvasView.bounds
        edgeViewController.sourceTool = from.tool
        edgeViewController.targetTool = to.tool
        to.edgeViewController = edgeViewController
        addChild(edgeViewController)
        canvasView.addSubview(edgeViewController.view, positioned: .below, relativeTo: to.view)
        bottomMostNonResizableObject = edgeViewController
    }
    
    func resetCanvasView(){
        
        resettingCanvasView = true
        
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
           addToolView(tool: node)
        }
        for plate in model.plates {
            if let treePlate = plate as? TreePlate {
                addTreePlateView(treePlate, topologyFrame: nil)
            } else {
                addLoopView(loop: plate)
            }
        }
        for edge in model.edges {
            addArrowView(connection: edge)
        }
        
        resettingCanvasView = false
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
    
    func insertPaletteItem(center: NSPoint, item: String) {
        addCanvasItem(center: center, data: item)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)
        }
    }
    
    func addCanvasItem(center: NSPoint, data: String ){
        guard let view = self.canvasView as? ModelCanvasView else { return }
        
        let variableData = data.split(separator: ":")
        let paletteItemType = variableData[0]
        switch paletteItemType {
        case PalettItem.plateType:
            guard let plateDimension = view.canvasLoopDimension else { return }
            addPlateToModel(frame: canvasItemFrame(center: center, dimension: plateDimension))
        case PalettItem.treePlateType:
            guard let height = view.canvasTreePlateHeight else { return }
            guard let width = view.canvasTreePlateWidth else { return }
            guard let nodeDimension = self.canvasView.canvasObjectDimension else { return }
            let plateFrame = canvasTreePlateFrame(center: center, width: width, height: height)
            let topologyFrame = canvasTreeTopologyFrame(plateFrame: plateFrame, dimension: nodeDimension)
            addTreePlateToModel(plateFrame: plateFrame, topologyFrame: topologyFrame)
        default:
            guard let nodeDimension = self.canvasView.canvasObjectDimension else { return }
            guard let variableName = getPalettVariableWithName(String(variableData[0])) else { return }
            guard let variableType = PaletteVariable.VariableType(rawValue: String(variableData[1])) else { return }
            addVariableToModel(frame: canvasItemFrame(center: center, dimension: nodeDimension), item: variableName, type: variableType, treePlate: nil)
        }
    }
    
    func canvasItemFrame(center: NSPoint, dimension: CGFloat) -> NSRect {
        return NSRect(x: center.x - dimension/2, y: center.y - dimension/2, width: dimension, height: dimension)
    }
    
    func canvasTreePlateFrame(center: NSPoint, width: CGFloat, height: CGFloat) -> NSRect {
       
        let distanceToLeftEdge = (center.x - width/2) - canvasView.frame.minX
        let distanceToRightEdge = canvasView.frame.maxX - (center.x + width/2)
        let distanceToTopEdge = canvasView.frame.maxY - (center.y + height/2)
        let distanceToBottomEdge = center.y - height/2
        
        var x = center.x
        var y = center.y
        
        if distanceToLeftEdge < 0 {
            x -= distanceToLeftEdge
        }
        if distanceToRightEdge < 0 {
            x += distanceToRightEdge
        }
        if distanceToTopEdge < 0 {
            y += distanceToTopEdge
        }
        if distanceToBottomEdge < 0 {
            y -= distanceToBottomEdge
        }

        return NSRect(x: x - width/2, y: y - height/2, width: width, height: height)
    }
    
    func canvasTreeTopologyFrame(plateFrame: NSRect, dimension: CGFloat) -> NSRect {
        let edge: CGFloat = plateFrame.minX - 80 > canvasView.frame.minX ? plateFrame.minX - 80 : plateFrame.maxX + 80
        let origin = NSPoint(x: edge, y: plateFrame.minY + plateFrame.height/2 - dimension/2)
        return NSRect(origin: origin, size: NSSize(width: dimension, height: dimension))
    }
    
    
}

extension ModelCanvasViewController: ModelVariableControllerDelegate {
   
    func getFunctionsForParameter(_ modelNode: ModelNode) -> [Distribution] {
        
        guard let functions = self.model?.functions else {
            return []
        }
        var resultList: [Distribution] = []
        for function in functions {
            if function.domain == modelNode.node.type {
                resultList.append(function)
            }
        }
       return resultList
    }
    
    
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

