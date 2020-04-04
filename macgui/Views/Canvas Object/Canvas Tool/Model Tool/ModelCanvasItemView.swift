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
    private let shapeLayer = CAShapeLayer()
    
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

    
    override func updateLayer() {
        super.updateLayer()
        if let delegate = delegate as? ModelCanvasItemViewController {
            delegate.updateShapeLayer(shapeLayer, selected: isSelected)
        }
    }    
}

// MARK: - Shapes

extension ModelCanvasItemView {
    
    func drawShape(shape: ModelParameterShape, fillColor: NSColor, strokeColor: NSColor, lineWidth: CGFloat) {
        switch shape {
        case .solidCircle:
            shapeLayer.path = solidCirclePath(layer: shapeLayer)
        case .solidRectangle:
            shapeLayer.path = solidRectanglePath(layer: shapeLayer)
        case .dashedCircle:
            shapeLayer.path = dashedCirclePath(layer: shapeLayer)
        }
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor.cgColor
        layer?.addSublayer(shapeLayer)
        
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
    
    func drawDividerLine(strokeColor: NSColor, lineWidth: CGFloat) {
        let lineLayer = CAShapeLayer()
        let linePath = CGMutablePath()
        let begPoint = CGPoint(x: bounds.minX+7, y: bounds.center().y-8)
        let endPoint = CGPoint(x: bounds.maxX-7, y: bounds.center().y-8)
        linePath.move(to: begPoint)
        linePath.addLine(to: endPoint)
        lineLayer.path = linePath
        lineLayer.lineWidth = lineWidth
        lineLayer.strokeColor = strokeColor.cgColor
        layer?.addSublayer(lineLayer)
     }
    
    func drawLabel(labelColor: NSColor, label: String) {
        let textLayer = CATextLayer()

        if  let backingScaleFactor = self.window?.backingScaleFactor {
            shapeLayer.contentsScale = backingScaleFactor
            textLayer.contentsScale = backingScaleFactor
        }
        textLayer.frame = NSRect(x: bounds.minX, y: bounds.center().y-8, width: bounds.size.width, height: bounds.size.height/2+8)
        textLayer.font = "System Regular" as CFTypeRef
        textLayer.backgroundColor = NSColor.clear.cgColor
        textLayer.foregroundColor = labelColor.cgColor
        textLayer.fontSize = 18
        textLayer.string = label
        textLayer.allowsFontSubpixelQuantization = true
        textLayer.position = bounds.center()
        textLayer.alignmentMode = .center;
        shapeLayer.addSublayer(textLayer)
    }
    

}

enum ModelParameterShape{
    case solidCircle
    case solidRectangle
    case dashedCircle
}