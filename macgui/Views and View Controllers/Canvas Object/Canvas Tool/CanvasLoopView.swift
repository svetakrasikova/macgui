//
//  CanvasLoopView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/8/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasLoopView: ResizableCanvasObjectView {

    var backgroundColor: NSColor? {
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        return preferencesManager.canvasLoopBackgroundColor
        
    }
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
 
//    MARK: - Layer Drawing
    
    override func updateLayer() {
        super.updateLayer()
       
        clearSublayers()
       
        guard let backgroundColor = backgroundColor else { return }
        
        if isSelected {
            drawBorderAndAnchors(fillcolor: backgroundColor.withAlphaComponent(0.2), strokeColor: NSColor.darkGray, anchors: true)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!

        } else {
           
            drawBorderAndAnchors(fillcolor: backgroundColor.withAlphaComponent(0.2), strokeColor: NSColor.systemGray, anchors: false)
            layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
            layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
        }
    }
    
    
   
    
}
