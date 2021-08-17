//
//  File.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

// MARK: - Names for defaults

enum PreferenceKey: String {
    //  Canvas Object
    case canvasObjectDimension = "canvasObjectDimension"
    case canvasLoopDimension = "canvasLoopDimension"
    case canvasTreePlateHeight
    case canvasTreePlateWidth
    case canvasLoopBackgroundColor
    
    // Generic Canvas
    case canvasSelectionWidth = "canvasSelectionWidth"
    
    //  Main Canvas
    case mainCanvasBackgroundColor = "mainCanvasBackgroundColor"
    case mainCanvasGridColor = "mainCanvasGridColor"
    case mainCanvasLoopBorderColor
    
    //  Model Canvas
    case modelCanvasBackgroundColor = "modelCanvasBackgroundColor"
    case modelCanvasArrowColor = "modelCanvasArrowColor"
    case modelCanvasClampedNodeColor = "modelCanvasClampedNodeColor"
    case modelCanvasNodeBorderColor = "modelCanvasNodeBorderColor"
    case modelCanvasNodeSelectionShadowOpacity = "modelCanvasNodeSelectionShadowOpacity"
    case modelCanvasNodeDefaultShadowOpacity = "modelCanvasNodeDefaultShadowOpacity"
    case modelCanvasNodeSelectionShadowRadius = "modelCanvasNodeSelectionShadowRadius"
    case modelCanvasNodeDefaultShadowRadius = "modelCanvasNodeDefaultShadowRadius"
    
    // Main Canvas Tool
    case canvasToolBorderWidth = "canvasToolBorderWidth"
    case canvasToolSelectionCornerRadius = "canvasToolSelectionCornerRadius"
    case canvasToolSelectionColor = "canvasToolSelectionColor"
    case canvasToolDefaultColor = "canvasToolDefaultColor"
    case canvasToolSelectionShadowOpacity = "canvasToolSelectionShadowOpacity"
    case canvasToolDefaultShadowOpacity = "canvasToolDefaultShadowOpacity"
    case canvasToolSelectionShadowRadius = "canvasToolSelectionShadowRadius"
    case canvasToolDefaultShadowRadius = "canvasToolDefaultShadowRadius"
    
}

class PreferencesManager {
    
    private let userDefaults = UserDefaults.standard
    
    let preferences =
        [
            PreferenceKey.modelCanvasNodeSelectionShadowOpacity.rawValue: 0.7,
            PreferenceKey.modelCanvasNodeDefaultShadowOpacity.rawValue: 0.1,
            PreferenceKey.modelCanvasNodeSelectionShadowRadius.rawValue: 10.0,
            PreferenceKey.modelCanvasNodeDefaultShadowRadius.rawValue: 5.0,
            PreferenceKey.canvasSelectionWidth.rawValue: 5.0,
            PreferenceKey.canvasObjectDimension.rawValue: 50.0,
            PreferenceKey.canvasLoopDimension.rawValue: 100.0,
            PreferenceKey.canvasTreePlateHeight.rawValue: 200.0,
            PreferenceKey.canvasTreePlateWidth.rawValue: 300.0,
            PreferenceKey.canvasToolBorderWidth.rawValue: 1.8,
            PreferenceKey.canvasToolSelectionCornerRadius.rawValue: 5.0,
            PreferenceKey.canvasToolSelectionShadowOpacity.rawValue: 0.7,
            PreferenceKey.canvasToolDefaultShadowOpacity.rawValue: 0.0,
            PreferenceKey.canvasToolSelectionShadowRadius.rawValue: 10.0,
            PreferenceKey.canvasToolDefaultShadowRadius.rawValue: 3.0
            
            ] as [String : Any]
    
    
    var cachedPreferences: [String: Any] = [:]
    
    //    MARK: - Preferences
    
    @objc dynamic var mainCanvasBackroundColor: NSColor? {
        set (newMainCanvasBackgroundColor) {
            userDefaults.set(newMainCanvasBackgroundColor, forKey: PreferenceKey.mainCanvasBackgroundColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.mainCanvasBackgroundColor.rawValue)
        }
    }
    
    @objc dynamic var mainCanvasLoopBorderColor: NSColor? {
        set (newMainCanvasLoopBorderColor) {
            userDefaults.set(newMainCanvasLoopBorderColor, forKey: PreferenceKey.mainCanvasLoopBorderColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.mainCanvasLoopBorderColor.rawValue)
        }
    }
    
    @objc dynamic var mainCanvasGridColor: NSColor? {
        set (newMainCanvasGridColor) {
            userDefaults.set(newMainCanvasGridColor, forKey: PreferenceKey.mainCanvasGridColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.mainCanvasGridColor.rawValue)
        }
    }
    
    @objc dynamic var modelCanvasBackgroundColor: NSColor? {
        set (newModelCanvasBackgroundColor) {
            userDefaults.set(newModelCanvasBackgroundColor, forKey: PreferenceKey.modelCanvasBackgroundColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.modelCanvasBackgroundColor.rawValue)
        }
    }
    
    @objc dynamic var modelCanvasArrowColor: NSColor? {
        set (newModelCanvasArrowColor) {
            userDefaults.set(newModelCanvasArrowColor, forKey: PreferenceKey.modelCanvasArrowColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.modelCanvasArrowColor.rawValue)
        }
    }
    
    @objc dynamic var modelCanvasClampedNodeColor: NSColor? {
        set (newModelCanvasClampedNodeColor) {
            userDefaults.set(newModelCanvasClampedNodeColor, forKey: PreferenceKey.modelCanvasClampedNodeColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.modelCanvasClampedNodeColor.rawValue)
        }
    }
    
    
    @objc dynamic var modelCanvasNodeBorderColor: NSColor? {
        set (newModelCanvasNodeBorderColor) {
            userDefaults.set(newModelCanvasNodeBorderColor, forKey: PreferenceKey.modelCanvasNodeBorderColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.modelCanvasNodeBorderColor.rawValue)
        }
    }
    
    
    var canvasSelectionWidth: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasSelectionWidth.rawValue) as? CGFloat
        }
    }
    
    var canvasObjectDimension: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasObjectDimension.rawValue) as? CGFloat
        }
    }
    
    var canvasLoopDimension: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasLoopDimension.rawValue) as? CGFloat
        }
    }
    
    var canvasTreePlateHeight: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasTreePlateHeight.rawValue) as? CGFloat
        }
    }
    
    var canvasTreePlateWidth: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasTreePlateWidth.rawValue) as? CGFloat
        }
    }
    
    
    var canvasLoopBackgroundColor: NSColor? {
        get {
            return userDefaults.color(forKey: PreferenceKey.canvasLoopBackgroundColor.rawValue)
        }
    }
    
    var canvasToolBorderWidth: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolBorderWidth.rawValue) as? CGFloat
        }
    }
    var canvasToolSelectionCornerRadius: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolSelectionCornerRadius.rawValue) as? CGFloat
        }
    }
    var canvasToolSelectionColor: NSColor? {
        get {
            return userDefaults.color(forKey: PreferenceKey.canvasToolSelectionColor.rawValue)
        }
    }
    
    var canvasToolSelectionShadowOpacity: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolSelectionShadowOpacity.rawValue) as? CGFloat
        }
    }
    var canvasToolDefaultShadowOpacity: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolDefaultShadowOpacity.rawValue) as? CGFloat
        }
    }
    var canvasToolSelectionShadowRadius: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolSelectionShadowRadius.rawValue) as? CGFloat
        }
    }
    var canvasToolDefaultShadowRadius: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolDefaultShadowRadius.rawValue) as? CGFloat
        }
    }
    
    var modelCanvasNodeSelectionShadowOpacity: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.canvasToolSelectionShadowOpacity.rawValue) as? CGFloat
        }
    }
    var modelCanvasNodeDefaultShadowOpacity: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.modelCanvasNodeDefaultShadowOpacity.rawValue) as? CGFloat
        }
    }
    var modelCanvasNodeSelectionShadowRadius: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.modelCanvasNodeSelectionShadowRadius.rawValue) as? CGFloat
        }
    }
    var modelCanvasNodeDefaultShadowRadius: CGFloat? {
        get {
            return userDefaults.object(forKey: PreferenceKey.modelCanvasNodeDefaultShadowRadius.rawValue) as? CGFloat
        }
    }
    
    
    
    init() {
        registerDefaultPreferences()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willChangePreferences(notification:)), name: .willChangePreferences, object: nil)
    }
    
    func registerDefaultPreferences() {
        userDefaults.register(defaults: self.preferences)
        storeDefaultColorSettings()
    }
    
    func storeDefaultColorSettings() {
        userDefaults.set(NSColor.white, forKey: PreferenceKey.modelCanvasBackgroundColor.rawValue)
        userDefaults.set(NSColor.gray, forKey: PreferenceKey.mainCanvasLoopBorderColor.rawValue)
        userDefaults.set(NSColor.gray, forKey: PreferenceKey.modelCanvasNodeBorderColor.rawValue)
        userDefaults.set(NSColor.gray, forKey: PreferenceKey.modelCanvasArrowColor.rawValue)
        userDefaults.set(NSColor.yellow, forKey: PreferenceKey.modelCanvasClampedNodeColor.rawValue)
        userDefaults.set(NSColor.white, forKey: PreferenceKey.mainCanvasBackgroundColor.rawValue)
        userDefaults.set(NSColor.systemGray, forKey: PreferenceKey.mainCanvasGridColor.rawValue)
        userDefaults.set(NSColor.systemGray, forKey: PreferenceKey.canvasToolSelectionColor.rawValue)
        userDefaults.set(NSColor.gray, forKey: PreferenceKey.canvasLoopBackgroundColor.rawValue)
    }
    

    
    @objc func willChangePreferences(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: String], let key = userInfo["key"] {
            switch key {
            case PreferenceKey.mainCanvasBackgroundColor.rawValue:
                self.cachedPreferences[key] = mainCanvasBackroundColor
            case PreferenceKey.mainCanvasGridColor.rawValue:
                self.cachedPreferences[key] = mainCanvasGridColor
            case PreferenceKey.canvasObjectDimension.rawValue:
                self.cachedPreferences[key] = canvasObjectDimension
            case PreferenceKey.canvasLoopDimension.rawValue:
                self.cachedPreferences[key] = canvasLoopDimension
            case PreferenceKey.canvasTreePlateHeight.rawValue:
                self.cachedPreferences[key] = canvasTreePlateHeight
            case PreferenceKey.canvasTreePlateWidth.rawValue:
                self.cachedPreferences[key] = canvasTreePlateWidth
            case PreferenceKey.canvasLoopBackgroundColor.rawValue:
                self.cachedPreferences[key] = canvasLoopBackgroundColor
            case PreferenceKey.canvasSelectionWidth.rawValue:
                self.cachedPreferences[key] = canvasSelectionWidth
            case PreferenceKey.modelCanvasBackgroundColor.rawValue:
                self.cachedPreferences[key] = modelCanvasBackgroundColor
            case PreferenceKey.modelCanvasClampedNodeColor.rawValue:
                self.cachedPreferences[key] = modelCanvasClampedNodeColor
            case PreferenceKey.modelCanvasArrowColor.rawValue:
                self.cachedPreferences[key] = modelCanvasArrowColor
            case PreferenceKey.modelCanvasNodeBorderColor.rawValue:
                self.cachedPreferences[key] = modelCanvasNodeBorderColor
            case PreferenceKey.mainCanvasLoopBorderColor.rawValue:
                self.cachedPreferences[key] = mainCanvasLoopBorderColor
            default:
                print("Unrecognised preference key")
            }
        }
    }
    
    func resetDefaults() {
        for (key, value) in self.preferences {
                userDefaults.set(value, forKey: key)
            }
        storeDefaultColorSettings()
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                        object: self)
    }
    
 
    func resetToCachedPreferences() {
        for (key, value) in self.cachedPreferences {
            if let color = value as? NSColor {
                userDefaults.set(color, forKey: key)
            } else {
                userDefaults.set(value, forKey: key)
            }
        }
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                        object: self)
    }
    
    
    
}
