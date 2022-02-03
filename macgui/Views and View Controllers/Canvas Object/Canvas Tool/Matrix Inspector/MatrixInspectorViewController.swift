//
//  InspectorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 11/13/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MatrixInspectorViewController: NSSplitViewController, MatrixNavigatorViewControllerDelegate, InfoInspectorDelegate {
    
    
    var dataMatrices: [DataMatrix]?
    
    @IBOutlet weak var inspectorSplitView: NSSplitView!
    
    var selectedMatrixIndex: Int? {
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
                matrixViewer.dataMatrices = self.dataMatrices
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
    
    func matrixNavigatorViewController(selectedMatrixIndex: Int) {
        self.selectedMatrixIndex = selectedMatrixIndex
        matrixViewer?.showSelectedMatrix(matrixIndex: selectedMatrixIndex)
      }
    
    
    // MARK: - InfoInspectorDelegate
    
    func setInfoInspectorValues(inspector: InfoInspector) {
        if let index = self.selectedMatrixIndex, let selectedMatrix = self.dataMatrices?[index] {
            inspector.dataType.stringValue = selectedMatrix.dataType.rawValue
            inspector.numberOfCharacters.stringValue = selectedMatrix.numberOfCharactersToString(numberOfCharacters: selectedMatrix.getNumCharacters())
            inspector.numberOfTaxa.integerValue = selectedMatrix.numTaxa
            inspector.numberOfExcludedCharacters.integerValue = selectedMatrix.getDeletedCharacters().count
            inspector.numberOfExcludedTaxa.integerValue = selectedMatrix.getDeletedTaxaNames().count
            if selectedMatrix.homologyEstablished {
                inspector.sequencesAligned.stringValue = "Yes"
            } else {
                inspector.sequencesAligned.stringValue = "No"
            }
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
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if let dataMatrices = self.dataMatrices {
            let position: CGFloat = String.lengthOfLongestString(dataMatrices.map { $0.matrixName }, fontSize: 13.0)
            inspectorSplitView.setPosition(position, ofDividerAt: 0)
        }
       
    }
   
    
    
}
