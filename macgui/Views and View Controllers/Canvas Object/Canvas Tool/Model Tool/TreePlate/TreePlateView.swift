//
//  TreePlateView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateView: ResizableCanvasObjectView {
        
    override var borderColor: NSColor? {
        return preferencesManager.modelCanvasNodeBorderColor
    }
    
    override func updateLayer() {
        super.updateLayer()
        self.clearSublayers()
        guard let backgroundColor = backgroundColor else { return }
        guard let borderColor = borderColor else { return }
       
        if isSelected {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: borderColor, dash: true, anchors: true, label: false)
            drawDashedDelimiters()
            layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
        } else {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: borderColor, dash: true,  anchors: false, label: false)
            drawDashedDelimiters()
            layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
        }

        
    }
    
    
    func drawDashedDelimiters() {
        guard let borderColor = self.borderColor else { return }
        let panelWidth = frame.width/3
        let rootPanelLeftEdge = (NSPoint(x: bounds.minX + panelWidth + frameOffset, y: bounds.maxY - frameOffset), NSPoint(x: bounds.minX + panelWidth + frameOffset, y: bounds.minY + frameOffset))
        let internalsPanelLeftEdge = (NSPoint(x: bounds.minX + (panelWidth*2) + frameOffset, y: bounds.maxY - frameOffset), NSPoint(x: bounds.minX + (panelWidth*2) + frameOffset, y: bounds.minY + frameOffset))
        let branchesNodesDivider = (NSPoint(x: bounds.minX + panelWidth + frameOffset, y: bounds.maxY - bounds.height/2), NSPoint(x: bounds.maxX - frameOffset, y: bounds.maxY - bounds.height/2))
        let delimitersPath = CGMutablePath()
        delimitersPath.addLines(between: [rootPanelLeftEdge.0, rootPanelLeftEdge.1])
        delimitersPath.addLines(between: [internalsPanelLeftEdge.0, internalsPanelLeftEdge.1])
        delimitersPath.addLines(between: [branchesNodesDivider.0, branchesNodesDivider.1])
        let delimitersLayer = CAShapeLayer()
        delimitersLayer.path = delimitersPath
        delimitersLayer.strokeColor = borderColor.cgColor
        delimitersLayer.lineDashPattern = [4,2]
        delimitersLayer.lineWidth = 0.5
        layer?.addSublayer(delimitersLayer)
        
    }

    
}
