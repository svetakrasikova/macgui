//
//  File.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

// MARK: - Names for defaults

private let mainCanvasBackroundColorKey = "mainCanvasBackroundColor"
private let mainCanvasGridColorKey = "mainCanvasGridColor"
private let canvasSelectionWidthKey = "canvasSelectionWidth"
private let toolDimensionKey = "toolDimension"




class PreferencesManager {
    
    private let userDefaults = UserDefaults.standard
    

     //    MARK: - Preferences
     
    var mainCanvasBackroundColor: NSColor? {
        set (newMainCanvasBackgroundColor) {
            userDefaults.set(newMainCanvasBackgroundColor, forKey: mainCanvasBackroundColorKey)
        }
        get {
            return userDefaults.object(forKey: mainCanvasBackroundColorKey) as? NSColor
        }
    }
    
    var mainCanvasGridColor: NSColor? {
        set (newMainCanvasGridColor) {
            userDefaults.set(newMainCanvasGridColor, forKey: mainCanvasGridColorKey)
        }
        get {
            return userDefaults.object(forKey: mainCanvasGridColorKey) as? NSColor
        }
    }
    
    var canvasSelectionWidth: CGFloat? {
        get {
            return userDefaults.object(forKey: canvasSelectionWidthKey) as? CGFloat
        }
    }
    
    var toolDimension: CGFloat? {
           get {
               return userDefaults.object(forKey: toolDimensionKey) as? CGFloat
           }
       }
    
    
    init() {
        registerDefaultPreferences()
    }
    
    func registerDefaultPreferences() {
        let defaults =
            [mainCanvasBackroundColorKey : NSColor.white,
             mainCanvasGridColorKey  : NSColor.lightGray,
             canvasSelectionWidthKey: 5.0,
             toolDimensionKey: 50.0 ] as [String : Any]
        
        userDefaults.register(defaults: defaults)
    }
    

    
}
