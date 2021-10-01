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
    @IBOutlet weak var valuePopup: NSPopUpButton!
    
    @IBOutlet weak var popupStack: NSStackView!
    @IBOutlet weak var comboStack: NSStackView!
    @IBOutlet var arrayController: NSArrayController!
    
    @objc dynamic var valueData: [NumberList] {
        guard let modelNode = modelNode else { return [] }
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
        setValueSelector()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        arrayController.content = valueData
        
    }
    
    func setValueSelector() {
        guard let modelNode = modelNode, let variable = modelNode.node as? PaletteVariable
        else { return }
        switch variable.dimension {
        case 0:
            displayValueSelector(hideCombo: false)
            let onlyNumbersFormatter = NumberFormatter()
            onlyNumbersFormatter.minimumFractionDigits = 2
            valueComboBox.formatter = onlyNumbersFormatter
        default:
            displayValueSelector(hideCombo: true)
        }
        
    }
    
    func displayValueSelector(hideCombo: Bool) {
            comboStack.isHidden = hideCombo
            popupStack.isHidden = !hideCombo
    }
    
   
}
