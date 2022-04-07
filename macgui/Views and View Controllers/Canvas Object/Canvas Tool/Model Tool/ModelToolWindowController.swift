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
    
    
    func errorsDescription(errors: [Error]?) -> String? {
        var str = ""
        var errNum = 0
        if let errors = errors {
            for error in errors {
                errNum += 1
                switch error  {
                case ModelNodeChecker.ModelNodeError.distributionUndefined(let node):
                    str += "\(errNum). \(node.descriptiveName): undefined distribution.\n"
                case ModelNodeChecker.ModelNodeError.constantValueUndefined(let node):
                    str += "\(errNum). \(node.descriptiveName): undefined value.\n"
                case ModelNodeChecker.ModelNodeError.distributionParametersUndefined(let node, let num):
                    let numParamString = num > 1 ? "\(num) parameters" : "1 parameter"
                    str += "\(errNum). \(node.descriptiveName): \(numParamString) undefined.\n"
                default: str += "\(errNum). error description\n"
                }
            }
        }
        return str
    }
    
    @IBAction func checkModelClicked(_ sender: NSButton) {
//       validate the model tool and output the result in an alert, highlight the problematic nodes
        guard let model = self.tool else {
//            alert that the model is undefined
            return
        }
        if let isValid = model.isValid() {
            let validityStatement = isValid ? "Model is valid"  : "Model is invalid"
            NSAlert.runInfoDialog(message: validityStatement, infoText: errorsDescription(errors: model.errors))
        } else {
//            run alert that the model is empty
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
