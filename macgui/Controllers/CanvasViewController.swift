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
        let canvasTool = CanvasToolController(image: image, frame: frame)
        view.addSubview(canvasTool.view)
    }
    
    func addCanvasTool(image: NSImage, frame: NSRect, source: NSPoint){
        addCanvasToolView(image: image, frame: frame)
        let newTool = ToolObject(image: image, frameOnCanvas: frame)
        analysis?.tools.append(newTool)
    }
    
    func moveCanvasTool(image: NSImage, frame: NSRect, source: NSPoint){
        if let analysis = analysis {
            for tool in analysis.tools {
                if NSPointInRect(source, tool.frameOnCanvas){
                    tool.frameOnCanvas = frame
                    addCanvasToolView(image: image, frame: frame)
                    for subview in view.subviews {
                        if NSPointInRect(source, subview.frame){
                            subview.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }

}

// MARK: - DestinationViewDelegate methods for handling drop on the canvas
extension CanvasViewController: CanvasViewDelegate{
    
    func processImageURLs(_ urls: [URL], center: NSPoint, source: NSPoint) {
        for (_,url) in urls.enumerated() {
            if let image = NSImage(contentsOf: url) {
                processImage(image, center: center, source: source, action: addCanvasTool)
            }
        }
    }
    
    func processImageTiff(_ image: NSImage, center: NSPoint, source: NSPoint) {
        processImage(image, center: center, source: source, action: moveCanvasTool)
    }
    
    
    func processImage(_ image: NSImage, center: NSPoint, source: NSPoint, action: ((NSImage, NSRect, NSPoint) -> Void)) {
        invitationLabel.isHidden = true
        let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)
        let frame = NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height)
        action(image, frame, source)
    }
    
    
    
}
