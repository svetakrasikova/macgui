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



    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        let myCoreBridge: CoreBridge = CoreBridge()
        myCoreBridge.startCore()
        myCoreBridge.printTest()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

