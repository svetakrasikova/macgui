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
    static let didSelectToolController = Notification.Name("didSelectToolController")
    static let didSelectDeleteKey = Notification.Name("didSelectDeleteKey")
    static let didConnectTools = Notification.Name("didConnectTools")
    
}
