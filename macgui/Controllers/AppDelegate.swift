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

    let myCoreBridge: CoreBridge = CoreBridge()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        myCoreBridge.startCore()
        
        myCoreBridge.sendParser("x <- 3")
        myCoreBridge.sendParser("x")
        myCoreBridge.sendParser("y <- 30")
        myCoreBridge.sendParser("x + y")

    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }


}

