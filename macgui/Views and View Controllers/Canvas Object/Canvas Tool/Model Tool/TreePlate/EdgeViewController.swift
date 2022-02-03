//
//  EdgeViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class EdgeViewController: NSViewController, NSWindowDelegate, EdgeViewDelegate {


    private var observers = [NSKeyValueObservation]()
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager

    weak var targetTool: ToolObject?
    weak var sourceTool: ToolObject?
    var frame: NSRect?
    var color: NSColor?
    
    var endPoint: NSPoint {
        get{
            return (targetTool?.frameOnCanvas.center())!
        }
    }
    
    var beginPoint: NSPoint {
        get {
            return (sourceTool?.frameOnCanvas.center())!
        }
    }
    
    private var targetToolFrame: NSRect {
        get {
            return (targetTool?.frameOnCanvas)!
        }
    }
    
    func updateEdgeInLayer() {
        drawEdge(width: 1.0)
    }
    
    
    func clearSublayers(){
        if let sublayers = view.layer?.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    func drawEdge(width: CGFloat){
        clearSublayers()
        let arrowLayer = CAShapeLayer()
        if let color = self.color {
            arrowLayer.strokeColor = color.cgColor
        } else {
            arrowLayer.strokeColor = preferencesManager.modelCanvasArrowColor?.cgColor
        }
        arrowLayer.lineWidth = width
        let combined = CGMutablePath()
        combined.addPath(createLinePath())
        arrowLayer.path = combined
        view.layer?.addSublayer(arrowLayer)
        
    }
    
    
    func createLinePath() -> CGMutablePath {
        let path = CGMutablePath()
        path.addLines(between: [beginPoint, endPoint])
        return path
    }
    
    
    override func loadView() {
        self.view = EdgeView(frame: frame!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as? EdgeView else { return }
        view.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
        view.wantsLayer = true
        view.unregisterDraggedTypes()
        drawEdge(width: 1.0)
        observeEndPointChanges()
    }
    
    
    func windowDidResize(_ notification: Notification) {
        if let canvasView = view.superview as? GenericCanvasView {
            view.setFrameSize(canvasView.frame.size)
        }
    }
    
    func observeEndPointChanges(){
        observers = [
            sourceTool?.observe(\ToolObject.frameOnCanvas, options: [.old, .new]) {tool, change in
                self.view.needsDisplay = true},
            
            targetTool?.observe(\ToolObject.frameOnCanvas, options: [.old, .new]) {tool, change in
                self.view.needsDisplay = true}] as! [NSKeyValueObservation]
    }
    
    
}
