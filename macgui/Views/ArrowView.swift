//
//  ArrowView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/24/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ArrowView: CanvasObjectView {
    
    var arrowViewDelegate: ArrowViewDelegate?
    var clickArea: CGPath?

    
    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        if clickAreaContains(point: point) {
            print("Hit test: success!")
            super.mouseDown(with: event)
        } else {
//            print("Hit test: failed!")
//            var responder = self.nextResponder!
//            while (responder.nextResponder != nil){
//                responder = responder.nextResponder!
//                if responder.isKind(of: CanvasView.self) {
//                    responder.mouseDown(with: event)
//                }
//            }
            if let canvasView = self.superview as? CanvasView {
                if canvasView.delegate?.isMouseDownOnArrowView(event: event, point: point) == false {
                    canvasView.mouseDown(with: event)
                }
            }
        }
    }
    
    func clickAreaContains(point: NSPoint) -> Bool {
        if let clickArea = clickArea {
            let contains = clickArea.contains(point)
            return contains
            
        }
        else { return false }
    }
    
    
    override func updateLayer() {
        arrowViewDelegate?.setClickArea()
        arrowViewDelegate?.updateArrowInLayer(selected: isSelected)
    }

    
}

protocol ArrowViewDelegate {
    func updateArrowInLayer(selected: Bool)
    func setClickArea()
}

