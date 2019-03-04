//
//  NavigatorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

protocol NavigatorViewControllerDelegate: class {
    func navigatorViewController(viewController: NavigatorViewController,
                                  selectedAnalysis: Analysis?) -> Void
    }
    

class NavigatorViewController: NSViewController {
    
    @IBOutlet weak var addRemoveButtons: NSSegmentedControl!
    @IBOutlet weak var arrayController : NSArrayController!
    @IBOutlet var contextualMenu: NSMenu!
    @IBOutlet weak var analysesTableView: NSTableView!
    
    @objc dynamic var analyses: [Analysis] = [Analysis()]
    weak var delegate: NavigatorViewControllerDelegate? = nil
    
    @IBAction func selectAnalysis(sender: AnyObject){
        let selectedAnalysis = arrayController.selectedObjects.first as! Analysis?
        delegate?.navigatorViewController(viewController: self, selectedAnalysis: selectedAnalysis)
    }
    
    // TODO: Implement copy
    @IBAction func menuDuplicateClicked(_ sender: Any) {
        arrayController.addObject(Analysis())
        
    }

    @IBAction func addRemoveButtonClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            let analysis = newUntitledAnalysis()
            arrayController.addObject(analysis)
        case 1:
            if let selectedForRemoval = arrayController.selectedObjects {
                arrayController.removeSelectedAnalyses(sender: sender, toRemove: selectedForRemoval as! [Analysis])
            }
        default:
            print("Switch case error")
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indices = IndexSet([0])
        analysesTableView.selectRowIndexes(indices, byExtendingSelection: false)
    }
    
}


// MARK: - Utilities

/**
 Create a new Analysis prefixed with "untitled analysis" followed by the next available numeral identifier
 
 - returns: Analysis object with a default name
 */

extension NavigatorViewController {
    
    func newUntitledAnalysis() -> Analysis {
        
        var defaultNameIndices = [Int](repeating: 0, count: analyses.count)
        
        for analysis in analyses{
            if analysis.name.starts(with: "untitled analysis"){
                if analysis.name == "untitled analysis" {
                    defaultNameIndices[0] = 1
                } else {
                    if let index = Int(analysis.name.components(separatedBy: " ")[2]){
                        if index >= defaultNameIndices.count {
                            defaultNameIndices.insert(1, at: defaultNameIndices.count)
                        } else {
                            defaultNameIndices[index] = 1
                        }
                    }
                }
            }
        }
        if defaultNameIndices.isEmpty || defaultNameIndices[0] == 0 {
            return Analysis()
        }
        for (i,v) in defaultNameIndices.enumerated(){
            if v == 0 {
                return Analysis(name: "untitled analysis \(i)")
            }
        }
        return Analysis(name: "untitled analysis \(defaultNameIndices.count)")
    }
}


