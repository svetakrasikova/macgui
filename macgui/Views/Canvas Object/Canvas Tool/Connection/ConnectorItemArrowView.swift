//
//  ConnectorItemArrowView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/2/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItemArrowView: ConnectorItemView {

    private let arrowLayer = CAShapeLayer()
    
    override func layout() {
        super.layout()
        setAppearanceForState()
    }
    
    func drawArrow(color: NSColor){
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height/2))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        arrowLayer.strokeColor = NSColor.darkGray.cgColor
        arrowLayer.lineWidth = 0.5
        connectionColor = color
        arrowLayer.path = path
        shapeLayer.addSublayer(arrowLayer)
    }
    
    private func setAppearanceForState() {
        switch state {
        case .source:
            arrowLayer.fillColor = NSColor.gray.cgColor
        case .target:
            arrowLayer.fillColor = NSColor.gray.cgColor
        default:
            arrowLayer.fillColor = connectionColor?.cgColor
        }
    }
}
