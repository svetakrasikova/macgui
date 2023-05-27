//
//  ModelNotificationActionHandler.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/27/22.
//  Copyright © 2022 Svetlana Krasikova. All rights reserved.
//

import Foundation


class ModelNotificationActionHandler {
    
    static let sharedNotificationActionHandler = ModelNotificationActionHandler()
    
    weak var delegate: ModelNotificationDelegate?
    
    private init() {
    }
    
    func showIssues() {
        guard let delegate = self.delegate else { return }
        delegate.showIssues()
   }
}


protocol ModelNotificationDelegate: AnyObject {
    func showIssues()
}
