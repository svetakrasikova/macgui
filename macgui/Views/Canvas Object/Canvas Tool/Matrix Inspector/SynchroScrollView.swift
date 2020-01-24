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
        synchronizedScrollView?.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(synchronizedViewContentBoundsDidChange), name: NSView.boundsDidChangeNotification, object:  synchronizedScrollView?.contentView)
    }
    
    func stopSynchronising(){
        if let synchronizedScrollView = self.synchronizedScrollView {
            NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: synchronizedScrollView.contentView)
        }
    }
    
  
    
    @objc func synchronizedViewContentBoundsDidChange(notification: NSNotification){
        guard let changedContentView: NSClipView = notification.object as? NSClipView
            else { return }
        let changedBoundsOrigin = changedContentView.documentVisibleRect.origin
        let currentOffset: NSPoint  = self.contentView.bounds.origin
        var newOffset: NSPoint = currentOffset
        newOffset.y = changedBoundsOrigin.y
        guard newOffset != currentOffset else { return }
        self.contentView.scroll(to: newOffset)
        self.reflectScrolledClipView(self.contentView)
    }
}
