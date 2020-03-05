//
//  ModelCanvasItemView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemView: MovingCanvasObjectView {

    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    private let backgroundLayer = CAShapeLayer()
    
//    MARK: - Keyboard events
    
    override func mouseDown(with mouseDownEvent: NSEvent) {
        let isOptionKeyDown = (mouseDownEvent.modifierFlags.rawValue &  NSEvent.ModifierFlags.option.rawValue) != 0
        if isOptionKeyDown {
            guard
                let window = self.window,
                let source = window.dragEndpoint(at: mouseDownEvent.locationInWindow)
                else { return super.mouseDown(with: mouseDownEvent) }
            let controller = ConnectionDragController()
            controller.trackDrag(forMouseDownEvent: mouseDownEvent, in: source)
        } else {
            super.mouseDown(with: mouseDownEvent)
        }
    }

    
    override func makeBackingLayer() -> CALayer {
              return backgroundLayer
          }
    
//    TODO: Define model object specific preferences
     override func updateLayer() {
           super.updateLayer()
           layer?.cornerRadius = preferencesManager.canvasToolSelectionCornerRadius!
           layer?.borderWidth = preferencesManager.canvasToolBorderWidth!
           if isSelected {
               layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
               layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
               layer?.borderColor = preferencesManager.canvasToolSelectionColor?.cgColor
           } else {
               layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
               layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
           }
       }
    
}

// MARK: - Shapes

extension ModelCanvasItemView {
    
    func drawShape(shape: ModelParameterShape, fillColor: NSColor, strokeColor: NSColor, lineWidth: CGFloat) {
        let layer = CAShapeLayer()
        switch shape {
        case .solidCircle:
            layer.path = solidCirclePath(layer: layer)
        case .solidRectangle:
            layer.path = solidRectanglePath(layer: layer)
        case .dashedCircle:
            layer.path = dashedCirclePath(layer: layer)
        }
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor.cgColor
        backgroundLayer.addSublayer(layer)
        
    }
    
    func solidCirclePath(layer: CAShapeLayer) -> CGPath {
        let path = CGMutablePath()
        let centerPoint = self.bounds.center()
        path.addArc(center: centerPoint, radius: self.frame.width/2, startAngle: CGFloat(0.0), endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        return path
    }
    
    func dashedCirclePath(layer: CAShapeLayer) -> CGPath {
        let path = CGMutablePath()
        let centerPoint = self.bounds.center()
        path.addArc(center: centerPoint, radius: self.frame.width/2, startAngle: CGFloat(0.0), endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        layer.lineDashPattern = [4,2]
        return path
    }
    
    func solidRectanglePath(layer: CAShapeLayer) -> CGPath {
        let path = CGMutablePath()
        path.addRect(self.bounds)
        return path
    }
}

enum ModelParameterShape{
    case solidCircle
    case solidRectangle
    case dashedCircle
}
