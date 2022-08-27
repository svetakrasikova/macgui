//
//  ModelToolWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/29/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa
import UserNotifications
import Foundation
import UserNotifications

class ModelToolWindowController: NSWindowController {
    
    enum NotificationID: String {
        case ValidityCheckNotificationID, ValidityCheckErrors, ShowIssues
    }
    
    weak var tool: Model?
    var parameters: [PaletteCategory]?
    @IBOutlet weak var zoom: NSPopUpButton!
    @IBOutlet weak var share: NSButton!
    let un = UNUserNotificationCenter.current()
    
    @IBAction func shareClicked(_ sender: NSButton) {
        //show a picker pop up menu with the export and import option
        let model = "Model"
        let picker = NSSharingServicePicker(items: [model])
        picker.delegate = self
        picker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
    }
    
    
    func errorsDescription(errors: [Error]) -> [String] {
        var errorDescriptions = [String]()
        for error in errors {
            switch error  {
            case ModelNodeChecker.ModelNodeError.distributionUndefined(let node):
                errorDescriptions.append("\(node.descriptiveName) has undefined distribution.")
            case ModelNodeChecker.ModelNodeError.constantValueUndefined(let node):
                errorDescriptions.append("\(node.descriptiveName) has undefined value.")
            case ModelNodeChecker.ModelNodeError.distributionParametersUndefined(let node, let num):
                let numParamString = num > 1 ? "\(num) undefined parameters" : "undefined 1 parameter"
                errorDescriptions.append("\(node.descriptiveName) has \(numParamString).")
            default: break
            }
        }
        return errorDescriptions
    }
    
    @IBAction func checkModelClicked(_ sender: NSButton) {
        // validate the model tool, show the succeed message like in Xcode build or fail message, possibly highlight the problematic nodes, add a button to see the log of active issues
        guard let model = self.tool else { return }
        if let isValid = model.isValid() {
            validityCheckNotification(isValid: isValid)
        } else {
            NSAlert.runInfoAlert(message: "Model is empty.", infoText: nil)
        }
        
    }
    
    func validityCheckNotification(isValid: Bool) {
        un.requestAuthorization(options: [.alert, .sound, ], completionHandler: {(authorized, error) in
            if authorized {
                print("Authorized")
            } else if !authorized {
                print("Not authorized")
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        
        un.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.body = isValid ? "Model Check Succeeded"  : "Model Check Failed"
                content.sound = .default
              
                let id = NotificationID.ValidityCheckNotificationID.rawValue
                content.categoryIdentifier = NotificationID.ValidityCheckErrors.rawValue
                
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                if !isValid {
                    let showIssues = UNNotificationAction(identifier: NotificationID.ShowIssues.rawValue, title: "Show Issues", options: [])
                    let category = UNNotificationCategory(identifier: NotificationID.ValidityCheckErrors.rawValue, actions: [showIssues], intentIdentifiers: [], options: [])
                    self.un.setNotificationCategories([category])
                }
                
                self.un.add(request) {(error) in
                    if error != nil { print(error?.localizedDescription as Any)}
                }
            }
            
        }
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
        
        guard let image = NSImage(named: "BlankDocument") else {
            return proposedServices
        }
        var share = proposedServices
        
        let copyModelService = NSSharingService(title: "Export", image: image, alternateImage: image, handler: {
            if let text = items.first as? String {
                // TODO: implement export model
                print("\(text)")
            }
        })
        
        share.insert(copyModelService, at: 0)
        
        return share
        
    }
}
