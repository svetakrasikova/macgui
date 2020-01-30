//
//  InfoInspector.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InfoInspector: NSViewController {

    weak var delegate: InfoInspectorDelegate?
    
    @IBOutlet weak var dataType: NSTextField!
    
    @IBOutlet weak var numberOfTaxa: NSTextField!
    
    @IBOutlet weak var numberOfCharacters: NSTextField!
    
    @IBOutlet weak var numberOfExcludedTaxa: NSTextField!
    
    @IBOutlet weak var numberOfExcludedCharacters: NSTextField!
    
    @IBOutlet weak var sequencesAligned: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.setInfoInspectorValues(inspector: self)
    }
    
}

protocol InfoInspectorDelegate: class {
    func setInfoInspectorValues(inspector: InfoInspector)
}
