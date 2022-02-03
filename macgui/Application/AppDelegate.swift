//
//  AppDelegate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/31/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    let coreBridge: CoreBridge = CoreBridge()
    let preferencesManager = PreferencesManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        coreBridge.startCore()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}


}

