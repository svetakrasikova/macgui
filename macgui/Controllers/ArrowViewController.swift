//
//  ArrowViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowViewController: CanvasObjectViewController, ArrowViewDelegate {
    
    private let rootLayer = CALayer()
    private var observers = [NSKeyValueObservation]()
    
    var targetTool: Connectable
    
    var sourceTool: Connectable
    
    
    var canvasFrame: NSRect
    var color: CGColor
    
    var endPoint: NSPoint {
        get{
           return targetTool.frameOnCanvas.center()
        }
    }
    
    var beginPoint: NSPoint {
        get {
           return sourceTool.frameOnCanvas.center()
        }
    }
    
    
    init(canvasFrame: NSRect, color: CGColor, sourceTool: Connectable, targetTool: Connectable){
        self.targetTool = targetTool
        self.sourceTool = sourceTool
        self.color = color
        self.canvasFrame = canvasFrame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawArrowIn(layer: CAShapeLayer){
        layer.strokeColor = color
        layer.lineWidth = 2
        let path = CGMutablePath()
        path.addLines(between: [beginPoint, endPoint])
        layer.path = path
        view.layer?.addSublayer(layer)
    }
    
    override func loadView() {
        view = ArrowView(frame: canvasFrame)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        (view as! ArrowView).arrowViewDelegate = self
        observeEndPointChanges()
    }
    
    func observeEndPointChanges(){
        observers = [
            sourceTool.observe(\Connectable.frameOnCanvas, options: [.old, .new]) {tool, change in
                self.view.needsDisplay = true},
            
            targetTool.observe(\Connectable.frameOnCanvas, options: [.old, .new]) {tool, change in
                self.view.needsDisplay = true}]
    }
    
}
