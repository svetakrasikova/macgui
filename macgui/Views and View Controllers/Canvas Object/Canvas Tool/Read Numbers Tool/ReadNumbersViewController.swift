//
//  ReadNumbersViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/14/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ReadNumbersViewController: NSSplitViewController, ReadNumbersNavigatorViewControllerDelegate{
    

    weak var numberData: NumberData?
    
    @IBOutlet weak var inspectorSplitView: NSSplitView!
    
    var navigator: ReadNumbersNavigatorViewController? {
        for item in splitViewItems {
            if let navigator = item.viewController as? ReadNumbersNavigatorViewController {
                return navigator
            }
        }
        return nil
    }
    
    var readNumbersViewer: ReadNumbersViewerViewController? {
        for item in splitViewItems {
            if let viewer = item.viewController as? ReadNumbersViewerViewController {
                return viewer
            }
        }
        return nil
    }
    
    func readNumbersNavigatorViewController(selectedListIndex: Int) {
        readNumbersViewer?.showSelectedNumberData(listIndex: selectedListIndex)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear() {
        super.viewWillAppear()
        navigator?.delegate = self
        readNumbersViewer?.delegate = self
        if let inspectorWC = view.window?.windowController as? InspectorWindowController {
            self.numberData = inspectorWC.numberData
        }
        
    }
    
}
