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
        self.title = "Loop Controller"
        setUpIndexPopup()
    }
    
    
    func setUpIndexPopup() {
        indexPopup.removeAllItems()
        indexPopup.addItems(withTitles: delegate?.allIndices() ?? [])
        setDataForIndexpopup()
    }
    
    func setDataForIndexpopup() {
        guard let delegate = self.delegate else { return }
        let all = delegate.allIndices()
        let active = delegate.activeIndices()
        if let index = loop?.index, let loopIndex = all.firstIndex(of: index) {
            indexPopup.selectItem(at: loopIndex)
            for title in active {
                indexPopup.item(withTitle: title)?.isEnabled = title != index ? false : true
            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: fittingSize.width, height: fittingSize.height)
        setDataForIndexpopup()
    }
    
    @IBAction func saveClicked(_ sender: NSButton) {
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        dismiss(self)
    }
}

protocol LoopControllerDelegate: AnyObject {
    func activeIndices() -> [String]
    func allIndices() -> [String]
}
