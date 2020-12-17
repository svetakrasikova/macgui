//
//  PaupCriterionOptionsViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/15/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupCriterionOptionsViewController: NSViewController {

    @objc dynamic var options: PaupOptions?
    
    @IBOutlet var TratioSelector: NSStackView!
    @IBOutlet var RateMatrixSelector: NSStackView!
    @IBOutlet var RateMatrix: NSGridView!

    
    override func viewWillAppear() {
        super.viewWillAppear()
        let fittingSize =  self.view.fittingSize
        preferredContentSize =  NSSize(width: 450, height: fittingSize.height)
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
        
    @IBAction func selectNst(_ sender: NSPopUpButton) {
        let lsNst: Int = sender.indexOfSelectedItem
        setNstOptions(lsNst)
    }
    
    @IBAction func setRMatrix(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            RateMatrix.isHidden = true
        case 1:
            RateMatrix.isHidden = false
        default: break
        }
    }
    
    
    func setNstOptions(_ lsNst: Int) {
        guard let options = self.options else { return }
        switch lsNst {
        case PaupOptions.LSNst.one.rawValue:
            TratioSelector.isHidden = true
            RateMatrixSelector.isHidden = true
            RateMatrix.isHidden = true
        case PaupOptions.LSNst.two.rawValue:
            TratioSelector.isHidden = false
            RateMatrixSelector.isHidden = true
            RateMatrix.isHidden = true
        case PaupOptions.LSNst.six.rawValue:
            TratioSelector.isHidden = true
            RateMatrixSelector.isHidden = false
            RateMatrix.isHidden = options.lsRMatrix == PaupOptions.LSRMatrix.estimate.rawValue ? true : false
    
        default: break
        }
    }
    
}
