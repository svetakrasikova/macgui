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
    
    // Generic Canvas
    case canvasSelectionWidth = "canvasSelectionWidth"
    
    //  Main Canvas
    case mainCanvasBackgroundColor = "mainCanvasBackgroundColor"
    case mainCanvasGridColor = "mainCanvasGridColor"
    
    //  Model Canvas
    case modelCanvasBackgroundColor = "modelCanvasBackgroundColor"
    
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
    
    let defaults =
        [
            PreferenceKey.mainCanvasBackgroundColor.rawValue: NSColor.white,
            PreferenceKey.mainCanvasGridColor.rawValue: NSColor.gray,
            PreferenceKey.modelCanvasBackgroundColor.rawValue: NSColor.white,
            PreferenceKey.canvasSelectionWidth.rawValue: 5.0,
            PreferenceKey.canvasObjectDimension.rawValue: 50.0,
            PreferenceKey.canvasToolBorderWidth.rawValue: 1.8,
            PreferenceKey.canvasToolSelectionCornerRadius.rawValue: 5.0,
            PreferenceKey.canvasToolSelectionColor.rawValue: NSColor.gray,
            PreferenceKey.canvasToolSelectionShadowOpacity.rawValue: 0.7,
            PreferenceKey.canvasToolDefaultShadowOpacity.rawValue: 0.0,
            PreferenceKey.canvasToolSelectionShadowRadius.rawValue: 10.0,
            PreferenceKey.canvasToolDefaultShadowRadius.rawValue: 3.0
            
            ] as [String : Any]
    
    
    enum Appearance {
        static let borderWidth: CGFloat = 1.8
        static let selectionCornerRadius: CGFloat = 5.0
           
           static let selectionColor: CGColor = NSColor.systemGray.cgColor
           static let defaultColor: CGColor = NSColor.clear.cgColor
           
           static let selectionShadowOpacity: Float = 0.7
           static let defaultShadowOpacity: Float = 0.0
          
           static let selectionShadowRadius: CGFloat = 10.0
           static let defaultShadowRadius: CGFloat = 3.0
       }
    
    
    var cachedPreferences: [String: Any] = [:]
    
    //    MARK: - Preferences
    
    var mainCanvasBackroundColor: NSColor? {
        set (newMainCanvasBackgroundColor) {
            userDefaults.set(newMainCanvasBackgroundColor, forKey: PreferenceKey.mainCanvasBackgroundColor.rawValue)
        }
        get {
            return userDefaults.color(forKey: PreferenceKey.mainCanvasBackgroundColor.rawValue)
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
    
    
    
    init() {
        registerDefaultPreferences()
        NotificationCenter.default.addObserver(self, selector: #selector(willChangePreferences(notification:)), name: .willChangePreferences, object: nil)
    }
    
    func registerDefaultPreferences() {
        userDefaults.register(defaults: self.defaults)
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
            case PreferenceKey.canvasSelectionWidth.rawValue:
                self.cachedPreferences[key] = canvasSelectionWidth
            case PreferenceKey.modelCanvasBackgroundColor.rawValue:
                self.cachedPreferences[key] = modelCanvasBackgroundColor
            default:
                print("Unrecognised preference key")
            }
        }
    }
    
    //     raises non-property-list exception
    func resetDefaults() {
        for (key, value) in self.defaults {
            if let color = value as? NSColor {
                userDefaults.set(color, forKey: key)
            } else {
                userDefaults.set(value, forKey: key)
            }
        }
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                        object: nil)
    }
    
    //     raises non-property-list exception
    func resetToCachedPreferences() {
        for (key, value) in self.cachedPreferences {
            if let color = value as? NSColor {
                userDefaults.set(color, forKey: key)
            } else {
                userDefaults.set(value, forKey: key)
            }
        }
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                        object: nil)
    }
    
    
    
}
