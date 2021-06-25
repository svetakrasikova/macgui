//
//  NumberList.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/7/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers
class NumberList: NSObject, NSCoding {
    
    enum CodingKeys: String {
        case name, type, dimension, valueList
    }
    
    enum NumberListError: Error {
        case ConversionToNumberError, MatchingParenError, NumberListDimensionError
    }
    
    dynamic var name: String = "unnamed"
    var type: NumberListType {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    var dimension: Int
    var dimensionSymbol: String {
        switch dimension {
        case 0: return "\(self.type.rawValue)"
        case 1: return "[\(self.type.rawValue)]"
        case 2: return "[[\(self.type.rawValue)]]"
        default: return ""
        }
    }
    var valueList: [Any]
    
    var isEmpty: Bool {
        return valueList.isEmpty
    }
    
    init(type: NumberListType, dimension: Int, valueList: [Any]) {
        self.type = type
        self.dimension = dimension
        self.valueList = valueList
    }
    
    override init() {
        self.type = .Real
        self.dimension = 0
        self.valueList = []
        super.init()
    }
    
    init(dataAsString: String) throws {
        (self.dimension, self.type, self.valueList) = try NumberList.parseNumberList(dataAsString, dimension: 0, type: NumberListType.Real)
        
    }
    
    func stringValue(index: Int) -> String {
        var stringValue: String = ""
        let value = self.valueList[index]
            switch dimension {
            case 0: stringValue = NumberList.numToString(value: value)
            case 1: stringValue = NumberList.vectorToString(value: value as! [Any])
            case 2: stringValue = NumberList.matrixToString(value: value as! [Any])
            default: break
            }
        return stringValue
    }
    
    class func numToString(value: Any) -> String {
        if let integerValue = value as? Int {
            return String(integerValue)
        } else if let decimalValue = value as? NSDecimalNumber{
            return decimalValue.stringValue
        }
        return ""
    }
    
    class func vectorToString(value: [Any]) -> String {
        var str = "["
        for (index, num) in value.enumerated() {
            str += index == value.count - 1 ? "\(numToString(value: num))" : "\(numToString(value: num)), "
        }
        str += "]"
        return str
    }
    
    class func matrixToString(value: [Any]) -> String {
        var str = "["
        for (index, num) in value.enumerated() {
            str += index == value.count - 1 ? "\(vectorToString(value: num as! [Any]))" : "\(vectorToString(value: num as! [Any])), "
        }
        str += "]"
        return str
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
            result = str.first == "-" ? (NumberListType.Real, value) : (NumberListType.RealPos, value)
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
        case .RealPos:
            if type == .Real {
                self.type = type
            }
        default: break
            
        }
    }
    
    
    class func typesCompatibleWith(_ type: NumberListType) -> [NumberListType] {
        switch type {
        case .Integer: return [.Integer, .Natural, .RealPos, .Real]
        case .Natural: return [.Integer, .Natural, .RealPos, .Real]
        case .RealPos: return [.RealPos, .Real]
        case .Real: return [.RealPos, .Real]
        case .Simplex: return [.Integer, .Natural, .RealPos, .Real]
            
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
        name = coder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? "unnamed"
        valueList = coder.decodeObject(forKey: CodingKeys.valueList.rawValue) as? [Any] ?? []
    }
    
}

enum NumberListType: String, CaseIterable {
    case Integer
    case Natural
    case Real
    case RealPos
    case Simplex
}

enum NumberListDimension: Int {
    case number, vector, matrix
}
