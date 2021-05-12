//
//  CanvasLoopView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasLoopView: ResizableCanvasObjectView {
    
    override func updateLayer() {
        super.updateLayer()
        guard let backgroundColor = backgroundColor else { return }
        if isSelected {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.darkGray, anchors: true)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
        } else {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.systemGray, anchors: false)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
        }
    }
    
    
}