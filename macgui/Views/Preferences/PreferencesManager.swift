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
    case mainCanvasBackgroundColor = "mainCanvasBackgroundColor"
    case mainCanvasGridColor = "mainCanvasGridColor"
    case canvasSelectionWidth = "canvasSelectionWidth"
    case canvasObjectDimension = "toolDimension"
    case modelCanvasBackgroundColor = "modelCanvasBackgroundColor"
}

class PreferencesManager {
    
    private let userDefaults = UserDefaults.standard
    
    let defaults =
        [PreferenceKey.mainCanvasBackgroundColor.rawValue : NSColor.white,
         PreferenceKey.mainCanvasGridColor.rawValue  : NSColor.gray,
         PreferenceKey.modelCanvasBackgroundColor.rawValue: NSColor.white,
         PreferenceKey.canvasSelectionWidth.rawValue: 5.0,
         PreferenceKey.canvasObjectDimension.rawValue: 50.0 ] as [String : Any]
    
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
    
    var toolDimension: CGFloat? {
           get {
            return userDefaults.object(forKey: PreferenceKey.canvasObjectDimension.rawValue) as? CGFloat
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
                self.cachedPreferences[key] = toolDimension
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
