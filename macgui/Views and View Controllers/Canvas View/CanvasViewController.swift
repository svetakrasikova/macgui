//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: GenericCanvasViewController {
    
    
    override var activeLoopIndices: [Int] {
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
    
    @objc override func deleteSelectedCanvasObjects(notification: NSNotification){
        guard self.view.window?.isMainWindow ?? true else { return  }
        super.deleteSelectedCanvasObjects(notification: notification)
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
    override func toolViewController() -> CanvasObjectViewController? {
        return NSStoryboard.loadVC(.canvasTool) as? CanvasToolViewController
    }
    
    override func resizableObjectViewController() -> ResizableCanvasObjectViewController? {
        return CanvasLoopViewController()
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
    
    
    override func removeConnectable(viewController: CanvasObjectViewController){
        
        super.removeConnectable(viewController: viewController)
        
        guard let tool = viewController.tool as? Connectable else { return }
        
        if let analysis = analysis, let index = analysis.tools.firstIndex(of: tool) {
            analysis.tools.remove(at: index)
        }
    }
    
    override func removeConnection(arrowViewController: ArrowViewController){
        super.removeConnection(arrowViewController: arrowViewController)
        if let analysis = analysis, let connection = arrowViewController.connection, let index = analysis.arrows.firstIndex(of: connection) {
            analysis.arrows.remove(at: index)
        }
    }
    
    override func removeResizable(viewController: ResizableCanvasObjectViewController) {
        guard let loop = viewController.tool as? Loop else { return }
        if let analysis = analysis, let index = analysis.tools.firstIndex(of: loop) {
            analysis.tools.remove(at: index)
        }
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






