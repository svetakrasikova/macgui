//
//  ModelConstantController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelConstantController: ModelPaletteItemController {

    @IBOutlet weak var valueComboBox: NSComboBox!
    
    
    @objc dynamic var valueData: [NumberList] {
        guard let modelNode = modelNode, modelNode.nodeType == .randomVariable else { return [] }
        guard let variable = modelNode.node as? PaletteVariable else { return [] }
        var data: [NumberList] = []
        if let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model {
            for l in model.numberData.numberLists {
                if variable.type == l.type.rawValue && variable.dimension == l.dimension {
                    data.append(l)
                }
            }
        }
        
        return data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComboBoxFormatter()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    func setComboBoxFormatter() {
        let onlyNumbersFormatter = OnlyNumbersFormatter()
        onlyNumbersFormatter.minimumFractionDigits = 2
        valueComboBox.formatter = onlyNumbersFormatter
    }

    
}
