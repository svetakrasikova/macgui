//
//  PaupDistanceOptionsViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupDistanceOptionsViewController: NSViewController {
    
    @objc dynamic var options: PaupOptions?
    
    @IBOutlet var DistanceOptionsBox: NSBox!
    @IBOutlet var Shape: NSStackView!
    @IBOutlet var RemoveFreq: NSStackView!
    @IBOutlet var EstimFreq: NSStackView!
    
    @IBOutlet var ShapeTopConstraint: NSLayoutConstraint!
    @IBOutlet var RemoveFreqTopConstraint: NSLayoutConstraint!
    @IBOutlet var EstimFreqTopConstraint: NSLayoutConstraint!
    
    var BoxHeightConstraint = NSLayoutConstraint()
    
    var isDistanceWithoutShape: Bool {
        return options?.dsDistance == PaupOptions.DSDistance.abs.rawValue ||
        options?.dsDistance == PaupOptions.DSDistance.P.rawValue || options?.dsDistance == PaupOptions.DSDistance.logDet.rawValue
    }
    
    var isRemoveFreqEqual: Bool {
        return options?.dsRemoveFreq == PaupOptions.DSRemoveFreq.equal.rawValue
    }
   
    override func viewDidLayout() {
        super.viewDidLayout()
        if let windowController = view.window?.windowController as? TablessWindowController,  let parsimonyTool = windowController.tool as? Parsimony {
            self.options = parsimonyTool.options
            
        }
    }
    
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let options = self.options {
            setRates(options.dsRates)
            setPinvar(isPinvarNone: options.dsPinvar == PaupOptions.DSPinvar.none.rawValue)
        }
    }
    
    @IBAction func selectDistance(_ sender: NSPopUpButton) {
        let isGammaRates = options?.dsRates == PaupOptions.DSRates.gamma.rawValue
        switch sender.indexOfSelectedItem {
        case PaupOptions.DSDistance.P.rawValue: toggleShape(hide: isGammaRates)
        case PaupOptions.DSDistance.abs.rawValue: toggleShape(hide: isGammaRates)
        case PaupOptions.DSDistance.logDet.rawValue: toggleShape(hide: isGammaRates)
        default: toggleShape(hide: false)
        }
    }
    
   
    @IBAction func setPropotionInvar(_ sender: NSComboBox) {
        setPinvar(isPinvarNone: sender.indexOfSelectedItem == 0)
    }
    
    func setPinvar(isPinvarNone: Bool) {
        toggleRemoveFreq(hide: isPinvarNone)
        toggleEstFreq(hide: isPinvarNone || isRemoveFreqEqual)
    }
    
    
    func toggleRemoveFreq(hide: Bool) {
        DistanceOptionsBox.removeConstraint(BoxHeightConstraint)
        RemoveFreq.isHidden = hide
        RemoveFreqTopConstraint.constant = hide ? -20 : 15
        addHeightConstraintToBox()
      
        
    }
    
    @IBAction func selectRemoveFreq(_ sender: NSPopUpButton) {
        let hideEstFreqStack = sender.indexOfSelectedItem == PaupOptions.DSRemoveFreq.equal.rawValue
        toggleEstFreq(hide: hideEstFreqStack)
        
    }
    
    func toggleEstFreq(hide: Bool) {
        DistanceOptionsBox.removeConstraint(BoxHeightConstraint)
        EstimFreq.isHidden = hide
        EstimFreqTopConstraint.constant = hide ? -20 : 15
        addHeightConstraintToBox()
    }
    
    @IBAction func selectRates(_ sender: NSPopUpButton) {
        setRates(sender.indexOfSelectedItem)
    }
    
    func setRates(_ rates: Int) {
        toggleShape(hide: isDistanceWithoutShape || rates == PaupOptions.DSRates.equal.rawValue)
    }
    
    func toggleShape(hide: Bool) {
        DistanceOptionsBox.removeConstraint(BoxHeightConstraint)
        Shape.isHidden = hide
        ShapeTopConstraint.constant = hide ? -20 : 15
        addHeightConstraintToBox()
       
    }
    
    
    func addHeightConstraintToBox() {
        BoxHeightConstraint    = NSLayoutConstraint(item: DistanceOptionsBox as Any,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                    multiplier: 1,
                                                    constant: DistanceOptionsBox.fittingSize.height)
        DistanceOptionsBox.addConstraint(BoxHeightConstraint)
    }
    
    
}
