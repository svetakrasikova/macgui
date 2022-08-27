//
//  AppDelegate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/31/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa
import UserNotifications

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    let coreBridge: CoreBridge = CoreBridge()
    let preferencesManager = PreferencesManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UNUserNotificationCenter.current().delegate = self
        coreBridge.startCore()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == ModelToolWindowController.NotificationID.ValidityCheckErrors.rawValue {
            
            switch response.actionIdentifier {
            case ModelToolWindowController.NotificationID.ShowIssues.rawValue:
                ModelNotificationActionHandler.sharedNotificationActionHandler.showIssues()                
            default:
                break
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.list, .sound])
    }
}
