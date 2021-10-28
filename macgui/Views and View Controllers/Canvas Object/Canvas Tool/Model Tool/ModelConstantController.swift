//
//  ModelConstantController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelConstantController: ModelPaletteItemController {

    
 
    @IBOutlet weak var valuePopup: NSPopUpButton!
    @IBOutlet weak var valueTextField: NSTextField!
    @IBOutlet weak var popupStack: NSStackView!
    @IBOutlet weak var textFieldStack: NSStackView!
    @IBOutlet var arrayController: NSArrayController!
    
    
    @objc dynamic var valueData: [TypeBundle] {
        var bundles: [TypeBundle] = []
        guard let modelNode = modelNode else { return bundles }
        guard let constant = modelNode.node as? PaletteVariable
        else { return bundles }
        guard let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model
        else { return bundles }
        if constant.type == MatrixDataType.AbstractHomologousDiscreteCharacterData.rawValue || constant.superclasses.contains(MatrixDataType.AbstractHomologousDiscreteCharacterData.rawValue) {
            for dm in model.dataMatrices {
                bundles.append(TypeBundle(dataMatrix: dm))
            }
        } else {
            var data: [NumberList] = []
            for l in model.numberData.numberLists {
                if constant.type == l.type.rawValue && constant.dimension == l.dimension {
                    data.append(l)
                }
            }
            guard !data.isEmpty else { return [] }
            let numberList = try! NumberList.flattenLists(lists: data)
            bundles =  numberList.numberBundles
        }
        return bundles
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValueSelector()
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 250, height: fittingSize.height)
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
            valueTextField.formatter = onlyNumbersFormatter
        default:
            displayValueSelector(hideCombo: true)
        }
        
    }
    
    func displayValueSelector(hideCombo: Bool) {
            textFieldStack.isHidden = hideCombo
            popupStack.isHidden = !hideCombo
    }
    
   
}
