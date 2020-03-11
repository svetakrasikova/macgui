//
//  ModelCanvasPreferencesController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/18/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasPreferencesController: NSViewController {
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var didChangeSettings: Bool = false {
        didSet {
            NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                            object: self)
        }
    }
    var willChangeInitialBackgroundColor: Bool = true
    var willChangeInitialArrowColor: Bool = true
    var willChangeInitialClampedNodeColor: Bool = true
    var willChangeInitialNodeBorderColor: Bool = true
    
    
    @IBAction func changeCanvasBackgroundColor(_ sender: NSColorWell) {
        
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.modelCanvasBackgroundColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialBackgroundColor = false
        }
        let newColor = sender.color
        preferencesManager.modelCanvasBackgroundColor = newColor
        didChangeSettings = true
    }
    @IBAction func changeArrowColor(_ sender: NSColorWell) {
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.modelCanvasArrowColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialArrowColor = false
        }
        let newColor = sender.color
        preferencesManager.modelCanvasArrowColor = newColor
        didChangeSettings = true
    }
    @IBAction func changeClampedNodeColor(_ sender: NSColorWell) {
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.modelCanvasClampedNodeColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialClampedNodeColor = false
        }
        let newColor = sender.color
        preferencesManager.modelCanvasClampedNodeColor = newColor
        didChangeSettings = true
    }
    @IBAction func changeNodeBorderColor(_ sender: NSColorWell) {
        
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.modelCanvasNodeBorderColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialNodeBorderColor = false
        }
        let newColor = sender.color
        preferencesManager.modelCanvasNodeBorderColor = newColor
        didChangeSettings = true
    }
    
}
