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
   
    var color: CGColor
    var canvasFrame: NSRect
    
    var beginPoint: NSPoint {
        didSet{
            view.needsDisplay = true
        }
    }
  
    var endPoint: NSPoint {
        didSet {
            view.needsDisplay = true
        }
    }
    
    
    init(color: CGColor, canvasFrame: NSRect, endPoint: NSPoint, beginPoint: NSPoint){
        self.color = color
        self.canvasFrame = canvasFrame
        self.endPoint = endPoint
        self.beginPoint = beginPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func lineShapeLayer(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        let path = CGMutablePath()
        path.addLines(between: [beginPoint, endPoint])
        shapeLayer.path = path
        rootLayer.addSublayer(shapeLayer)
    }
    
    override func loadView() {
        view = NSView(frame: canvasFrame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootLayer.frame = self.view.frame
        self.view.wantsLayer = true
        self.view.layer = rootLayer
        lineShapeLayer()
    }
    

    
}
