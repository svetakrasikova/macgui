//
//  ModelCanvasItemViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemViewController: CanvasObjectViewController {

    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var fillColor: NSColor? {
//        TODO: If a clamped node return the clamped node color
        guard let fillColor = preferencesManager.modelCanvasBackgroundColor
            else { return nil }
        return fillColor
    }
    
    var strokeColor: NSColor? {
        guard let strokeColor = preferencesManager.modelCanvasNodeBorderColor
            else { return nil }
        return strokeColor
    }
    
    var shape: ModelParameterShape? {
        return .dashedCircle
    }
    
    var label: String? {
        return Symbol.doubleStruckCapitalR.rawValue
    }
    
    var frame: NSRect {
        guard let node = self.tool as? ModelNode else {
            print("\(self): view frame is undefined.")
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
        addShape()
        addDividerLine()
        addInfoButton()
    }
    func setFrame() {
        view.frame = self.frame
    }
    
    func addShape() {
        guard let shape = self.shape else {
             print("drawShapeInLayer: the shape type for the shape layer is undefined.")
            return
        }
        guard let fillColor = self.fillColor else {
             print("drawShapeInLayer: the fill color for the shape layer is undefined.")
            return
        }
        guard let strokeColor = self.strokeColor else {
            print("drawShapeInLayer: the stroke color for the shape layer is undefined.")
            return
        }
        if let view = view as? ModelCanvasItemView {
            view.drawShape(shape: shape, fillColor: fillColor, strokeColor: strokeColor, lineWidth: 1.0)
        }
    }

    
    func updateShapeLayer(_ shapeLayer: CAShapeLayer, selected:  Bool) {
        if selected {
            addShape()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeSelectionShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeSelectionShadowRadius!
        } else {
            addShape()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeDefaultShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeDefaultShadowRadius!
        }
        addDividerLine()
        addLabel()
        addInfoButton()
    }
    
    func addInfoButton(){
        guard let fillColor = self.fillColor else {
            print("addInfoButton: fill color for the shape layer is undefined.")
            return
        }
        let infoButton = ActionButton()
        if fillColor.isLight() ?? true { infoButton.labelColor = NSColor.black.cgColor }
        let buttonOrigin = CGPoint(x: view.bounds.center().x-4, y: view.bounds.center().y-20)
        infoButton.frame = CGRect(origin: buttonOrigin, size: CGSize(width: 8, height: 8))
        infoButton.tag = 0
        infoButton.isTransparent = true
        infoButton.setButtonType(.momentaryPushIn)
        self.view.addSubview(infoButton)
    }
    
    func addDividerLine() {
        guard let strokeColor = self.strokeColor else {
            print("addDividerLine: stroke color for the shape layer is undefined.")
            return
        }
        if let view = self.view as? ModelCanvasItemView {
            view.drawDividerLine(strokeColor: strokeColor, lineWidth: 1.0)
        }
        
    }
    
    func addLabel() {
        guard let fillColor = self.fillColor else {
            print("addLabel: fill color for the shape layer is undefined.")
            return
        }
        guard let label = self.label else {
            print("addLabel: label for the shape layer is undefined.")
            return
        }
        if let view = self.view as? ModelCanvasItemView {
            
            if fillColor.isLight() ?? true {
                view.drawLabel(labelColor: NSColor.black, label: label)
            } else {
                view.drawLabel(labelColor: NSColor.white, label: label)
            }
          
        }
    }
    
 
    
}
