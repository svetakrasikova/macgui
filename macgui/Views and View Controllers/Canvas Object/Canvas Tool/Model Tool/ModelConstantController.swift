//
//  ModelConstantController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelConstantController: ModelPaletteItemController {

    @IBOutlet weak var constantValueTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldFormatter()
    }
    
    func setTextFieldFormatter() {
        let onlyNumbersFormatter = OnlyNumbersFormatter()
        onlyNumbersFormatter.minimumFractionDigits = 2
        constantValueTextField.formatter = onlyNumbersFormatter
    }
    
}
