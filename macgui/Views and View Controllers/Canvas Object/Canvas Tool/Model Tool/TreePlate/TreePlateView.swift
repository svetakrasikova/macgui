//
//  TreePlateView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateView: ResizableCanvasObjectView {
    
    override func updateLayer() {
        super.updateLayer()
        guard let backgroundColor = backgroundColor else { return }
        if isSelected {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.darkGray, dash: true, anchors: true)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
        } else {
            drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.systemGray, dash: true,  anchors: false)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
        }
    }

    
}
