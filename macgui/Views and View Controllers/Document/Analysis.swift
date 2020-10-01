//
//  Analysis.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Analysis: NSObject, NSCoding, NSCopying {

    
    enum Key: String {
        case name, tools, arrows, notes
    }
    @objc dynamic var name: String = "" {
        didSet{
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    @objc dynamic var tools: [ToolObject] = [] {
        didSet{
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    @objc dynamic var arrows: [Connection] = []

    var notes: String? {
        didSet {
             NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    override init(){
        super.init()
    }
    
    init(name: String){
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        tools = aDecoder.decodeObject(forKey: Key.tools.rawValue) as! [ToolObject]
        arrows = aDecoder.decodeObject(forKey: Key.arrows.rawValue) as! [Connection]
        notes = aDecoder.decodeObject(forKey: Key.notes.rawValue) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(tools, forKey: Key.tools.rawValue)
        aCoder.encode(arrows, forKey: Key.arrows.rawValue)
        if let notes = notes {
            aCoder.encode(notes, forKey: Key.notes.rawValue)
        }
    }
    
    func isEmpty() -> Bool {
        return arrows.isEmpty && tools.isEmpty
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Analysis()
        copy.tools = tools
        copy.arrows = arrows
        copy.notes = notes
        return copy
    }

}


