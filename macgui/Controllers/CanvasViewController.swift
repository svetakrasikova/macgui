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
    
    @IBOutlet weak var invitationLabel: NSTextField!
    
    
    enum Appearance {
        static let maxStickerDimension: CGFloat = 50.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! CanvasView).delegate = self
    }
    
    func reset(analysis: Analysis){
        for subview in view.subviews{
            if subview.identifier?.rawValue != "invitationLabel" {
                subview.removeFromSuperview()
            }
        }
        if analysis.isEmpty(){
            invitationLabel.isHidden = false
        } else {
            invitationLabel.isHidden = true
            for tool in analysis.tools {
                addCanvasToolView(image: tool.image, frame: tool.frameOnCanvas)
            }
        }
    }
    
    func addCanvasToolView(image: NSImage, frame: NSRect){
        let canvasTool = CanvasToolViewController(image: image, frame: frame)
        view.addSubview(canvasTool.view)
    }
    
    func addCanvasTool(image: NSImage, frame: NSRect){
        addCanvasToolView(image: image, frame: frame)
        let newTool = ToolObject(image: image, frameOnCanvas: frame)
        analysis?.tools.append(newTool)
    }

}

// MARK: - DestinationViewDelegate methods for handling drag and drop from tool view to canvas
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
        addCanvasToolView(image: image, frame: frame)
        addCanvasTool(image: image, frame: frame)
    }
    
    
    
}
