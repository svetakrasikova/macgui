//
//  SynchroScrollView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/14/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class SynchroScrollView: NSScrollView {
    
    var synchronizedScrollView: NSScrollView?

    func setSynchronizedScrollView(view: NSScrollView) {
        self.stopSynchronising()
        self.synchronizedScrollView = view;
        let syncronizedContentView = synchronizedScrollView?.contentView
        syncronizedContentView?.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(synchronizedViewContentBoundsDidChange), name: NSView.boundsDidChangeNotification, object: syncronizedContentView)
    }
    
    func stopSynchronising(){
        
    }
    
    @objc func synchronizedViewContentBoundsDidChange(notification: NSNotification){
        let changedContentView: NSClipView = notification.object as! NSClipView
        let changedBoundsOrigin = changedContentView.documentVisibleRect.origin
        let curOffset: NSPoint  = self.contentView.bounds.origin
        var newOffset: NSPoint = curOffset
        newOffset.y = changedBoundsOrigin.y
        
//        if NSEqualPoints(changedBoundsOrigin, curOffset)
        
        
    }
}
