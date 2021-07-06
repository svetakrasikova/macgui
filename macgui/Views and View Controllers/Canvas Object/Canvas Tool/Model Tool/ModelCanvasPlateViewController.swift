//
//  ModelCanvasPlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/23/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasPlateViewController: ResizableCanvasObjectViewController {
    
    lazy var plateController: ModelPlateController = {
        let plateController = NSStoryboard.loadVC(StoryBoardName.plateController) as! ModelPlateController
        if let plate = self.tool as? Plate {
            plateController.loop = plate
        }
        if let canvas = self.parent as? ModelCanvasViewController, let model = canvas.model {
            plateController.matricesCount = model.dataMatrices.count
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
    
    override func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(plateController)
    }
    
    
    
    override func upperRangeString() -> String? {
        var range: String?
        guard let plate = tool as? Plate else { return range }
        switch plate.rangeType {
        case Plate.IteratorRange.numberChar.rawValue:
            guard let index = outerLoopIndex() else { return range}
            range = "(1,...,N[\(index)]"
        case Plate.IteratorRange.numberTaxa.rawValue:
            guard let index = outerLoopIndex() else { return range}
            range = "(1,...,T[\(index)]"
        case Plate.IteratorRange.numberMatrices.rawValue:
            range = "\(loop.upperRange)"
        case Plate.IteratorRange.number.rawValue:
            range =  loop.upperRange == 1 ?
                "\(loop.upperRange)" : "(1,...,\(loop.upperRange))"
        default: break
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
