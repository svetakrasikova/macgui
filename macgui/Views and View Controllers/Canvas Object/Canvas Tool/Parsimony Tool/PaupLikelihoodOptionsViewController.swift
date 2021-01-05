//
//  PaupLikelihoodOptionsViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/15/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupLikelihoodOptionsViewController: NSViewController {

    @objc dynamic var options: PaupOptions?
    
    @IBOutlet var TratioSelector: NSStackView!
    @IBOutlet var RateMatrixSelector: NSStackView!
    @IBOutlet var RateMatrix: NSGridView!
    @IBOutlet var BaseFreqMatrix: NSGridView!
    @IBOutlet var substitutionModelParamsBox: NSBox!
    @IBOutlet var TratioTopConstraint: NSLayoutConstraint!
    @IBOutlet var RMselectorTopConstraint: NSLayoutConstraint!
    @IBOutlet var RMgridTopConstraint: NSLayoutConstraint!
    @IBOutlet var BFgridTopConstraint: NSLayoutConstraint!
    @IBOutlet var BFselectorTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var Shape: NSStackView!
    @IBOutlet var Ncat: NSStackView!
    @IBOutlet var RepRate: NSStackView!
    @IBOutlet var rateVariationParamsBox: NSBox!
    
    var SubModelBoxHeightConstraint = NSLayoutConstraint()
    var RateBoxHeightConstraint = NSLayoutConstraint()
    
    func toggleGammaParameters(hide: Bool) {
        if hide {
            Shape.isHidden = true
            Ncat.isHidden = true
            RepRate.isHidden = true
        } else {
            Shape.isHidden = false
            Ncat.isHidden = false
            RepRate.isHidden = false
        }
    }
    
    func toggleBaseFreqMatrix(hide: Bool) {
        if hide == true {
            BaseFreqMatrix.isHidden = true
            BFgridTopConstraint.constant = 0
        } else {
            BaseFreqMatrix.isHidden = false
            BFgridTopConstraint.constant = 15
        }
    }
    func toggleTratio(hide: Bool) {
        if hide {
            TratioSelector.isHidden = true
            TratioTopConstraint.constant = 0
            BFselectorTopConstraint.constant = 0
        } else {
            TratioSelector.isHidden = false
            TratioTopConstraint.constant = 35
            BFselectorTopConstraint.constant = 15
        }
    }
    
    func toggleRMatrix(hide: Bool) {
        if hide {
            RateMatrixSelector.isHidden = true
            RMselectorTopConstraint.constant = 0
        } else {
            RateMatrixSelector.isHidden = false
            RMselectorTopConstraint.constant = 35
            BFselectorTopConstraint.constant = 15
        }
    }
    
    func toggleRMatrixGrid(hide: Bool) {
        if hide {
            RateMatrix.isHidden = true
            RMgridTopConstraint.constant = 0
        } else {
            RateMatrix.isHidden = false
            RMgridTopConstraint.constant = 15
        
        }
    }
    
    func addHeightConstraintToSMBox() {

        SubModelBoxHeightConstraint    = NSLayoutConstraint(item: substitutionModelParamsBox as Any,
                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: substitutionModelParamsBox.fittingSize.height)
        substitutionModelParamsBox.addConstraint(SubModelBoxHeightConstraint)
    }
    
    func addHeightConstraintToRatesBox() {

        RateBoxHeightConstraint    = NSLayoutConstraint(item: rateVariationParamsBox as Any,
                                                 attribute: NSLayoutConstraint.Attribute.height,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: rateVariationParamsBox.fittingSize.height)
        rateVariationParamsBox.addConstraint(RateBoxHeightConstraint)
    }
    
   
    
    override func viewDidLayout() {
        super.viewDidLayout()
        if let windowController = view.window?.windowController as? TablessWindowController,  let parsimonyTool = windowController.tool as? Parsimony {
            self.options = parsimonyTool.options
            if let options = self.options {
                setNstOptions(options.lsNst)
            }
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
            setVariableSites(hideGammaParams: options.lsRates == PaupOptions.LSRates.equal.rawValue)
        }
        
    }
        
    @IBAction func selectNst(_ sender: NSPopUpButton) {
        let lsNst: Int = sender.indexOfSelectedItem
        substitutionModelParamsBox.removeConstraint(SubModelBoxHeightConstraint)
        setNstOptions(lsNst)
        addHeightConstraintToSMBox()
    
    }
    
    @IBAction func selectBFreq(_ sender: NSPopUpButton) {
        substitutionModelParamsBox.removeConstraint(SubModelBoxHeightConstraint)
        if sender.indexOfSelectedItem == PaupOptions.LSBasefreq.vectorValues.rawValue {
            toggleBaseFreqMatrix(hide: false)
        } else {
            toggleBaseFreqMatrix(hide: true)
        }
        addHeightConstraintToSMBox()
    }
    
    @IBAction func setRMatrix(_ sender: NSPopUpButton) {
        substitutionModelParamsBox.removeConstraint(SubModelBoxHeightConstraint)
        switch sender.indexOfSelectedItem {
        case 0:
            toggleRMatrixGrid(hide: true)
        case 1:
            toggleRMatrixGrid(hide: false)
        default: break
        }
        addHeightConstraintToSMBox()
    }
    
    @IBAction func setVariableSites(_ sender: NSPopUpButton) {
        setVariableSites(hideGammaParams: sender.indexOfSelectedItem == PaupOptions.LSRates.equal.rawValue)
    }
    
    func setNstOptions(_ lsNst: Int) {
    
        guard let options = self.options else { return }
        switch lsNst {
        case PaupOptions.LSNst.one.rawValue:
            toggleTratio(hide: true)
            toggleRMatrix(hide: true)
            toggleRMatrixGrid(hide: true)
        case PaupOptions.LSNst.two.rawValue:
            toggleTratio(hide: false)
            toggleRMatrix(hide: true)
            toggleRMatrixGrid(hide: true)
        case PaupOptions.LSNst.six.rawValue:
            toggleTratio(hide: true)
            toggleRMatrix(hide: false)
            if options.lsRMatrix == PaupOptions.LSRMatrix.estimate.rawValue {
                toggleRMatrixGrid(hide: true)
            } else { toggleRMatrixGrid(hide: false) }
        default: break
        }
    }
    
    func setGammarParameters() {
        guard let options = self.options else { return }
        switch options.lsRates {
        case PaupOptions.LSRates.equal.rawValue: toggleGammaParameters(hide: true)
        case PaupOptions.LSRates.gamma.rawValue: toggleGammaParameters(hide: false)
        default: break
        }
    }
    
    
    func setVariableSites(hideGammaParams: Bool){
        rateVariationParamsBox.removeConstraint(RateBoxHeightConstraint)
        toggleGammaParameters(hide: hideGammaParams)
        addHeightConstraintToRatesBox()
    }
    
    
}
