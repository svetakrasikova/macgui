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
    @IBOutlet weak var numberBranchesTopConstraint: NSLayoutConstraint!
    var boxHeightConstraint = NSLayoutConstraint()
    @IBOutlet weak var valueStack: NSStackView!
    @IBOutlet weak var numberBranchesStack: NSStackView!
    
    @IBOutlet weak var helpField: NSTextField!
    
    @objc dynamic var plate: Plate? {
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
                case Plate.IteratorRange.numberBranches.rawValue:
                    plate.setNumBranchesUpperRange()
                default:
                    plate.upperRange = -1
                    print("Not an acceptable upper range!")
                }
            },
            plate.observe(\Plate.numBranchesFunc, options: [.old, .new]) {(plate, change) in
                plate.setNumBranchesUpperRange()
                self.view.needsDisplay = true
            },
            plate.observe(\Plate.assignedMatrix, options: [.old, .new]) {(plate, change) in
                plate.setNumBranchesUpperRange()
                self.view.needsDisplay = true
            },
        ]
    }
    
    
   
    
    @IBOutlet weak var rangePopup: NSPopUpButton!
    
    @objc dynamic var matrices: [DataMatrix]?
    
    
    
    var matricesCount: Int? {
        return matrices?.count
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
        setRangePopup()
        setHelpText()
        setAdditionalParameters(index: plate.rangeType)
    }
    
    func setRangePopup() {
        guard let plate = self.plate else { return }
        let selectedIndex = plate.rangeType
        if let numMatrices = self.matricesCount {
            if numMatrices > 1 {
                if isEmbeddedInOuterLoopWithMatrixRange {
                    for i in 0..<rangePopup.numberOfItems {
                        let isNum: Bool = i == Plate.IteratorRange.number.rawValue
                        let isNumChar: Bool = i == Plate.IteratorRange.numberChar.rawValue
                        let isNumTaxa: Bool = i == Plate.IteratorRange.numberTaxa.rawValue
                        let isNumBranch: Bool = i == Plate.IteratorRange.numberBranches.rawValue
                        rangePopup.item(at: i)?.isEnabled = isNum || isNumChar || isNumTaxa || isNumBranch ? true : false
                    }
                } else {
                    for i in 0..<rangePopup.numberOfItems {
                        let isNum: Bool = i == Plate.IteratorRange.number.rawValue
                        let isNumMatrices: Bool = i == Plate.IteratorRange.numberMatrices.rawValue
                        let isNumBranch: Bool = i == Plate.IteratorRange.numberBranches.rawValue
                        rangePopup.item(at: i)?.isEnabled = isNum || isNumMatrices || isNumBranch  ? true : false
                    }
                }
                
            } else if numMatrices == 1 {
                rangePopup.itemArray.forEach {$0.isEnabled = true }
                
            } else {
                for i in 0..<rangePopup.numberOfItems {
                    let isNum: Bool = i == Plate.IteratorRange.number.rawValue
                    rangePopup.item(at: i)?.isEnabled = isNum ? true : false
                }
            }
            
            if rangePopup.item(at: selectedIndex)!.isEnabled {
                rangePopup.selectItem(at: selectedIndex)
            } else
            {
                print("Error in setRangePopup")
                
            }
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
        case Plate.IteratorRange.numberBranches.rawValue:
            str = helpTextForNumberBranchesPlates()
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
    
    func helpTextForNumberBranchesPlates() -> String {
        return "This plate ranges over the number of branches in the selected matrix."
    }
    

    @IBAction func selectRange(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem == Plate.IteratorRange.numberBranches.rawValue {
            plate?.assignedMatrix = self.matrices?.first
        }
        setAdditionalParameters(index: sender.indexOfSelectedItem)
        setHelpText()
    }
    
    func setAdditionalParameters(index: Int) {
        box.removeConstraint(boxHeightConstraint)
        let hideValue = index != Plate.IteratorRange.number.rawValue
        toggleValue(hide: hideValue)
        let hideNumberBranches = index != Plate.IteratorRange.numberBranches.rawValue
        toggleNumberBranches(hide: hideNumberBranches)
        addHeightConstraintToBox()
    }
    
    func toggleValue(hide: Bool) {
        valueStack.isHidden = hide
        valueTopConstraint.constant = hide ? -20 : 15
    }
    
    func toggleNumberBranches(hide: Bool) {
        numberBranchesStack.isHidden = hide
        numberBranchesTopConstraint.constant = hide ? -20 : 15
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
