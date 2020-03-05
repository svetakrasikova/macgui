//
//  Notifications.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/16/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

extension NSNotification.Name {
    
    static let didChangeMagnification = Notification.Name("didChangeMagnification")
    static let didSelectCanvasObjectController = Notification.Name("didSelectCanvasObjectController")
    static let didSelectDeleteKey = Notification.Name("didSelectDeleteKey")
    static let didConnectTools = Notification.Name("didConnectTools")
    static let didConnectNodes = Notification.Name("didConnectNodes")
    static let dismissToolSheet = Notification.Name("dismissToolSheet")
    static let didAddNewArrow = Notification.Name("didAddNewArrow")
    static let willChangePreferences = Notification.Name("willChangePreferences")
}
