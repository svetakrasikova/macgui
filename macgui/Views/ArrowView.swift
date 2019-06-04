//
//  ArrowView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowView: NSView {
   
    var shapeLayer = CAShapeLayer()
    var delegate: ArrowViewDelegate?
    override var wantsUpdateLayer: Bool {return true}

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
    }
   
    override func updateLayer() {
        shapeLayer.removeFromSuperlayer()
        delegate?.drawArrowIn(layer: shapeLayer)
    }
    
}

protocol ArrowViewDelegate {
    func drawArrowIn(layer: CAShapeLayer)
}

