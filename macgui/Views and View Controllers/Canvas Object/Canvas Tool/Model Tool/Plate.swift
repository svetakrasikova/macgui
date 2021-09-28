//
//  Plate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/2/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers

class Plate: Loop {
    
    enum IteratorRange: Int {
        case number
        case numberMatrices
        case numberChar
        case numberTaxa
        case numberBranches
    }
    
    enum NumBrFunction: Int {
        case rooted, unrooted
    }
    
    
    enum CodingKeys: String {
        case rangeType, assignedMatrix, numBranchesFunc
    }
    
    dynamic var rangeType: Int = IteratorRange.number.rawValue {
        didSet {
            if rangeType != IteratorRange.numberBranches.rawValue {
                assignedMatrix = nil
            }
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var assignedMatrix: DataMatrix? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var assignedNumTaxa: Int? {
        return assignedMatrix?.numTaxa
    }
    
    dynamic var numBranchesFunc: Int = NumBrFunction.rooted.rawValue {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    
    override init(frameOnCanvas: NSRect, analysis: Analysis, index: String){
        super.init(frameOnCanvas: frameOnCanvas, analysis: analysis, index: index)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(rangeType, forKey: CodingKeys.rangeType.rawValue)
        coder.encode(assignedMatrix, forKey: CodingKeys.assignedMatrix.rawValue)
        coder.encode(numBranchesFunc, forKey: CodingKeys.numBranchesFunc.rawValue)
        super.encode(with: coder)
    }
    
    required init?(coder decoder: NSCoder) {
        rangeType = decoder.decodeInteger(forKey: CodingKeys.rangeType.rawValue)
        assignedMatrix = decoder.decodeObject(forKey: CodingKeys.assignedMatrix.rawValue) as? DataMatrix
        numBranchesFunc = decoder.decodeInteger(forKey: CodingKeys.numBranchesFunc.rawValue)
        super.init(coder: decoder)
    }
    
    override func updateOuterLoop(_ loop: Loop?) {
        super.updateOuterLoop(loop)
        self.rangeType = Plate.IteratorRange.number.rawValue
        
    }
    
    func setNumBranchesUpperRange() {
        guard let numTaxa = self.assignedNumTaxa else { return }
        let rooted = self.numBranchesFunc == Plate.NumBrFunction.rooted.rawValue
        upperRange = Tree.numBranches(numLeaves: numTaxa, rooted: rooted)
    }
}
