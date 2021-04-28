//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: GenericCanvasViewController {
    
    
    let loopIndices: [String] = ["a","b","c","d","e", "f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var activeLoopIndices: [Int] {
        var indexTable = [Int]()
        var activeIndicesList = [String]()
       
        if let analysis = analysis {
            for tool in analysis.tools {
                if let loop = tool as? Loop {
                    activeIndicesList.append(loop.index)
                }
            }
            
            for index in activeIndicesList {
                if let i = loopIndices.firstIndex(of: index) {
                    indexTable.append(i)
                }
            }
        }
        return indexTable
    }
    

    weak var analysis: Analysis? {
        
        didSet{
            reset()
        }
    }
    
    
// MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteSelectedCanvasObjects(notification:)),
                                               name: .didSelectDeleteKey,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didConnectTools(notification:)),
                                               name: .didConnectTools,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: .didUpdateAnalysis, object: nil)
    }
    
//   MARK: -- Manage Loop Indices

    func generateActiveIndex() -> String? {
        var index: String?
        for i in 0..<loopIndices.count {
            if let _ = activeLoopIndices.firstIndex(of: i) {
                continue
            } else {
                index = loopIndices[i]
                break
            }
        }
        return index
    }

    
    //   MARK: - Connect Tools on Canvas
    
    @objc func didConnectTools(notification: Notification){
        guard let userInfo = notification.userInfo as? [String: ConnectorItemArrowView]
        else {return}
        if userInfo["target"]?.window == self.view.window, let color = userInfo["target"]?.connectionColor, let targetTool = userInfo["target"]?.concreteDelegate?.getTool() as? Connectable, let sourceTool = userInfo["source"]?.concreteDelegate?.getTool() as? Connectable {
            let toConnector = userInfo["target"]?.concreteDelegate?.getConnector() as! Connector
            let connection = Connection(to: targetTool, from: sourceTool, type: toConnector.type)
            let arrowController = setUpConnection(frame: canvasView.bounds, color: color, sourceTool: sourceTool, targetTool: targetTool, connection: connection)
            analysis?.arrows.append(connection)
            addChild(arrowController)
            canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
            
            let userInfo  = ["sourceTool" : sourceTool, "targetTool" : targetTool]
            NotificationCenter.default.post(name: .didAddNewArrow, object: self, userInfo: userInfo)
            
            
        }
    }
    
    func runNoDataAlert(toolType: String){
        let alert = NSAlert()
        alert.messageText = "No Data on \(toolType)"
        alert.informativeText = "To establish a data connection between two tools, the source tool needs to have data."
        alert.runModal()
    }
    
    func runNoAlignedDataAlert(toolType: String){
        let alert = NSAlert()
        alert.messageText = "No aligned data on \(toolType)."
        alert.informativeText = "To establish an aligned data connection between two tools, the source tool needs to have aligned data."
        alert.runModal()
    }
    
    func runNoUnalignedDataAlert(toolType: String){
        let alert = NSAlert()
        alert.messageText = "No unaligned data on \(toolType)."
        alert.informativeText = "To establish an unaligned data connection between two tools, the source tool needs to have unaligned data."
        alert.runModal()
    }

    
    func setUpConnection(frame: NSRect, color: NSColor, sourceTool: Connectable, targetTool: Connectable, connection: Connection) -> ArrowViewController {
        let arrowController = ArrowViewController()
        arrowController.frame = frame
        arrowController.color = color
        arrowController.sourceTool = sourceTool
        arrowController.targetTool = targetTool
        arrowController.connection = connection
        return arrowController
    }
    
    func addArrowView(connection: Connection){
        let color = Connector.getColor(type: connection.type)
        let arrowController = setUpConnection(frame: canvasView.bounds, color: color, sourceTool: connection.from, targetTool: connection.to, connection: connection)
        addChild(arrowController)
        canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
        
    }
    
// MARK: - Add and Delete Canvas Objects
    
    @objc func deleteSelectedCanvasObjects(notification: NSNotification){
       
        guard self.view.window?.isMainWindow ?? true else { return  }
        
        var numConnectionsToDelete = 0
        
        for childController in children {
            if childController .isKind(of: ArrowViewController.self) &&
                (childController as! CanvasObjectViewController).viewSelected == true {
                numConnectionsToDelete = numConnectionsToDelete + 1
            }
        }
        if numConnectionsToDelete > 0 {
            let alert = NSAlert()
            if numConnectionsToDelete > 1 {
                alert.messageText = "Warning: Removing connections between tools"
                alert.informativeText = "Removing connections can lead to loss of information in downstream tools"
            } else {
                alert.messageText = "Warning: Removing a connection between tools"
                alert.informativeText = "Removing a connection can lead to loss of information in downstream tools"
            }
            
            alert.addButton(withTitle: "Delete")
            alert.addButton(withTitle: "Cancel")
            
            let result = alert.runModal()
            switch result {
            case NSApplication.ModalResponse.alertFirstButtonReturn:
                for childController in children {
                    if childController .isKind(of: CanvasToolViewController.self) &&
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

            default: break
            }
        }
        else {
            for childController in children {
                if childController .isKind(of: CanvasToolViewController.self) &&
                    (childController as! CanvasObjectViewController).viewSelected == true {
                    removeCanvasObjectView(canvasObjectViewController: childController as! CanvasObjectViewController)
                }
            }
            for childController in children {
                if childController .isKind(of: CanvasLoopViewController.self) &&
                    (childController as! CanvasObjectViewController).viewSelected == true {
                    removeCanvasObjectView(canvasObjectViewController: childController as! CanvasObjectViewController)
                }
                
            }
        }
            reset()

    }

    
    @objc func reset(){
        guard let analysis = self.analysis else {
            return
        }
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
        
        for tool in analysis.tools {
            if let loop = tool as? Loop {
                addLoopView(loop: loop)
            } else {
                addToolView(tool: tool)
            }
        }
        for connection in analysis.arrows {
            addArrowView(connection: connection)
        }
        
    }
    
   
    
    func addToolView(tool: ToolObject){
        guard let canvasToolViewController = NSStoryboard.loadVC(.canvasTool) as? CanvasToolViewController else {return}
        canvasToolViewController.tool = tool
        addChild(canvasToolViewController)
        if bottomMostNode == nil {
            bottomMostNode = canvasToolViewController
        }
        if let topMostLoop = topMostLoop {
            canvasView.addSubview(canvasToolViewController.view, positioned: .above, relativeTo: topMostLoop.view)
        } else {
            canvasView.addSubview(canvasToolViewController.view)
        }
        canvasToolViewController.checkForLoopInclusion()
    }
    
    func addLoopView(loop: Loop) {
        let canvasLoopViewController = CanvasLoopViewController()
        canvasLoopViewController.tool = loop
        addChild(canvasLoopViewController)
        if let bottomMostNode = self.bottomMostNode {
            canvasView.addSubview(canvasLoopViewController.view, positioned: .below, relativeTo: bottomMostNode.view)
        } else {
            canvasView.addSubview(canvasLoopViewController.view)
        }
        topMostLoop = canvasLoopViewController
        canvasLoopViewController.checkForLoopInclusion()
    }
    
    func addCanvasTool(center: NSPoint, name: String){
        guard let analysis = analysis else { return }
        switch name {
        case ToolType.loop.rawValue:
            guard let loopDimension = self.canvasView.canvasLoopDimension else { return }
            let newLoopIndex = generateActiveIndex()
            if let newLoop = createToolFromCenter(center, dimension: loopDimension, name: name, index: newLoopIndex) as? Loop {
                addLoopView(loop: newLoop)
                analysis.tools.append(newLoop)
            }
            
        default:
            guard let toolDimension = self.canvasView.canvasObjectDimension else { return }
            if let newTool = createToolFromCenter(center, dimension: toolDimension, name: name, index: nil) {
                addToolView(tool: newTool)
                analysis.tools.append(newTool)
            }
        }
        
    }
    
    func createToolFromCenter(_ center: NSPoint, dimension: CGFloat, name: String, index: String?) -> ToolObject? {
        guard let analysis = analysis else { return nil }
        let size = NSSize(width: dimension, height: dimension)
        let origin = NSPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        let adjustedOrigin = origin.adjustOriginToFitContentSize(content: self.canvasView.frame.size, dimension: dimension)
        let frame = NSRect(origin: adjustedOrigin, size: size)
        return initToolObjectWithName(name, frame: frame, analysis: analysis, index: index)
    }
    
    func removeToolFromAnalysis(toolViewController: CanvasToolViewController){
        
        guard let tool = toolViewController.tool as? Connectable else { return }
        
        if bottomMostNode == toolViewController {
            if let toolVC = self.children.filter({ $0.isKind(of: CanvasToolViewController.self)}).first as? CanvasToolViewController {
                bottomMostNode = toolVC
            } else { bottomMostNode = nil }
        }
        
        if let analysis = analysis, let index = analysis.tools.firstIndex(of: tool) {
            let arrowViewControllers = findArrowControllersByTool(tool: toolViewController.tool!)
            for arrowViewController in arrowViewControllers {
                removeCanvasObjectView(canvasObjectViewController: arrowViewController)
            }
            
            if let outerLoopVC = toolViewController.outerLoopViewController, let loop = outerLoopVC.tool as? Loop {
                loop.removeEmbeddedNode(tool)
            }
            analysis.tools.remove(at: index)
            
        }
    }
    
    func removeConnectionFromAnalysis(arrowViewController: ArrowViewController){
        if let analysis = analysis, let index = analysis.arrows.firstIndex(of: arrowViewController.connection!) {
            arrowViewController.willDeleteView()
            analysis.arrows.remove(at: index)
        }
    }
    
    func removeLoopFromAnalysis(loopViewController: CanvasLoopViewController) {
        guard let loop = loopViewController.tool as? Loop else { return }
        if topMostLoop == loopViewController {
            if let loopVC = self.children.filter({ $0.isKind(of: CanvasLoopViewController.self)}).first as? CanvasLoopViewController {
                topMostLoop = loopVC
            } else {  topMostLoop = nil }
        }
        if let analysis = analysis, let index = analysis.tools.firstIndex(of: loop) {
            loop.embeddedNodes.forEach { findVCByTool($0)?.checkForLoopInclusion()}
            analysis.tools.remove(at: index)
        }
    }
    
    func removeCanvasObjectView(canvasObjectViewController: CanvasObjectViewController) {
        if canvasObjectViewController.isKind(of: ArrowViewController.self){
            removeConnectionFromAnalysis(arrowViewController: canvasObjectViewController as! ArrowViewController)
        }
        else {
            if canvasObjectViewController.isKind(of: CanvasToolViewController.self){
                removeToolFromAnalysis(toolViewController: canvasObjectViewController as! CanvasToolViewController)
            } else {
                if canvasObjectViewController.isKind(of: CanvasLoopViewController.self) {
                    removeLoopFromAnalysis(loopViewController: canvasObjectViewController as! CanvasLoopViewController)
                }
            }
        }
        canvasObjectViewController.view.removeFromSuperview()
        canvasObjectViewController.removeFromParent()
    }
    
}


// MARK: - CanvasViewDelegate
extension CanvasViewController: CanvasViewDelegate {
    
    
    func processImage(center: NSPoint, name: String) {
        addCanvasTool(center: center, name: name)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)
        }
    }
    
}

extension CanvasViewController: LoopControllerDelegate {
    
    func activeIndices() -> [String] {
        var activeIndices = [String]()
        for i in activeLoopIndices {
            activeIndices.append(loopIndices[i])
        }
        return activeIndices
    }
    
    func allIndices() -> [String] {
        return loopIndices
    }
}






