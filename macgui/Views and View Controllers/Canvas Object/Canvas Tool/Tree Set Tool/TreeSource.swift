//
//  TreeSource.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/17/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSource: NSObject, NSCoding {
    
    
    enum Key: String {
        case hashVal, count, tool, key
    }
    
    var key: String
    var hashVal: Int {
        return key.hashValue
    }
    var count: Int
    var tool: DataTool?
    
    
    init(count: Int, source: AnyObject?, key: String) {
        self.count = count
        if let tool = source as? DataTool {
            self.tool = tool
        }
        self.key = key
        
    }
    
    override init() {
        key = TreeSet.Key.unconnected.rawValue
        count = 0
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(key, forKey: Key.key.rawValue)
        coder.encode(count, forKey: Key.count.rawValue)
        coder.encode(tool, forKey: Key.tool.rawValue)
    }
    
    required init?(coder: NSCoder) {
        key = coder.decodeObject(forKey: Key.key.rawValue) as! String
        count = coder.decodeInteger(forKey: Key.count.rawValue)
        tool = coder.decodeObject(forKey: Key.tool.rawValue) as? DataTool
    }
    
}
