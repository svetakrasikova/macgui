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
    }
    
    enum CodingKeys: String {
        case rangeType
    }
    
    dynamic var rangeType: Int = IteratorRange.number.rawValue {
        didSet {
            switch rangeType {
            case IteratorRange.number.rawValue:
                if oldValue != IteratorRange.number.rawValue {
                    self.upperRange = 1
                }
            default: self.upperRange = -1
            }
        }
    }
    
    override init(frameOnCanvas: NSRect, analysis: Analysis, index: String){
        super.init(frameOnCanvas: frameOnCanvas, analysis: analysis, index: index)
    }
    
    
    override func encode(with coder: NSCoder) {
        coder.encode(rangeType, forKey: CodingKeys.rangeType.rawValue)
        super.encode(with: coder)
    }
    
    required init?(coder decoder: NSCoder) {
        rangeType = decoder.decodeInteger(forKey: CodingKeys.rangeType.rawValue)
        super.init(coder: decoder)
    }
}
