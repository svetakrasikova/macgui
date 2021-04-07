//
//  ModelPaletteItemController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelPaletteItemController: NSViewController {
    
    @IBOutlet weak var nameTextField: NSTextField!
    
    @objc dynamic weak var modelNode: ModelNode?
    
    private var observers = [NSKeyValueObservation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
    }
    
   
    
    func setUpTitle() {
        if let name = modelNode?.parameterName {
            self.title = name
            nameTextField.stringValue = name
        }
        addNodeNameChangeObservation()
    }
    
    func addNodeNameChangeObservation() {
        if let model = self.modelNode {
            observers = [
                model.observe(\ModelNode.parameterName, options: [.old, .new]) {(_, change) in
                    if let newTitle = change.newValue {
                        self.title = newTitle
                        self.view.needsDisplay = true
                    }
                }
            ]
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
    }
    
    
    
    @IBAction func saveClicked(_ sender: NSButton) {
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        dismiss(self)
    }
    
    
    @IBAction func cancelClicked(_ sender: NSButton) {
        let alert = NSAlert()
        alert.messageText = "Warning: you are about to discard unsaved changes to the model node."
        alert.addButton(withTitle: "Discard")
        alert.addButton(withTitle: "Cancel")
        let result = alert.runModal()
        switch result {
        case NSApplication.ModalResponse.alertFirstButtonReturn:
            if let node = self.modelNode {
                node.resetToDefaults()
            }
            dismiss(self)
        default: break
            
        }
    }
}
