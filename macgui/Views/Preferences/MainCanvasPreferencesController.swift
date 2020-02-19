//
//  MainCanvasPreferencesController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/8/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MainCanvasPreferencesController: NSViewController {
   
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var didChangeSettings: Bool = false {
        didSet {
            NotificationCenter.default.post(name: UserDefaults.didChangeNotification,
                                                   object: nil)
        }
    }
    
    var willChangeInitiaGridColor: Bool = true
    var willChangeInitialBackgroundColor: Bool = true
    
    @IBAction func changeGridColor(_ sender: Any) {
        guard let colorWell = sender as? NSColorWell
            else { return }
        if willChangeInitiaGridColor {
            let userInfo = ["key": PreferenceKey.mainCanvasGridColor.rawValue]
                       NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitiaGridColor = false
        }
        let newColor = colorWell.color
        preferencesManager.mainCanvasGridColor = newColor
        didChangeSettings = true
    }
    
    @IBAction func changeBackgroundColor(_ sender: Any) {
        guard let colorWell = sender as? NSColorWell
                   else { return }
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.mainCanvasBackgroundColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialBackgroundColor = false
        }
        let newColor = colorWell.color
        preferencesManager.mainCanvasBackroundColor = newColor
        didChangeSettings = true
    }

}
