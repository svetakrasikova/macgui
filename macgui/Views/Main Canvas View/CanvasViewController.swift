//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: GenericCanvasViewController {

    weak var analysis: Analysis? {
        
        didSet{
            if let analysis = analysis {
                reset(analysis: analysis)
            }
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
    }
    
   
//   MARK: - Connect Tools on Canvas
    
    @objc func didConnectTools(notification: Notification){
        guard let userInfo = notification.userInfo as? [String: ConnectorItemArrowView]
            else {return}
        if userInfo["target"]?.window == self.view.window, let color = userInfo["target"]?.connectionColor, let targetTool = userInfo["target"]?.concreteDelegate?.getTool(), let sourceTool = userInfo["source"]?.concreteDelegate?.getTool() as? Connectable {
            let toConnector = userInfo["target"]?.concreteDelegate?.getConnector() as! Connector
            toConnector.setNeighbor(neighbor: sourceTool)
            let fromConnector = userInfo["source"]?.concreteDelegate?.getConnector() as! Connector
            fromConnector.setNeighbor(neighbor: targetTool as! Connectable)
            do {
                let connection = try Connection(to: toConnector, from: fromConnector)
                let arrowController = setUpConnection(frame: canvasView.bounds, color: color, sourceTool: sourceTool, targetTool: targetTool as! Connectable, connection: connection)
                analysis?.arrows.append(connection)
                addChild(arrowController)
                canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
              
                let userInfo  = ["sourceTool" : sourceTool, "targetTool" : targetTool]
                NotificationCenter.default.post(name: .didAddNewArrow, object: self, userInfo: userInfo)
            } catch ConnectionError.noData {
                runNoDataAlert(toolType: sourceTool.descriptiveName)
            } catch ConnectionError.noAlignedData {
                runNoAlignedDataAlert(toolType: sourceTool.descriptiveName)
            } catch  {
                print("Unexpected error: \(error).")
            }
            
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
           let color = connection.from.getColor()
           if let sourceTool = connection.to.neighbor, let targetTool = connection.from.neighbor {
               let arrowController = setUpConnection(frame: canvasView.bounds, color: color, sourceTool: sourceTool, targetTool: targetTool, connection: connection)
               addChild(arrowController)
               canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
           }
       }
    
// MARK: - Add and Delete Canvas Objects
    
    @objc func deleteSelectedCanvasObjects(notification: NSNotification){
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
        }
            reset(analysis: analysis!)

    }

    
    func reset(analysis: Analysis){
        
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
            addToolView(tool: tool)
        }
        for connection in analysis.arrows {
            addArrowView(connection: connection)
        }
        
    }
    
   
    
    func addToolView(tool: ToolObject){
        guard let canvasToolViewController = NSStoryboard.loadVC(.canvasTool) as? CanvasToolViewController else {return}
        canvasToolViewController.tool = tool
        addChild(canvasToolViewController)
        canvasView.addSubview(canvasToolViewController.view)
    }
    
    func addCanvasTool(frame: NSRect, name: String){
        if let analysis = analysis {
            let newTool = initToolObjectWithName(name, frame: frame, analysis: analysis)
            analysis.tools.append(newTool)
            addToolView(tool: newTool)
        }
    }
    
    
    func removeToolFromAnalysis(toolViewController: CanvasToolViewController){
        if let analysis = analysis, let index = analysis.tools.firstIndex(of: toolViewController.tool!) {
            let arrowViewControllers = findArrowControllersByTool(tool: toolViewController.tool!)
            for arrowViewController in arrowViewControllers {
                removeCanvasObjectView(canvasObjectViewController: arrowViewController)
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
    
    func removeCanvasObjectView(canvasObjectViewController: CanvasObjectViewController) {
        if canvasObjectViewController.isKind(of: ArrowViewController.self){
            removeConnectionFromAnalysis(arrowViewController: canvasObjectViewController as! ArrowViewController)
        } else {
            if canvasObjectViewController.isKind(of: CanvasToolViewController.self){
                removeToolFromAnalysis(toolViewController: canvasObjectViewController as! CanvasToolViewController)
            }
        }
        canvasObjectViewController.view.removeFromSuperview()
        canvasObjectViewController.removeFromParent()
    }
    
}

// MARK: - CanvasViewDelegate
extension CanvasViewController: CanvasViewDelegate {
    
    
    func processImage(center: NSPoint, name: String) {
        guard let toolDimension = self.canvasView.canvasObjectDimension
            else {
                return
        }
        let size = NSSize(width: toolDimension, height: toolDimension)
        let frame = NSRect(x: center.x - size.width/2, y: center.y - size.height/2, width: size.width, height: size.height)
        addCanvasTool(frame: frame, name: name)
        if let window = self.view.window {
            window.makeFirstResponder(canvasView)

        }
        
    }
    
}





