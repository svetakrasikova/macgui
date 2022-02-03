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
    let textLayer = CATextLayer()
    
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
    
    override func mouseUp(with event: NSEvent) {
        if isMouseDragged
        {
            delegate?.checkForLoopInclusion()
            
        }
        super.mouseUp(with: event)
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
    
    func dashedRectanglePath(layer: CAShapeLayer) -> CGPath {
        let path = CGMutablePath()
        path.addRect(self.bounds)
        layer.lineDashPattern = [4,2]
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
    
    func drawLabel(labelColor: NSColor, label: String, plateIndex: String?) {
        textLayer.allowsEdgeAntialiasing = false;
        textLayer.allowsFontSubpixelQuantization = true;
        if  var backingScaleFactor = self.window?.backingScaleFactor {
            backingScaleFactor *= 4
            layer?.contentsScale = backingScaleFactor
            shapeLayer.contentsScale = backingScaleFactor
            textLayer.contentsScale = backingScaleFactor
        }
        textLayer.frame = NSRect(x: bounds.minX, y: bounds.center().y-8, width: bounds.size.width, height: bounds.size.height/2+8)
        textLayer.font = NSFont(name: "Hoefler Text", size: 18)
        textLayer.backgroundColor = NSColor.clear.cgColor
        textLayer.foregroundColor = labelColor.cgColor
        textLayer.fontSize = 18
        setLabelStringOn(textLayer, label: label, plateIndex: plateIndex)
        textLayer.position = bounds.center()
        textLayer.alignmentMode = .center
        shapeLayer.addSublayer(textLayer)
    }
    
    
    func setLabelStringOn(_ textLayer: CATextLayer, label: String, plateIndex: String?) {
        var indicesOfSubscripts: [Int] = []
        var text = label
        if let plateIndex = plateIndex {
            indicesOfSubscripts = findIndicesOfSubscripts(label: label, plateIndex: plateIndex)
            text += plateIndex
        }
        textLayer.setAttributedTextWithSubscripts(text: text, indicesOfSubscripts: indicesOfSubscripts)
    }
    
    func findIndicesOfSubscripts(label: String, plateIndex: String) -> [Int] {
        var indices = [Int]()
        let text = label + plateIndex
        for i in 0..<text.count {
            if i >= label.count {
                indices.append(i)
            }
        }
        return indices
    }
    
    func drawTreeTopologyImage(strokeColor: NSColor, lineWidth: CGFloat, rooted: Bool) {
        let w = self.bounds.size.width * 0.8
        let h = w * 2.0 / 3.0
        let origin = NSMakePoint(bounds.origin.x + (bounds.size.width - w)*0.5, bounds.origin.y + (bounds.size.height - h)*0.5)
        let imageLayer = CAShapeLayer()
        let imagePath = rooted ? rootedTreeTopologyPath(origin: origin, w: w, h: h) : unrootedTreeTopologyPath(origin: origin, w: w, h: h)
        imageLayer.path = imagePath
        imageLayer.lineWidth = lineWidth
        imageLayer.strokeColor = strokeColor.cgColor
        layer?.addSublayer(imageLayer)
    }
    
    func rootedTreeTopologyPath(origin: NSPoint, w: CGFloat, h: CGFloat) -> CGMutablePath {
        let tPath = CGMutablePath()
        var tp: [NSPoint] = Array(repeating: NSZeroPoint, count: 14)
        tp[0] = NSMakePoint(0.0, 1.0)
        tp[1] = NSMakePoint(0.5, 1.0)
        tp[2] = NSMakePoint(1.0, 1.0)
        tp[3] = NSMakePoint(1.5, 1.0)
        tp[4] = NSMakePoint(0.00, 0.4)
        tp[5] = NSMakePoint(0.25, 0.4)
        tp[6] = NSMakePoint(0.50, 0.4)
        tp[7] = NSMakePoint(1.00, 0.6)
        tp[8] = NSMakePoint(1.25, 0.6)
        tp[9] = NSMakePoint(1.50, 0.6)
        tp[10] = NSMakePoint(0.25, 0.15)
        tp[11] = NSMakePoint(0.75, 0.15)
        tp[12] = NSMakePoint(1.25, 0.15)
        tp[13] = NSMakePoint(0.75, 0.00)
        for i in 0..<tp.count {
            tp[i].x *= (1.0/1.5)*w
            tp[i].y *= (1.0/1.5)*w
            tp[i].x += origin.x
            tp[i].y += origin.y
        }
        tPath.addLines(between: [tp[0], tp[4]])
        tPath.addLines(between: [tp[4], tp[6]])
        tPath.addLines(between: [tp[6], tp[1]])
        tPath.addLines(between: [tp[2], tp[7]])
        tPath.addLines(between: [tp[7], tp[9]])
        tPath.addLines(between: [tp[9], tp[3]])
        tPath.addLines(between: [tp[5], tp[10]])
        tPath.addLines(between: [tp[10], tp[12]])
        tPath.addLines(between: [tp[12], tp[8]])
        tPath.addLines(between: [tp[11], tp[13]])
        return tPath
    }
    
    func unrootedTreeTopologyPath(origin: NSPoint, w: CGFloat, h: CGFloat) -> CGMutablePath {
        let tPath = CGMutablePath()
        var points: [NSPoint] = Array(repeating: origin, count: 6)
        let seg = w / 3.0
        points[1].x += seg
        points[1].y += seg
        points[2].y += h
        points[3].x += h
        points[3].y += seg
        points[4].x += w
        points[4].y += h
        points[5].x += w
        tPath.addLines(between: [points[0], points[1]])
        tPath.addLines(between: [points[1], points[2]])
        tPath.addLines(between: [points[1], points[3]])
        tPath.addLines(between: [points[3], points[4]])
        tPath.addLines(between: [points[3], points[5]])
        return tPath
    }

}

enum ModelParameterShape {
    case solidCircle
    case solidRectangle
    case dashedCircle
}
