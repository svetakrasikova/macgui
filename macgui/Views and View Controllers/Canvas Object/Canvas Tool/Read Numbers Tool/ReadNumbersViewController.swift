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
    
    var minNavigatorWidth: CGFloat {
        let margin: CGFloat = 60.0
        if let numberData = self.numberData {
            let listNames = numberData.numberLists.map {$0.name}
            return margin + String.lengthOfLongestString(listNames)
        }
        return margin
    }
    
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
        guard let navigator = self.navigator else { return }
        navigator.delegate = self
        readNumbersViewer?.delegate = self
        if let inspectorWC = view.window?.windowController as? InspectorWindowController {
            self.numberData = inspectorWC.numberData
        }

        NSLayoutConstraint(item: navigator.view as Any, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: minNavigatorWidth).isActive = true
        
    }
    
   
    
}
