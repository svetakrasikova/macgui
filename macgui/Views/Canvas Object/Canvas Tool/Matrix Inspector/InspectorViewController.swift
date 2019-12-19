//
//  InspectorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class InspectorViewController: NSSplitViewController, MatrixNavigatorViewControllerDelegate, InfoInspectorDelegate {
    
    
    var dataMatrices: [DataMatrix]?
    
    var selectedMatrix: DataMatrix? {
        didSet{
            if let infoInspector = self.infoInspector {
                setInfoInspectorValues(inspector: infoInspector)
            }
        }
    }

    
    var matrixNavigator: MatrixNavigatorViewController? {
        for item in splitViewItems {
            if let matrixNavigator = item.viewController as? MatrixNavigatorViewController {
                return matrixNavigator
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
    
    // MARK: - MatrixNavigatorViewControllerDelegate
    
    func matrixNavigatorViewController(viewController: MatrixNavigatorViewController, selectedMatrix: DataMatrix) {
        self.selectedMatrix = selectedMatrix
        matrixViewer?.flushTableView()
        matrixViewer?.showSelectedMatrix(matrixToShow: selectedMatrix)
      }
    
    // MARK: - InfoInspectorDelegate
    
    func setInfoInspectorValues(inspector: InfoInspector) {
        if let selectedMatrix = self.selectedMatrix {
            inspector.dataType.stringValue = selectedMatrix.dataType.rawValue
            inspector.numberOfCharacters.stringValue = selectedMatrix.numberOfCharactersToString(numberOfCharacters: selectedMatrix.getNumCharacters())
            inspector.numberOfTaxa.integerValue = selectedMatrix.numTaxa
            inspector.numberOfExcludedCharacters.integerValue = selectedMatrix.getDeletedCharacters().count
            inspector.numberOfExcludedTaxa.integerValue = selectedMatrix.getDeletedTaxaNames().count
            inspector.sequencesAligned.stringValue = "Unknown"
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        matrixNavigator?.delegate = self
        
        infoInspector?.delegate = self
        
        if let inspectorWC = view.window?.windowController as? InspectorWindowController {
            self.dataMatrices = inspectorWC.dataMatrices
        }
        
    }
   
    
    
}
