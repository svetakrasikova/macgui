//
//  PreferencesViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/10/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager


    @IBAction func cancelPushed(_ sender: NSButton) {
        preferencesManager.resetToCachedPreferences()
        self.view.window?.close()
    }
    @IBAction func restorePreferencesPushed(_ sender: NSButton) {
        preferencesManager.resetDefaults()
        self.view.window?.close()
    }
    
    @IBAction func savePushed(_ sender: NSButton) {
        self.view.window?.close()
    }
    
    
}
