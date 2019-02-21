//
//  ControllerExtensions.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/20/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

extension NSArrayController {
    
    /**
     Delete selected Analysis objects. Show a control panel to confirm the operation.
     
     - parameter toRemove: array of selected Analysis objects
    
     */
    func removeSelectedAnalyses(sender: AnyObject, toRemove: [Analysis]){
        //self.remove(contentsOf: toRemove)
        let alert = NSAlert()
        alert.messageText = "Warning: Delete Analysis"
        if toRemove.count > 1 {
            alert.informativeText = "You are about to delete \(toRemove.count) analyses, with all their associated information. Do you wish to continue with this operation?"
        } else {
            alert.informativeText = "You are about to delete an analysis, with all of its associated information. Do you wish to continue with this operation?"
        }
        
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        
        let window = sender.window!
        alert.beginSheetModal(for: window, completionHandler: { (response) -> Void in
            switch response {
            case NSApplication.ModalResponse.alertFirstButtonReturn:
                self.remove(contentsOf: toRemove)
            default: break
            }
        })
        

    }
}
