//
//  NumberData.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/7/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class NumberData: NSObject, NSCoding {
    
    enum NumberDataError: Error {
        case DataError, FileHeaderError
    }
    enum CodingKeys: String {
        case numberLists
    }
   
    var numberLists: [NumberList] = []
    
    var isEmpty: Bool {
        return numberLists.isEmpty
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(numberLists, forKey: CodingKeys.numberLists.rawValue)
    }
    
    var descriptionString: String {
        var str = "Number data with \(self.numberLists.count) number lists\n"
        for list in numberLists {
            str += "\(list.name ?? "-")\t\(list.dimension)\t\(list.type.rawValue)\t \(list.valueList.description)\n"
        }
        return str
    }

    
    required init?(coder: NSCoder) {
        numberLists = coder.decodeObject(forKey: CodingKeys.numberLists.rawValue) as? [NumberList] ?? []
    }
    
    override init() {
        super.init()
    }
    
    
    convenience init(names: [String], lists: [NumberList]) throws {
        guard names.count == lists.count else { throw NumberDataError.FileHeaderError }
        self.init()
        for (index, name) in names.enumerated() {
            let namedList = lists[index]
            namedList.name = name
            self.numberLists.append(namedList)
        }
    }

    convenience init(url: URL) throws {
        self.init()
        do {
            let d = try Data(contentsOf: url)
            if let dataToString = String(data:d, encoding: .utf8) {
                let lines = dataToString.split(separator: "\n")
                var names: [String] = []
                var lists: [NumberList] = []
                var foundNames = false
                for (rowIndex, line) in lines.enumerated() {
                    if !foundNames && line.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
                        names = line.split(separator: "\t").map {String($0)}
                        foundNames = true
                    } else {
                        let splitLine = line.split(separator: "\t").map({String($0)})
                        for (columnIndex, list) in splitLine.enumerated() {
                            if rowIndex == 1 {
                                lists.append(try NumberList(dataAsString: list))
                            } else {
                                try lists[columnIndex].mergeWith(try NumberList(dataAsString: list))
                            }
                        }
                    }
                    
                }
                try self.init(names: names, lists: lists)
            }
        } catch {
            throw NumberDataError.DataError
        }
        
    }
     
    func emptyList() {
        self.numberLists = []
    }

    func append(data: NumberData) {
        var merge = false
        for l in data.numberLists {
            for k in self.numberLists {
                if l.name == k.name && l.type == k.type {
                    k.valueList.append(contentsOf: l.valueList)
                    merge = true
                }
            }
            if !merge {
                self.numberLists.append(l)
            }
        }
    }

    


    
    
}


