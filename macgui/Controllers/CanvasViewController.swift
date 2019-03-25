//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {
    
   
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
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        canvasViewHeightConstraint.constant = scrollView.frame.size.height * 4
        canvasViewWidthConstraint.constant = scrollView.frame.size.width * 4
       
    }
    
    @IBAction func zoom(sender: NSPopUpButton){
        switch sender.indexOfSelectedItem {
        case 0:
            scrollView.magnification = 0.25
        case 1:
            scrollView.magnification = 0.5
        case 2:
            scrollView.magnification = 0.75
        case 3:
            scrollView.magnification = 1.0
        case 4:
            scrollView.magnification = 1.25
        case 5:
            scrollView.magnification = 1.50
        case 6:
            scrollView.magnification = 2.0
        case 7:
            scrollView.magnification = 3.0
        case 8:
            scrollView.magnification = 4.0
        case 10:
            scrollView.magnification = 0.25
        default:
            print("Switch case error!")
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
        canvasView.addSubview(canvasToolViewController.view)
    }
    
    func addCanvasTool(image: NSImage, frame: NSRect){
        let newTool = ToolObject(image: image, frameOnCanvas: frame)
        analysis?.tools.append(newTool)
        addToolView(tool: newTool)
    }

}

// MARK: - Methods for handling drag and drop from tool view to canvas
extension CanvasViewController: CanvasViewDelegate{
    
    func processImageURLs(_ urls: [URL], center: NSPoint) {
        for (_,url) in urls.enumerated() {
            if let image = NSImage(contentsOf: url) {
                processImage(image, center: center)
            }
        }
    }
    
    func processImage(_ image: NSImage, center: NSPoint) {
        invitationLabel.isHidden = true
        let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)
        let frame = NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height)
        addCanvasTool(image: image, frame: frame)
    }
    
    
    
}
