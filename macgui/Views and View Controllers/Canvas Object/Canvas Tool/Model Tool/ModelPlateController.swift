//
//  PlateController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/5/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelPlateController: LoopController {
    
    
    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var valueTopConstraint: NSLayoutConstraint!
    var boxHeightConstraint = NSLayoutConstraint()
    @IBOutlet weak var valueStack: NSStackView!
    
    @IBOutlet weak var helpField: NSTextField!
    
    var plate: Plate? {
        self.loop as? Plate
    }
    
    @objc dynamic var enableValueEdit: Bool = true
    @objc dynamic var enableIteratorRange: Bool = true
    
    private var observers =  [NSKeyValueObservation]()
    
    func setDataObserver(){
        guard let plate = self.plate else { return }
        guard let matricesCount = self.matricesCount else { return }
        self.observers = [
            plate.observe(\Plate.upperRange, options: [.initial]) {(plate, _) in
                self.setHelpText()
                self.view.needsDisplay = true
            },
            plate.observe(\Plate.rangeType, options: [.old, .new]) {(plate, change) in
                switch change.newValue {
                case Plate.IteratorRange.number.rawValue:
                    if change.oldValue != Plate.IteratorRange.number.rawValue {
                        plate.upperRange = 1
                    }
                case Plate.IteratorRange.numberMatrices.rawValue:
                    plate.upperRange = matricesCount
                default: plate.upperRange = -1
                }
            }
        ]
    }
    
    @IBOutlet weak var rangePopup: NSPopUpButton!
    
    var matricesCount: Int?
    
    func setUpperRangeToNumMatrices() {
        guard let plate = self.plate else { return }
        guard let matricesCount = self.matricesCount else { return }
        plate.upperRange = matricesCount
    }
    
    
    var isEmbeddedInOuterLoopWithMatrixRange: Bool {
        guard let plate = self.plate else { return false }
        if let outerPlate = plate.outerLoop as? Plate {
            return outerPlate.rangeType == Plate.IteratorRange.numberMatrices.rawValue
        }
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataObserver()
        setRangePopup()
        setHelpText()
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let plate = self.plate else { return }
        setValue(index: plate.rangeType)
    }
    
    func setRangePopup() {
        guard let plate = self.plate else { return }
        let selectedIndex = plate.rangeType
        if let numMatrices = self.matricesCount {
            if numMatrices > 0 {
                if isEmbeddedInOuterLoopWithMatrixRange {
                    for i in 0..<rangePopup.numberOfItems {
                        let isNumChar: Bool = i == Plate.IteratorRange.numberChar.rawValue
                        let isNumTaxa: Bool = i == Plate.IteratorRange.numberTaxa.rawValue
                        rangePopup.item(at: i)?.isEnabled = isNumChar || isNumTaxa ? true : false
                    }
                } else {
                    for i in 0..<rangePopup.numberOfItems {
                        let isNum: Bool = i == Plate.IteratorRange.number.rawValue
                        let isNumMatrices: Bool = i == Plate.IteratorRange.numberMatrices.rawValue
                        rangePopup.item(at: i)?.isEnabled = isNum || isNumMatrices ? true : false
                    }
                }
                
            } else {
                for i in 0..<rangePopup.numberOfItems {
                    let isNum: Bool = i == Plate.IteratorRange.number.rawValue
                    rangePopup.item(at: i)?.isEnabled = isNum ? true : false
                }
            }
            
            if rangePopup.item(at: selectedIndex)!.isEnabled {
                rangePopup.selectItem(at: selectedIndex)
            } else {  print("Error in setRangePopup") }
            
            
        }
    }
    
    func setHelpText() {
        guard let plate = self.plate else { return }
        var str = ""
        switch plate.rangeType {
        case Plate.IteratorRange.number.rawValue:
            str = helpTextForNumPlates()
        case Plate.IteratorRange.numberMatrices.rawValue:
            str = helpTextForNumMatricesPlates()
        case Plate.IteratorRange.numberChar.rawValue:
            str = helpTextForEmbeddedCharPlates(index: plate.outerLoop?.index)
        case Plate.IteratorRange.numberTaxa.rawValue:
            str = helpTextForEmbeddedTaxaPlates(index: plate.outerLoop?.index)
        default: break
        }
        helpField.stringValue = str
    }
    
    func helpTextForNumPlates() -> String {
        guard let plate = self.plate else { return "" }
        return plate.upperRange == 1 ?
            "This plate iterates over a range of one. Consider changing the range for this plate, or simply deleting the plate."
            :
            "This plate iterates over a range of \(plate.upperRange)."
        
    }
    
    func helpTextForNumMatricesPlates() -> String {
        guard let matricesCount = self.matricesCount
        else {
            return ""
        }
        let numMatricesStr = matricesCount == 1 ? "\(matricesCount) matrix" : "\(matricesCount) matrices"
        return "This plate will range over the number of character matrices attached to the Model Tool. Currently, the Model Tool contains \(numMatricesStr)."
        
    }
    
    func helpTextForEmbeddedCharPlates(index: String?) -> String {
        guard let index = index
        else {
            return ""
        }
        return "This plate ranges over the number of characters in the \(index)-th character matrix attached to the Model Tool."
        
    }
    
    func helpTextForEmbeddedTaxaPlates(index: String?) -> String {
        guard let index = index else { return "" }
        return "This plate ranges over the number of taxa in the \(index)-th character matrix attached to the Model Tool."
    }
    
    
    
    @IBAction func selectRange(_ sender: NSPopUpButton) {
        setValue(index: sender.indexOfSelectedItem)
        setHelpText()
    }
    
    func setValue(index: Int) {
        box.removeConstraint(boxHeightConstraint)
        let hideValue = index != Plate.IteratorRange.number.rawValue
        toggleValue(hide: hideValue)
        addHeightConstraintToBox()
    }
    
    func toggleValue(hide: Bool) {
        valueStack.isHidden = hide
        valueTopConstraint.constant = hide ? -20 : 15
    }
    
    func addHeightConstraintToBox() {
        
        boxHeightConstraint    = NSLayoutConstraint(item: box as Any,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                    multiplier: 1,
                                                    constant: box.fittingSize.height)
        box.addConstraint(boxHeightConstraint)
    }
    
}
