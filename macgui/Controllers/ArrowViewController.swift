//
//  ArrowViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowViewController: CanvasObjectViewController, ArrowViewDelegate {
    
    private var observers = [NSKeyValueObservation]()
    

    var targetTool: Connectable
    var sourceTool: Connectable
    var connection: Connection
    
    var frame: NSRect
    var color: NSColor
    
    
    
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
    
    
    init(frame: NSRect, color: NSColor, sourceTool: Connectable, targetTool: Connectable, connection: Connection){
        self.targetTool = targetTool
        self.sourceTool = sourceTool
        self.color = color
        self.frame = frame
        self.connection = connection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createLinePath() -> CGMutablePath {
        let path = CGMutablePath()
        path.addLines(between: [beginPoint, endPoint])
        return path
    }
    
    func ownedBy(tool: ToolObject) -> Bool{
        if self.targetTool  === tool || self.sourceTool === tool {
            return true
        }
        return false
    }
    
    func drawArrow(width: CGFloat, color: CGColor){
        if let sublayers = view.layer?.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        let arrowLayer = CAShapeLayer()
        arrowLayer.strokeColor = color
        arrowLayer.lineWidth = width
        arrowLayer.path = createLinePath()
        view.layer?.addSublayer(arrowLayer)
    }
    
    func updateArrowInLayer(selected: Bool){
        if selected {
//            draw normal width arrow and stroke the click area path
            drawArrow(width: 4.0, color: CanvasObjectView.Appearance.selectionColor)
        } else {
            drawArrow(width: 2.0, color: color.cgColor)
        }
    }
    
    
    func setClickArea(){
        let path = CGMutablePath()
        path.addLines(between: [beginPoint, endPoint])
        (self.view as! ArrowView).clickArea = path.copy(strokingWithWidth: 10, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 1)    }
    
    override func loadView() {
        self.view = ArrowView(frame: frame)     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! ArrowView).arrowViewDelegate = self
        view.wantsLayer = true
        drawArrow(width: 2.0, color: color.cgColor)
        setClickArea()
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
