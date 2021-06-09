//
//  PlateController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/5/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelPlateController: LoopController {
 
//    todo: set the range popup when the view is presented
//    disable the menu items in the popup that are not available if there are no matrix data or if the loop is not embedded
//     set the help text and update it on select range
//      update help and toggle value and update range selection if matrices are removed from the model tool
    
    
    @IBOutlet weak var box: NSBox!
    @IBOutlet weak var valueTopConstraint: NSLayoutConstraint!
    var boxHeightConstraint = NSLayoutConstraint()
    @IBOutlet weak var valueStack: NSStackView!
    
    @IBOutlet weak var helpField: NSTextField!
    var plate: Plate? {
        self.loop as? Plate
    }
    
    var matricesCount: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
    }
    
//    func setUpIndexPopup() {
//        indexPopup.removeAllItems()
//        indexPopup.addItems(withTitles: delegate?.allIndices() ?? [])
//        setDataForIndexpopup()
//    }
//
//    func setDataForIndexpopup() {
//        guard let delegate = self.delegate else { return }
//        let all = delegate.allIndices()
//        let active = delegate.activeIndices()
//        if let index = loop?.index, let loopIndex = all.firstIndex(of: index) {
//            indexPopup.selectItem(at: loopIndex)
//            for title in active {
//                indexPopup.item(withTitle: title)?.isEnabled = title != index ? false : true
//            }
//        }
//    }
    
    func setHelpText(_ rangeType: Int) {
        guard let plate = self.plate else { return }
        let isEmbedded: Bool = plate.outerLoop != nil
        var index: String?
        var isEmbeddedInOuterLoopWithMatrixRange = false
        if let outerPlate = plate.outerLoop as? Plate {
            isEmbeddedInOuterLoopWithMatrixRange = outerPlate.rangeType == Plate.IteratorRange.numberMatrices.rawValue
            index = outerPlate.index
        }
        guard let matricesCount = self.matricesCount else { return }
        switch rangeType {
        case Plate.IteratorRange.number.rawValue:
            helpField.stringValue = plate.upperRange == 1 ?
                "This plate iterates over a range of one. Consider changing the range for this plate, or simply deleting the plate."
                :
                "This plate iterates over a range of \(plate.upperRange)."
        case Plate.IteratorRange.numberMatrices.rawValue:
            var str = "This plate will range over the number of character matrices attached to the Model Tool. "
            str = matricesCount > 0 ?
                str + "Currently, the Model Tool contains \(matricesCount) matrix/ces."
                :
                str + "Currently, the Model Tool does not have data matrices attached to it."
            helpField.stringValue = str
        case Plate.IteratorRange.numberChar.rawValue:
            var str = "This plate will range over the number of characters in a character matrix attached to the Model Tool. "
            if matricesCount == 0 {
                str += "Currently, the Model Tool does not have data matrices attached to it."
            } else {
                str = !isEmbedded ? str + "Currently, this plate is not contained by any plates that could be configured to range over character matrices."
                    :
                    helpTextForEmbeddedPlates(isEmbeddedInOuterLoopWithMatrixRange, str: str, index: index)
                
            }
            helpField.stringValue = str
        default: break
        }
    }
    
    func helpTextForEmbeddedPlates(_ isEmbeddedInOuterLoopWithMatrixRange: Bool, str: String, index: String?) -> String {
        guard isEmbeddedInOuterLoopWithMatrixRange, let index = index else { return "" }
        let text = !isEmbeddedInOuterLoopWithMatrixRange ?
            str + "Currently, this plate is not contained by a plate that ranges over character matrices."
            :
            "This plate ranges over the number of characters in the \(index)-th character matrix attached to the Model Tool."
        
        return text
        
    }
    
    
    
    @IBAction func selectRange(_ sender: NSPopUpButton) {
        box.removeConstraint(boxHeightConstraint)
        let hideValue = sender.indexOfSelectedItem != Plate.IteratorRange.number.rawValue
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
