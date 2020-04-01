//
//  ModelToolWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelToolWindowController: NSWindowController {
    
    weak var tool: Model?
    var parameters: [Parameter]?
    @IBOutlet weak var zoom: NSPopUpButton!
    @IBOutlet weak var share: NSButton!
    
    @IBAction func shareClicked(_ sender: NSButton) {
        //show a picker pop up menu with the export and import option
        let model = "This is the model we are working on"
        let picker = NSSharingServicePicker(items: [model])
        picker.delegate = self
        picker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
    }
    
    weak var canvas: NSSplitViewItem? {
            if let canvas = (contentViewController as? ModelToolViewController)?.splitViewItems[1] {
                return canvas
            }
            return nil
        }
    
        weak var palette: NSSplitViewItem? {
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


extension ModelToolWindowController: NSSharingServicePickerDelegate {
    
    
    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
         
        guard let image = NSImage(named: "AppIcon") else {
                   return proposedServices
               }
        var share = proposedServices
        
        let copyModelService = NSSharingService(title: "Copy model", image: image, alternateImage: image, handler: {
            if let text = items.first as? String {
//                TODO: implement export model
                print("Copy model is not implemented yet.")
            }
        })

        share.insert(copyModelService, at: 0)
        
        return share
        
    }
}
