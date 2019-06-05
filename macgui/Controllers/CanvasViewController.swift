//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController, NSWindowDelegate {
   

  
    weak var analysis: Analysis? {
        didSet{
            if let analysis = analysis {
                reset(analysis: analysis)
//                observers = [
//                    analysis.observe(\Analysis.name) {object, change in
//                        print("change in name of analysis")},
//                    analysis.observe(\Analysis.tools , options: [.old, .new]) {object, change in
//                        print("change in tools of analysis")}
//                ]
            }
        }
    }
    private var observers = [NSKeyValueObservation]()
 
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var transparentToolsView: TransparentToolsView!
    @IBOutlet weak var invitationLabel: NSTextField!
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    

    
    enum Appearance {
        static let maxStickerDimension: CGFloat = 50.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.delegate = self
//        add CanvasViewController to the window delegate, so that it can be part of the responder chain
        if let window = NSApp.windows.first{
            window.delegate = self
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeMagnification(_ :)),
                                               name: NSScrollView.didEndLiveMagnifyNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeCanvasObjectControllersSelection(notification:)),
                                               name: .didSelectCanvasObjectController,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteSelectedCanvasObjects(notification:)),
                                               name: .didSelectDeleteKey,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didConnectTools(notification:)),
                                               name: .didConnectTools,
                                               object: nil)
        

       
    }
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        canvasViewHeightConstraint.constant = scrollView.frame.size.height * 4
        canvasViewWidthConstraint.constant = scrollView.frame.size.width * 4
        
    }
    
    
    @IBAction func magnify(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 1:
            scrollView.magnification = 0.25
            sender.setTitle("25%")
        case 2:
            scrollView.magnification = 0.5
            sender.setTitle("50%")
        case 3:
            scrollView.magnification = 0.75
            sender.setTitle("75%")
        case 4:
            scrollView.magnification = 1.0
            sender.setTitle("100%")
        case 5:
            scrollView.magnification = 1.25
            sender.setTitle("125%")
        case 6:
            scrollView.magnification = 1.50
            sender.setTitle("150%")
        case 7:
            scrollView.magnification = 2.0
            sender.setTitle("200%")
        case 8:
            scrollView.magnification = 3.0
            sender.setTitle("300%")
        case 9:
            scrollView.magnification = 4.0
            sender.setTitle("400%")
        default:
            print("Switch case error!")
        }
    }
   
    @objc func didConnectTools(notification: Notification){
        let userInfo = notification.userInfo! as! [String: ConnectorItemView]
        if let color = userInfo["target"]?.arrowColor, let targetTool = userInfo["target"]?.delegate?.getTool(), let sourceTool = userInfo["source"]?.delegate?.getTool() {
            let arrowController = ArrowViewController(canvasFrame: canvasView.bounds, color: color, sourceTool: sourceTool as! Connectable, targetTool: targetTool as! Connectable)
            canvasView.addSubview(arrowController.view, positioned: .below, relativeTo: transparentToolsView)
        }
    }
    
    
    @objc func didChangeMagnification(_ notification: Notification){
        NotificationCenter.default.post(name: .didChangeMagnification,
                                        object: self,
                                        userInfo: ["magnification": Float(scrollView.magnification)])
    }
    
//    deselect all tool controllers except the one that sent the notification
    @objc func changeCanvasObjectControllersSelection(notification: Notification){
        for childController in children {
            if childController .isKind(of: CanvasObjectViewController.self) &&
                childController !== notification.object as! CanvasObjectViewController{
                    (childController as! CanvasObjectViewController).viewSelected = false
                }
            }
        }
    
    @objc func deleteSelectedCanvasObjects(notification: NSNotification){
        let userInfo = notification.userInfo! as! [String : NSPoint]
        for childController in children {
            if childController .isKind(of: CanvasToolViewController.self) &&
                (childController as! CanvasToolViewController).viewSelected == true {
                    removeToolView(toolViewController: childController as! CanvasToolViewController)
                    let size = childController.view.frame.size
                    NSAnimationEffect.poof.show(centeredAt: userInfo["point"]!, size: size)
            }
        }
    }

    
    func reset(analysis: Analysis){
        for subview in canvasView.subviews{
            if subview.identifier?.rawValue != "invitationLabel" {
                subview.removeFromSuperview()
            }
        }
        if analysis.isEmpty(){
            invitationLabel.isHidden = false
        } else {
            invitationLabel.isHidden = true
            for tool in analysis.tools {
                addToolView(tool: tool)
            }
        }
    }
    
    
    func addToolView(tool: ToolObject){
        let canvasToolViewController = CanvasToolViewController(tool: tool)
        addChild(canvasToolViewController)
        canvasView.addSubview(canvasToolViewController.view)
    }
    
    func addCanvasTool(image: NSImage, frame: NSRect, name: String){
        if let analysis = analysis {
            let newTool = initToolObjectWithName(name, image: image, frame: frame)
            analysis.tools.append(newTool)
            addToolView(tool: newTool)
        }
    }
    
    func removeToolView(toolViewController: CanvasToolViewController){
        if let analysis = analysis, let index = analysis.tools.index(of: toolViewController.tool) {
            toolViewController.view.removeFromSuperview()
            toolViewController.removeFromParent()
            analysis.tools.remove(at: index)
        }
    }
    
}

// MARK: - Methods for handling drag and drop from tool view to canvas
extension CanvasViewController: CanvasViewDelegate {
    
    func selectContentView(width: CGFloat) {
        NSColor.lightGray.set()
        let path = NSBezierPath(rect: scrollView.documentVisibleRect)
        path.lineWidth = width
        path.stroke()
    }
    
    func processImageURLs(_ urls: [URL], center: NSPoint) {
        for (_,url) in urls.enumerated() {
            if let image = NSImage(contentsOf: url){
                let name = url.lastPathComponent
                processImage(image, center: center, name: name)
            }
        }
    }
    
    func processImage(_ image: NSImage, center: NSPoint, name: String) {
        invitationLabel.isHidden = true
        let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)
        let frame = NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height)
        addCanvasTool(image: image, frame: frame, name: name)
    }
    
    func mouseDownOnCanvasView() {
        for childController in children {
            if childController.isKind(of: CanvasToolViewController.self){
                if (childController as! CanvasToolViewController).viewSelected {
                    (childController as! CanvasToolViewController).viewSelected = false
                }
            }
        }
    }
    
}





