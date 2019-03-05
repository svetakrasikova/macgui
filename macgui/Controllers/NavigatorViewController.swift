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
    
    @objc dynamic var analyses: [Analysis] = [Analysis(name: "untitled analysis")]
    
    weak var delegate: NavigatorViewControllerDelegate? = nil
    
    @IBAction func addRemoveButtonClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            addAnalysis()
            
        case 1:
            if let selectedForRemoval = arrayController.selectedObjects {
                arrayController.removeSelectedAnalyses(toRemove: selectedForRemoval as! [Analysis])
                if analyses.isEmpty {
                  addAnalysis()
                }
            }
        case 2:
            if let selectedAnalysis = arrayController.selectedObjects.first as! Analysis? {
                copyAnalysis(from: selectedAnalysis)
            }
        default:
            print("Switch case error")
        
        }        
        setSelectedAnalysisToActive()
    }
    
    
    /**
     Trigger a call on the delegate to update the detail view if a new analysis is selected in the table view
     */
    @IBAction func selectAnalysis(sender: AnyObject){
        let selectedAnalysis = arrayController.selectedObjects.first as! Analysis?
        delegate?.navigatorViewController(viewController: self, selectedAnalysis: selectedAnalysis)
    }
    
    /**
     Trigger a call on the delegate to update the detail view if an analysis is added or deleted
     */
    
    func setSelectedAnalysisToActive(){
        let index: IndexSet = [arrayController.selectionIndex]
        analysesTableView.selectRowIndexes(index, byExtendingSelection: false)
        let selectedAnalysis = arrayController.selectedObjects.first as! Analysis?
        delegate?.navigatorViewController(viewController: self, selectedAnalysis: selectedAnalysis)
    }
    
    /**
     Add a new empty analysis
     */
    func addAnalysis() {
        let analysis = Analysis(name: getUniqueAnalysisName())
        arrayController.addObject(analysis)
    }
    
    /**
     Copy an analysis
     */
    func copyAnalysis(from: Analysis) {
        let analysis = from.copy() as! Analysis
        analysis.name = getUniqueAnalysisName()
        arrayController.addObject(analysis)
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let indices = IndexSet([0])
        analysesTableView.selectRowIndexes(indices, byExtendingSelection: false)
    }
}



extension NavigatorViewController {
    
    /**
     Create a unique default analysis name starting with "untitled analysis" followed by the next available numerical identifier
     
     - returns: A unique name for an analysis
     */
    
    
    func getUniqueAnalysisName() -> String {
        
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
            return "untitled analysis"
        }
        for (i,v) in defaultNameIndices.enumerated(){
            if v == 0 {
                return "untitled analysis \(i)"
            }
        }
        return "untitled analysis \(defaultNameIndices.count)"
    }

}


