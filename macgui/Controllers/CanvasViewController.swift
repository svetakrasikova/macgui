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
            }
        }
    }
    
 
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var canvasView: CanvasView!
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
    
    @objc func didChangeMagnification(_ notification: Notification){
        NotificationCenter.default.post(name: .didChangeMagnification,
                                        object: self,
                                        userInfo: ["magnification": Float(scrollView.magnification)])
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
        canvasView.addSubview(canvasToolViewController.view)
    }
    
    func addCanvasTool(image: NSImage, frame: NSRect, name: String){
        let newTool = initToolObjectWithName(name, image: image, frame: frame)
        analysis?.tools.append(newTool)
        addToolView(tool: newTool)
    }

}

// MARK: - Methods for handling drag and drop from tool view to canvas
extension CanvasViewController: CanvasViewDelegate{
    
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
    
    
}

// MARK: - Initialzing tools by type
extension CanvasViewController{
    func initToolObjectWithName(_ name: String, image: NSImage, frame: NSRect) -> ToolObject {
        let index = name.firstIndex(of: ".") ?? name.endIndex
        let toolType = String(name[..<index])
        switch toolType {
        case "bootstrap":
            return Bootstrap(image: image, frameOnCanvas: frame)
        default:
            return ToolObject(image: image, frameOnCanvas: frame)
            
        }
    }
}
