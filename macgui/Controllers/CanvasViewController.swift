//
//  DestinationViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {
    
    weak var analysis: Analysis?
    
    @IBOutlet weak var invitationLabel: NSTextField!
    
    
    enum Appearance {
        static let maxStickerDimension: CGFloat = 50.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! CanvasView).delegate = self
        reset()
    }
    
    func reset(){
//        rebuild the view hierachy
    }
    
}


// MARK: - DestinationViewDelegate methods for handling drop on the canvas
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
        let canvasTool = CanvasTool(image: image, frame: frame)
        view.addSubview(canvasTool.view)
        
    }
}
