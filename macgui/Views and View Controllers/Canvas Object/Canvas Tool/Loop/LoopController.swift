//
//  LoopController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/21/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers

class LoopController: NSViewController {
    
    weak var loop: Loop?
    weak var delegate: LoopControllerDelegate?
    
    @IBOutlet weak var indexPopup: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIndexPopUp()
    }
    
    
    func setUpIndexPopUp() {
        indexPopup.removeAllItems()
        indexPopup.addItems(withTitles: delegate?.activeLoopIndices() ?? [])
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: fittingSize.width, height: fittingSize.height)
    }

    
    @IBAction func saveClicked(_ sender: NSButton) {
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        dismiss(self)
    }
    
    
}

protocol LoopControllerDelegate: class {
    func activeLoopIndices() -> [String]
}
