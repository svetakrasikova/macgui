//
//  NumberBundle.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/2/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers
class TypeBundle: NSObject, NSCoding {

    enum CodingKeys: String {
        case value, type, dimension, valueString
    }
    dynamic var value: Any
    var type: String
    var dimension: Int
    dynamic var valueString: String
    
    
    var numberBundleSize: (Int, Int)? {
        switch dimension {
        case 0: return (1,0)
        case 1:
            guard let vector = (value as? [Any]) else { return nil }
            let numberRows = vector.count
            return (numberRows,0)
        case 2:
            guard let matrix = (value as? [Any]) else { return nil }
            let numberRows = matrix.count
            guard let numberColums = (matrix.first as? [Any])?.count else { return nil}
            return (numberRows, numberColums)
        default: return nil
        }
    }
    
    init(value: Any, type: String, dimension: Int, valueString: String) {
        self.value = value
        self.type = type
        self.dimension = dimension
        self.valueString = valueString
    }
    
    init(dataMatrix: DataMatrix) {
        self.value = dataMatrix
        self.type = MatrixDataType.AbstractHomologousDiscreteCharacterData.rawValue
        self.dimension = 2
        self.valueString = dataMatrix.matrixName
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(value, forKey: CodingKeys.value.rawValue)
        coder.encode(type, forKey: CodingKeys.type.rawValue)
        coder.encode(valueString, forKey: CodingKeys.valueString.rawValue)
        coder.encode(dimension, forKey: CodingKeys.dimension.rawValue)
    }
    
    required init?(coder: NSCoder) {
        value = coder.decodeObject(forKey: CodingKeys.value.rawValue) as Any
        type = coder.decodeObject(forKey: CodingKeys.type.rawValue) as? String ?? NumberListType.Real.rawValue
        dimension = coder.decodeInteger(forKey: CodingKeys.dimension.rawValue)
        valueString = coder.decodeObject(forKey: CodingKeys.valueString.rawValue) as? String ?? ""
        
    }
    
    
    
}
