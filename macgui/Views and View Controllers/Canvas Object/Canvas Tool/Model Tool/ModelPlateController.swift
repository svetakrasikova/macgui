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
    
    var plate: Plate {
        self.loop as! Plate
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
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
