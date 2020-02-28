//
//  ModelCanvasItemView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemView: CanvasObjectView {

    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
       
   //    MARK: - Layer Drawing
    
//    TODO: Define model object specific preferences
     override func updateLayer() {
           super.updateLayer()
           layer?.cornerRadius = preferencesManager.canvasToolSelectionCornerRadius!
           layer?.borderWidth = preferencesManager.canvasToolBorderWidth!
           if isSelected {
               layer?.shadowOpacity = Float(preferencesManager.canvasToolSelectionShadowOpacity!)
               layer?.shadowRadius = preferencesManager.canvasToolSelectionShadowRadius!
               layer?.borderColor = preferencesManager.canvasToolSelectionColor?.cgColor
           } else {
               layer?.shadowOpacity = Float(preferencesManager.canvasToolDefaultShadowOpacity!)
               layer?.shadowRadius = preferencesManager.canvasToolDefaultShadowRadius!
           }
       }
    
}
