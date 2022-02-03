//
//  ModelDeterministicVariableController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/24/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelDeterministicVariableController: ModelVariableController {
    
    override var distributions: [Distribution] {
        guard let delegate = self.delegate, let modelNode = self.modelNode else { return [] }
        return delegate.getFunctionsForParameter(modelNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
