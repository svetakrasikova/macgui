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
                                                     object: nil)
          }
      }
    var willChangeInitialBackgroundColor: Bool = true
    
    @IBAction func changeCanvasBackgroundColor(_ sender: Any) {
        
        guard let colorWell = sender as? NSColorWell
                   else { return }
        if willChangeInitialBackgroundColor {
            let userInfo = ["key": PreferenceKey.modelCanvasBackgroundColor.rawValue]
            NotificationCenter.default.post(name: .willChangePreferences, object: nil, userInfo: userInfo)
            willChangeInitialBackgroundColor = false
        }
        let newColor = colorWell.color
        preferencesManager.modelCanvasBackgroundColor = newColor
        didChangeSettings = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
