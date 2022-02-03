//
//  GenericCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/5/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class GenericCanvasViewController: NSViewController, NSWindowDelegate {
    
//    MARK: -- Loop/Plate Handling
    
    weak var bottomMostNonResizableObject: NSViewController?
    weak var topMostLoop: ResizableCanvasObjectViewController?
    let loopIndices: [String] = ["i","j","k","l","m","n","u","v","w","x","y","z", "a","b","c","d","e","f","g","h","o","p","q","r","s","t"]
    
    var activeLoopIndices: [Int] {
        return []
    }
    
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

// MARK: - IB Outlets
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var canvasView: GenericCanvasView!
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    
    

// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        canvasView.delegate = self
        
        scrollView.magnification = 1.5
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeMagnification(_ :)),
                                               name: NSScrollView.didEndLiveMagnifyNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(changeCanvasObjectControllersSelection(notification:)),
                                                      name: .didSelectCanvasObjectController,
                                                      object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAppearance), name: UserDefaults.didChangeNotification, object: nil)
    }
    @objc func updateAppearance(){
           canvasView.needsDisplay = true
       }
       
    
    override func viewDidAppear() {
         if let window = view.window  {
                   window.delegate = self
               }

    }
   
    
// MARK: Selection of Objects on Canvas
    
    //    deselect all child controllers except the one that sent the notification
    @objc func changeCanvasObjectControllersSelection(notification: Notification){
        let sender = notification.object as! CanvasObjectViewController
        guard sender.parent == self
            else { return }
        for childController in children {
            if childController .isKind(of: CanvasObjectViewController.self) &&
                childController !== sender {
                    (childController as! CanvasObjectViewController).viewSelected = false
                }
            }
        }
    
    
// MARK: - Locating Objects on Canvas
    
    func findArrowControllersByTool(tool: ToolObject) -> [ArrowViewController] {
        var arrowControllers: [ArrowViewController] = []
        for child in children {
            if child.isKind(of: ArrowViewController.self){
                if (child as! ArrowViewController).ownedBy(tool: tool) {
                    arrowControllers.append(child as! ArrowViewController)
                }
            }
        }
        return arrowControllers
    }
    
    func findVCByTool(_ tool: ToolObject) -> CanvasObjectViewController? {
        for vc in self.children {
            if let canvasObjectVC = vc as? CanvasObjectViewController{
                let node = canvasObjectVC.tool
                if node === tool {
                    return canvasObjectVC
                }
            }
        }
        return nil
    }
    
//    MARK: -- Removing Objects from Canvas
   
    func removeCanvasObjectView(canvasObjectViewController: CanvasObjectViewController) {
        
        if let arrowViewController = canvasObjectViewController as? ArrowViewController {
            removeConnection(arrowViewController: arrowViewController)
        } else if let resizableViewController = canvasObjectViewController as? ResizableCanvasObjectViewController {
            removeResizable(viewController: resizableViewController)
        } else {
            removeConnectable(viewController: canvasObjectViewController)
        }
    }
    
    func removeConnection(arrowViewController: ArrowViewController){
        arrowViewController.willDeleteView()
        arrowViewController.view.removeFromSuperview()
        arrowViewController.removeFromParent()
    }
    
    func removeConnectable(viewController: CanvasObjectViewController){
        
        guard let connectable = viewController.tool as? Connectable else { return }
        
        if bottomMostNonResizableObject == viewController {
            if let toolVC = self.children.filter({ $0.isKind(of: CanvasObjectViewController.self)}).first as? CanvasObjectViewController {
                bottomMostNonResizableObject = toolVC
            } else { bottomMostNonResizableObject = nil }
        }
        
        let arrowViewControllers = findArrowControllersByTool(tool: connectable)
        for arrowViewController in arrowViewControllers {
            removeCanvasObjectView(canvasObjectViewController: arrowViewController)
        }
        
        if let outerLoopVC = viewController.outerLoopViewController, let loop = outerLoopVC.tool as? Loop {
            loop.removeEmbeddedNode(connectable)
        }
        
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func removeResizable(viewController: ResizableCanvasObjectViewController) {
        guard let loop = viewController.tool as? Loop else { return }
        
        if topMostLoop == viewController {
            if let loopVC = self.children.filter({ $0.isKind(of: ResizableCanvasObjectViewController.self)}).first as? ResizableCanvasObjectViewController {
                topMostLoop = loopVC
            } else {  topMostLoop = nil }
        }
        loop.embeddedNodes.forEach { findVCByTool($0)?.checkForLoopInclusion()}
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        
    }
    
    func deleteSelectedCanvasObjects() {
        for childController in children {
            if let canvasObject = childController as? CanvasObjectViewController, canvasObject.viewSelected == true {
                removeCanvasObjectView(canvasObjectViewController: canvasObject)
            }
        }
    }
    
    @objc func deleteSelectedCanvasObjects(notification: NSNotification){
        
        var numConnectionsToDelete = 0
        for childController in children {
            if let childController = childController as? ArrowViewController,
               childController.viewSelected == true {
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
                deleteSelectedCanvasObjects()
            default: break
            }
        }  else { deleteSelectedCanvasObjects() }
    }
    
//    MARK: -- Adding objects to Canvas
    
    func addLoopView(loop: Loop) {
        guard let canvasLoopViewController = resizableObjectViewController() else { return }
        canvasLoopViewController.tool = loop
        addChild(canvasLoopViewController)
        if let bottomMostNode = self.bottomMostNonResizableObject {
            canvasView.addSubview(canvasLoopViewController.view, positioned: .below, relativeTo: bottomMostNode.view)
        } else {
            canvasView.addSubview(canvasLoopViewController.view)
        }
        topMostLoop = canvasLoopViewController
        canvasLoopViewController.checkForLoopInclusion()
    }
    
    func addArrowView(arrowController: ArrowViewController){
        addChild(arrowController)
        if let topMostLoop = topMostLoop {
            canvasView.addSubview(arrowController.view, positioned: .above, relativeTo: topMostLoop.view)
        } else {
            canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: bottomMostNonResizableObject?.view)
        }
        bottomMostNonResizableObject = arrowController
    }
    
    
    func addToolView(tool: ToolObject) {
        guard let viewController = toolViewController() else { return }
        viewController.tool = tool
        addChild(viewController)
        if let bottomMostNode = self.bottomMostNonResizableObject {
            canvasView.addSubview(viewController.view, positioned: .above, relativeTo: bottomMostNode.view)
        } else {
            bottomMostNonResizableObject = viewController
            if let topMostLoop = topMostLoop {
                canvasView.addSubview(viewController.view, positioned: .above, relativeTo: topMostLoop.view)
            } else {
                canvasView.addSubview(viewController.view)
            }
        }
        
        viewController.checkForLoopInclusion()
    }
    
    func toolViewController() -> CanvasObjectViewController? {
        return nil
    }
    
    func resizableObjectViewController() -> ResizableCanvasObjectViewController? {
        return nil
    }
 
    // MARK: -- Key Events
    
    override func keyDown(with event: NSEvent) {
          if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
              NotificationCenter.default.post(name: .didSelectDeleteKey, object: self)
          }
      }

    
    // MARK: -- Magnification
    
    @IBAction func magnify(_ sender: NSPopUpButton) {
           switch sender.indexOfSelectedItem {
           case 1:
               scrollView.magnification = 0.375
               sender.setTitle("25%")
           case 2:
               scrollView.magnification = 0.75
               sender.setTitle("50%")
           case 3:
               scrollView.magnification = 1.125
               sender.setTitle("75%")
           case 4:
               scrollView.magnification = 1.5
               sender.setTitle("100%")
           case 5:
               scrollView.magnification = 1.875
               sender.setTitle("125%")
           case 6:
               scrollView.magnification = 2.25
               sender.setTitle("150%")
           case 7:
               scrollView.magnification = 3.0
               sender.setTitle("200%")
           case 8:
               scrollView.magnification = 4.5
               sender.setTitle("300%")
           case 9:
               scrollView.magnification = 6.0
               sender.setTitle("400%")
           default:
               print("Switch case error!")
           }
       }
    
    @objc func didChangeMagnification(_ notification: Notification){
              NotificationCenter.default.post(name: .didChangeMagnification,
                                              object: self,
                                              userInfo: ["magnification": Float(scrollView.magnification)])
          }
    
}

// MARK: - GenericCanvasViewDelegate

extension GenericCanvasViewController: GenericCanvasViewDelegate {
   
    func isMouseDownOnArrowView(event: NSEvent, point: NSPoint) -> Bool {
        for childController in children {
            if childController.isKind(of: ArrowViewController.self){
                let arrowViewController = childController as! ArrowViewController
                let arrowView = ((arrowViewController.view) as! ArrowView)
                if arrowView.clickAreaContains(point: point) {
                    arrowView.mouseDown(with: event)
                    return true
                }
            }
        }
        return false
    }
   
    func selectContentView(width: CGFloat) {
        NSColor.lightGray.set()
        let path = NSBezierPath(rect: scrollView.documentVisibleRect)
        path.lineWidth = width
        path.stroke()
    }

     func mouseDownOnCanvasView() {
           for childController in children {
               if childController.isKind(of: CanvasObjectViewController.self){
                   if (childController as! CanvasObjectViewController).viewSelected {
                       (childController as! CanvasObjectViewController).viewSelected = false
                   }
               }
           }
       }
 
    func selectBySelectionBox(selectedArea: NSRect) {
        for childController in children {
            if let canvasObject = childController as? CanvasObjectViewController, !canvasObject.viewSelected {
                if canvasObject.view.frame.intersects(selectedArea) {
                    canvasObject.isPartOfMultipleSelection = true
                    canvasObject.viewSelected = true
                }
            }
        }
    }
    
    
    
    
}

extension GenericCanvasViewController: LoopControllerDelegate {
    
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
    
