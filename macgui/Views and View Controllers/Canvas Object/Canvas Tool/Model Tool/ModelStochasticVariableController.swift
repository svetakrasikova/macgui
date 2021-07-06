//
//  ModelStochasticVariableController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/24/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa


class ModelStochasticVariableController: ModelVariableController {

    
    @IBOutlet var clampArrayController: NSArrayController!
    @IBOutlet weak var clampDataSelector: NSPopUpButton!
    @IBOutlet weak var clampDataSelectorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var clampButton: NSButton!
    
    @objc dynamic var enableClamping: Bool {
        return !observedData.isEmpty
    }
    
    @objc dynamic var enableClampSelection: Bool {
        return !observedData.isEmpty
    }
    
    @IBAction func checkClampButton(_ sender: NSButton) {
        selectDataForClamping()
    }
    
    @IBAction func selectDataforClamping(_ sender: NSPopUpButton) {
        selectDataForClamping()
        
    }
    
    func selectDataForClamping() {
        guard let node = self.modelNode else { return }
        switch clampButton.state {
        case .on:
          if let observedDataList = clampArrayController.selectedObjects.first as? NumberList {
            node.changeObservedValueTo(observedDataList)
            guard let size = observedDataList.size else { return }
            updatePlateRange(size, clampedRange: true)
          }
        case .off:
            updatePlateRange((1,1), clampedRange: false)
            node.changeObservedValueTo(nil)
            
        default: break
        }
    }
    
    func updatePlateRange(_ newRange: (Int, Int), clampedRange: Bool) {
        guard let canvasVC = self.delegate as? ModelCanvasViewController else { return }
        guard let modelNode = self.modelNode else { return }
        let nodeVC = canvasVC.findVCByTool(modelNode)
        if let smallestLoopVC = nodeVC?.outerLoopViewController as? ModelCanvasPlateViewController, let plate = smallestLoopVC.loop as? Plate {
            plate.upperRange = newRange.0
            smallestLoopVC.toggleUpperRangeEdit(enable: !clampedRange)
            smallestLoopVC.view.needsLayout = true
            if let outerPlate = plate.outerLoop {
                outerPlate.upperRange = newRange.1
                let outerLoopVC = canvasVC.findVCByTool(outerPlate) as? ModelCanvasPlateViewController
                outerLoopVC?.toggleUpperRangeEdit(enable: !clampedRange)
                outerLoopVC?.view.needsLayout = true
            }
        }
    }
    
    @objc dynamic var observedData: [NumberList] {
        guard let modelNode = modelNode, modelNode.nodeType == .randomVariable else { return [] }
        guard let variable = modelNode.node as? PaletteVariable else { return [] }
        guard let nodeEmbedLevel = nodeEmbedLevel else { return [] }
        var data: [NumberList] = []
        if let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model {
            for l in model.numberData.numberLists {
                if variable.type == l.type.rawValue && variable.dimension + nodeEmbedLevel == l.dimension {
                    data.append(l)
                }
            }
        }
        return data
    }
    
    var nodeEmbedLevel: Int? {
        guard let modelNode = modelNode else { return nil }
        guard let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model else { return nil}
        for p in model.plates {
            if p.contains(node: modelNode) {
                return p.embedLevel() + 1
            }
        }
       return 0
    }
    
    override var distributions: [Distribution] {
        guard let delegate = self.delegate, let modelNode = self.modelNode else { return [] }
        return delegate.getDistributionsForParameter(modelNode)
    }
    
    func setClampingUI() {
        guard let node = self.modelNode else { return }
        guard enableClamping else { return }
        clampArrayController.content = observedData
        clampButton.state =  node.clamped ? .on : .off
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setClampingUI()
    }

   
    
}
