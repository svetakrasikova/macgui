//
//  PaupParsimonyOptionsViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/6/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PaupParsimonyOptionsViewController: NSViewController {
    
    @objc dynamic var options: PaupOptions?
    
    
    @IBOutlet var OptionsBox: NSBox!
    @IBOutlet var StepMatrixGrid: NSGridView!
    @IBOutlet var StepMatrixTopConstraint: NSLayoutConstraint!
    
    var BoxHeightConstraint = NSLayoutConstraint()

    
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
            toggleGrid(hide: options.psStepMatrix == PaupOptions.PSStepMatrix.no.rawValue)
        }
        
    }
    
    @IBAction func stepMatrixToggle(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0: toggleGrid(hide: true)
        case 1: toggleGrid(hide: false)
        default: break
        }
    }
    
    func toggleGrid(hide: Bool){
        StepMatrixGrid.isHidden = hide
        StepMatrixTopConstraint.constant = hide ? 0 : 15
        addHeightConstraintToBox()
    }
    
    func addHeightConstraintToBox() {
        
        OptionsBox.removeConstraint(BoxHeightConstraint)
        BoxHeightConstraint    = NSLayoutConstraint(item: OptionsBox as Any,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                    multiplier: 1,
                                                    constant: OptionsBox.fittingSize.height)
        OptionsBox.addConstraint(BoxHeightConstraint)
    }
    
    
}



