//
//  NumberList.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/7/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class NumberList: NSObject, NSCoding {
    
    enum CodingKeys: String {
        case name, type, dimension, valueList
    }
    
    enum NumberListError: Error {
        case ConversionToNumberError, MatchingParenError, NumberListDimensionError
    }
    
    var name: String?
    var type: NumberListType
    var dimension: Int
    var valueList: [Any]
    
    init(type: NumberListType, dimension: Int, valueList: [Any]) {
        self.type = type
        self.dimension = dimension
        self.valueList = valueList
    }
    
    init(dataAsString: String) throws {
        (self.dimension, self.type, self.valueList) = try NumberList.parseNumberList(dataAsString, dimension: 0, type: NumberListType.Real)
        
    }
    
    class func parseNumberList(_ str: String, dimension: Int, type: NumberListType) throws -> (Int, NumberListType, [Any]){
        var listDimension = dimension
        var listType = type
        var valueList = [Any]()
        var numberListString = str
        if  numberListString.first == "(" {
            numberListString.removeFirst()
            guard numberListString.removeLast() == ")" else { throw NumberListError.MatchingParenError }
            let commaSeparatedLists = try NumberList.splitIntoList(numberListString)
            var temp: [Any] = []
            for str in commaSeparatedLists {
                let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
                let (d, t, l) = try parseNumberList(trimmedString, dimension: dimension + 1, type: type)
                temp.append(contentsOf: l)
                (listDimension,listType) = (d,t)
            }
            valueList.append(temp) 
        } else {
            guard let (t, l) = NumberList.parseNumber(str) else { throw NumberListError.ConversionToNumberError}
            valueList.append(l)
            listType = t
        }
        return (listDimension, listType, valueList)
    }
    
    class func splitIntoList(_ str: String) throws -> [String] {
        var list = [String]()
        if str.first == "(" {
            var readingList = false
            var token: String = ""
            for c in str {
                switch c {
                case ",":
                    if readingList { token.append(c) }
                case "(":
                    guard !readingList else {
                        throw NumberListError.MatchingParenError
                    }
                    token.append(c)
                    readingList = true
                case ")":
                    guard readingList else {
                        throw NumberListError.MatchingParenError
                    }
                    token.append(c)
                    readingList = false
                    list.append(token)
                    token = ""
                default: token.append(c)
                }
            }
        } else {
            list = str.split(separator: ",").map({String($0)})
        }
        return list
    }
    
    class func parseNumber(_ str: String) -> (NumberListType, Any)? {
        var result: (NumberListType, Any)?
        if let value = Int(str) {
            result = str.first == "-" ? (NumberListType.Integer, value) : (NumberListType.Natural, value)
        } else if let _ = Double(str){
            let value =  NSDecimalNumber(string: str)
            result = str.first == "-" ? (NumberListType.Real, value) : (NumberListType.PosReal, value)
        }
        return result
    }
    
    func mergeWith(_ aList: NumberList) throws {
        guard self.dimension == aList.dimension else {
            throw NumberListError.NumberListDimensionError
        }
        self.updateTypeTo(aList.type)
        self.valueList.append(contentsOf: aList.valueList)
    }
    
    func updateTypeTo(_ type: NumberListType) {
        switch self.type {
        case .Natural:
            self.type = type
        case .Integer:
            if type != .Natural {
                self.type = type
            }
        case .PosReal:
            if type == .Real {
                self.type = type
            }
        default: break
            
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(dimension, forKey: CodingKeys.dimension.rawValue)
        coder.encode(type.rawValue, forKey: CodingKeys.type.rawValue)
        coder.encode(valueList, forKey: CodingKeys.valueList.rawValue)
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
    
    required init?(coder: NSCoder) {
        dimension = coder.decodeInteger(forKey: CodingKeys.dimension.rawValue)
        type = NumberListType(rawValue: coder.decodeObject(forKey: CodingKeys.type.rawValue) as! String) ?? NumberListType.Real
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        valueList = coder.decodeObject(forKey: CodingKeys.valueList.rawValue) as? [Any] ?? []
    }
    
}


enum NumberListType: String {
    case Integer
    case Natural
    case Real
    case PosReal
    case Simplex
}

enum NumberListDimension: Int {
    case number, vector, matrix
}
