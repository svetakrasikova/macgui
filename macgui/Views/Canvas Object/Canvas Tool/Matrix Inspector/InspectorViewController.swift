//
//  InspectorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InspectorViewController: NSSplitViewController, FilesNavigatorViewControllerDelegate {
  
    var dataMatrices: [DataMatrix]?

    
    var filesNavigator: FilesNavigatorViewController? {
        for item in splitViewItems {
            if let fileNavigator = item.viewController as? FilesNavigatorViewController {
                fileNavigator.dataMatrices = self.dataMatrices
                return fileNavigator
            }
        }
        return nil
    }
    
    var matrixViewer: MatrixViewController? {
        for item in splitViewItems {
            if let matrixViewer = item.viewController as? MatrixViewController {
                return matrixViewer
            }
        }
        return nil
    }
    
    var infoInspector: InfoInspector? {
        for item in splitViewItems {
            if let infoInspector = item.viewController as? InfoInspector {
                return infoInspector
            }
            
        }
        return nil
    }
    
    func setSelectedFile(viewController: FilesNavigatorViewController, selectedFile: String) {
//          TODO: set the value of the matrix viewer to the selected file matrix
      }
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filesNavigator?.delegate = self
    }
    
    func expandCollapseSidebar() {
        if splitViewItems[0].isCollapsed {
            splitViewItems[0].isCollapsed = false
        } else {
            splitViewItems[0].isCollapsed = true
        }
    }
    
}
