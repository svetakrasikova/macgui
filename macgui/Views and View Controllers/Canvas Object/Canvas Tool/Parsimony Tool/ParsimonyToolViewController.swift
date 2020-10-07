//
//  ParsimonyToolViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 8/12/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ParsimonyToolViewController: InfoToolViewController {
    
    @objc dynamic var options: PaupOptions?
    
    @IBOutlet weak var boxView: NSBox!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint?
    var heightConstraint = NSLayoutConstraint()
   
    @IBAction func selectSearchMethod(_ sender: NSPopUpButton) {
        let searchMethodIndex = sender.indexOfSelectedItem
        setSearchMethodAt(searchMethodIndex)
        
    }
    
    
    func addHeightConstraintToBox(height: CGFloat) {
   
        heightConstraint    = NSLayoutConstraint(item: boxView as Any,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                    multiplier: 1,
                                                    constant: height)
        boxView.addConstraint(heightConstraint)
    }
    
    func removeHeightConstraintFromBox() {
        boxView.removeConstraint(heightConstraint)
    }
    
    func setSearchMethodAt(_ index:  Int) {
        
        removeHeightConstraintFromBox()
        
        switch index {
            
        case PaupOptions.SearchMethod.exhaustive.rawValue:
            tabViewController?.selectedTabViewItemIndex = index
            guard let contentVC = getTabContentController(index: index) as? PaupExhaustiveViewController else { return }
            contentVC.options = options
            contentVC.options?.searchMethod = index
           
        case PaupOptions.SearchMethod.branchAndBound.rawValue:
            tabViewController?.selectedTabViewItemIndex = index
            guard let contentVC = getTabContentController(index: index) as? PaupBranchBoundViewController else { return }
            contentVC.options = options
            contentVC.options?.searchMethod = index
         
            
        case PaupOptions.SearchMethod.heuristic.rawValue:
            tabViewController?.selectedTabViewItemIndex = index
            guard let contentVC = getTabContentController(index: index) as? PaupHeuristicViewController else { return }
            contentVC.options = options
            contentVC.options?.searchMethod = index
            
        default:
            print("Search method not implemented")
            return
        }
        
        
        addHeightConstraintToBox(height: boxView.fittingSize.height)
    }

    @IBAction func reset(_ sender: NSButton) {
        guard let parsimonyTool = self.tool as? Parsimony else { return }
        parsimonyTool.options = PaupOptions()
        self.options = parsimonyTool.options
        setSearchMethodAt(self.options!.searchMethod)
        view.needsDisplay = true
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        postDismissNotification()
    }
    
    @IBAction func ok(_ sender: NSButton) {
        guard let parsimonyTool = self.tool as? Parsimony else { return }
        parsimonyTool.execute()
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        postDismissNotification()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let parsimonyTool = self.tool as? Parsimony else { return }
        self.options = parsimonyTool.options
        setSearchMethodAt(options!.searchMethod)

    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
    }
    
   
    
}
