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
        if let node = self.tool as? ModelNode{
            // get the type of the parameter from the palettItem
            let palettItem = node.nodeType
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
        drawShapeInLayer()
        addInfoButton()
    }
    func setFrame () {
        view.frame = self.frame
    }
    
    func drawShapeInLayer() {
        if let view = view as? ModelCanvasItemView, let shape = self.shape, let fillColor = self.fillColor, let strokeColor = self.strokeColor {
            view.drawShape(shape: shape, fillColor: fillColor, strokeColor: strokeColor, lineWidth: 1.0)
        }
    }
    
    func updateShapeLayer(_ shapeLayer: CAShapeLayer, selected:  Bool) {
        if selected {
            drawShapeInLayer()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeSelectionShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeSelectionShadowRadius!
        } else {
            drawShapeInLayer()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeDefaultShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeDefaultShadowRadius!
        }
        addInfoButton()
    }
    
    func addInfoButton(){
        guard let fillColor = self.fillColor else { return }
        let infoButton = ActionButton()
        if fillColor.isLight() ?? true { infoButton.labelColor = NSColor.black.cgColor }
        let buttonOrigin = CGPoint(x: view.bounds.center().x-4, y: view.bounds.center().y-20)
        infoButton.frame = CGRect(origin: buttonOrigin, size: CGSize(width: 8, height: 8))
        infoButton.tag = 0
        infoButton.isTransparent = true
        infoButton.setButtonType(.momentaryPushIn)
        self.view.addSubview(infoButton)
    }
    
}
