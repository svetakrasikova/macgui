//
//  Analysis.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/14/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Analysis: NSObject, NSCoding, NSCopying {

    @objc dynamic var name: String = ""
    @objc dynamic var tools: [ToolObject] = []
    @objc dynamic var arrows: [Connection] = []
    var notes: String?
    
    override init(){
        super.init()
    }
    
    init(name: String){
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        tools = aDecoder.decodeObject(forKey: "tools") as! [ToolObject]
        arrows = aDecoder.decodeObject(forKey: "arrows") as! [Connection]
        notes = aDecoder.decodeObject(forKey: "notes") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(tools, forKey: "tools")
        aCoder.encode(arrows, forKey: "arrows")
        if let notes = notes {
            aCoder.encode(notes, forKey: "notes")
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


