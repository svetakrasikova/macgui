//
//  ModelCanvasPlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/23/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasPlateViewController: ResizableCanvasObjectViewController {
    
    var model: Model? {
        if let canvas = self.parent as? ModelCanvasViewController {
            return canvas.model
        }
        return nil
    }
    
    lazy var plateController: ModelPlateController = {
        let plateController = NSStoryboard.loadVC(StoryBoardName.plateController) as! ModelPlateController
        if let plate = self.tool as? Plate {
            plateController.loop = plate
        }
        if let model = self.model {
            plateController.matrices = model.dataMatrices
        }
        if let canvasVC = self.parent as? GenericCanvasViewController {
            plateController.delegate = canvasVC
        }
        return plateController
    }()
    
    func toggleUpperRangeEdit(enable: Bool) {
        plateController.enableValueEdit = enable
        plateController.enableIteratorRange = enable
    }
    
    
    override func loadView() {
        if let plate = self.tool as? Plate {
            view = ModelCanvasPlateView(frame: plate.frameOnCanvas)
        }
        
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? ModelCanvasPlateView else { return }
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        view.backgroundColor = preferencesManager.modelCanvasBackgroundColor
        
    }
    
    override func observeLabelChange(){
        super.observeLabelChange()
         if let plate = tool as? Plate {
            observers.append(
                 plate.observe(\Plate.rangeType, options: [.initial]) {_,_  in
                     self.view.self.needsDisplay = true }
             )
         }
     }
    
    override func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(plateController)
    }
    
    
    
    override func upperRangeString() -> String? {
        var range: String?
        guard let plate = tool as? Plate else { return range }
        switch plate.rangeType {
        case Plate.IteratorRange.numberChar.rawValue:
            if let index = outerLoopIndex() {
                range = "(1,...,N[\(index)])"
            } else {
                range = upperRangeIndex(plateIteratorRange: plate.rangeType)
            }
        case Plate.IteratorRange.numberTaxa.rawValue:
            if let index = outerLoopIndex() {
                range = "(1,...,T[\(index)])"
            } else {
                range = upperRangeIndex(plateIteratorRange: plate.rangeType)
            }
        case Plate.IteratorRange.numberBranches.rawValue:
            if let index = outerLoopIndex() {
                range = "(1,...,B[\(index)])"
            } else {
                range = upperRangeIndex(plateIteratorRange: plate.rangeType)
            }
        case Plate.IteratorRange.numberMatrices.rawValue:
            range = "\(loop.upperRange)"
        case Plate.IteratorRange.number.rawValue:
            range =  loop.upperRange == 1 ?
                "\(loop.upperRange)" : "(1,...,\(loop.upperRange))"
        default: break
        }
        return range
    }
    
    func upperRangeIndex(plateIteratorRange: Int) -> String? {
        var range: String?
        
        if plateIteratorRange != Plate.IteratorRange.numberBranches.rawValue {
            guard model?.dataMatrices.count == 1, let  matrix = model?.dataMatrices.first
            else { return range }
            switch plateIteratorRange {
            case Plate.IteratorRange.numberChar.rawValue:
                let index = matrix.numberOfCharactersToInt(numberOfCharacters: matrix.getNumCharacters())
                range = "(1,...,\(index))"
            case Plate.IteratorRange.numberTaxa.rawValue:
                range = "(1,...,\(matrix.numTaxa))"
            
            default: break
            }
        } else {
            guard let plate = loop as? Plate, let numTaxa = plate.assignedNumTaxa, let rooted =  plate.numBranchesFunc == Plate.NumBrFunction.rooted.rawValue ? true : false else { return range }
            
                let numBranches = Tree.numBranches(numLeaves: numTaxa, rooted: rooted)
                range = "(1,...,\(numBranches))"
            
        }
        return range
    }
    
    func outerLoopIndex() -> String? {
        var index: String?
        guard let plate = tool as? Plate else { return index }
        if let outerLoopIndex = plate.outerLoop?.index {
            index = outerLoopIndex
        }
        return index
    }
    
}
