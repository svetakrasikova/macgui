//
//  ModelCanvasItemViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemViewController: CanvasObjectViewController {

    
    var fillColor: NSColor? {
//        TODO: If a clamped node return the clamped node color
        if  let fillColor = (NSApp.delegate as! AppDelegate).preferencesManager.modelCanvasBackgroundColor {
            return fillColor
        }
        return nil
    }
    
    var shape: ModelParameterShape? {
        if let node = self.tool as? ModelNode{
            let palettItem = node.nodeType
            // get the type of the parameter from the palettItem
            return .dashedCircle
        }
        return nil
    }
    
    var frame: NSRect {
        guard let node = self.tool as? ModelNode else {
            return NSZeroRect
        }
        return node.frameOnCanvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        view.wantsLayer = true
        setFrame()
        if let view = view as? ModelCanvasItemView, let shape = self.shape, let fillColor = self.fillColor {
            view.drawShape(shape: shape, fillColor: fillColor, strokeColor: NSColor.gray, lineWidth: 1.0)
        }
    }
    
    func setFrame () {
        view.frame = self.frame
    }
    
}
