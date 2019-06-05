//
//  ArrowView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowView: CanvasObjectView {
   
    let shapeLayer = CAShapeLayer()
    var arrowViewDelegate: ArrowViewDelegate?
    
    override func mouseDown(with event: NSEvent) {
        //TODO: figure out how to convert to the right view coordinate system
        let point = event.locationInWindow
            if shapeLayer.contains(point) {
            print("Arrow clicked!")
        }
            NSAnimationEffect.poof.show(centeredAt: point, size: NSSize(width: 10, height: 10))
    }
    override func updateLayer() {
        shapeLayer.removeFromSuperlayer()
        arrowViewDelegate?.drawArrowIn(layer: shapeLayer)
        shapeLayer.cornerRadius = Appearance.selectionCornerRadius
        shapeLayer.borderWidth = Appearance.selectionWidth
        if isSelected {
            shapeLayer.borderColor = Appearance.selectionColor
        } else {
            shapeLayer.borderColor = NSColor.clear.cgColor
       
        }
    }
    
}

protocol ArrowViewDelegate {
    func drawArrowIn(layer: CAShapeLayer)
}

