//
//  ModelToolWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolWindowController: NSWindowController {
    
    weak var tool: ToolObject?
    @IBOutlet weak var zoom: NSPopUpButton!
    
        var canvas: NSSplitViewItem? {
            if let canvas = (contentViewController as? ModelToolViewController)?.splitViewItems[1] {
                return canvas
            }
            return nil
        }
    
        var palette: NSSplitViewItem? {
            if let palette = (contentViewController as? ModelToolViewController)?.splitViewItems[0] {
                return palette
            }
            return nil
        }
    
        @IBAction func collapseExpandSidebar(_ sender: NSButton) {
               guard let  palette = self.palette else {
                   return
               }
               if palette.isCollapsed {
                   palette.isCollapsed = false
               } else {
                   palette.isCollapsed = true
               }
           }
    
    @objc func changeModelZoomTitle(notification: Notification){
        let userInfo = notification.userInfo! as! [String : Float]
        let magnification = userInfo["magnification"]!/0.015
        let title = String(format:"%.0f", magnification)
        zoom.setTitle("\(title)%")
    }
    

    override func windowDidLoad() {
        super.windowDidLoad()

         NotificationCenter.default.addObserver(self,
                                                      selector: #selector(changeModelZoomTitle(notification:)),
                                                      name: .didChangeMagnification,
                                                      object: nil)
    }
    
}
