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
    var parameters: [PaletteCategory]?
    @IBOutlet weak var zoom: NSPopUpButton!
    @IBOutlet weak var share: NSButton!
    
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
        // validate the model tool and output the result in an alert, highlight the problematic nodes
        guard let model = self.tool else { return }
        if let isValid = model.isValid() {
            let validityStatement = isValid ? "Model is valid."  : "Model is invalid."
            var infoText = ""
            var errorLog = [String]()
            if isValid {
                infoText = "All nodes are complete."
            } else {
                if let errors = model.errors {
                    infoText = "Model traversal found \(errors.count) issue(s)."
                    errorLog = errorsDescription(errors: errors)
                } else {
                    infoText = "Model traversal found unconnected nodes."
                }
            }
            NSAlert.runInfoDialog(message: validityStatement, infoText: infoText, logOfErrors: errorLog)
        } else {
            NSAlert.runInfoDialog(message: "Model is empty", infoText: nil)
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
