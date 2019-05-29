//
//  ArrowViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowViewController: NSViewController {
    
    private let rootLayer = CALayer()
    var color: CGColor?
    var canvasFrame: NSRect?
    var beginPoint: NSPoint? {
        didSet{
            view.needsDisplay = true
        }
    }
    var endPoint: NSPoint? {
        didSet {
            view.needsDisplay = true
        }
    }
    
    func lineShapeLayer(){
        if let beginPoint = beginPoint, let endPoint = endPoint, let color = color {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color
            shapeLayer.lineWidth = 2
            let path = CGMutablePath()
            path.addLines(between: [beginPoint, endPoint])
            shapeLayer.path = path
            rootLayer.addSublayer(shapeLayer)
        }
    }
    
    override func loadView() {
        if let frame = self.canvasFrame {
            view = NSView(frame: frame)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootLayer.frame = self.view.frame
        self.view.wantsLayer = true
        self.view.layer = rootLayer
        lineShapeLayer()
    }
    

    
}
