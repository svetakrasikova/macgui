//
//  DataSource.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/22/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class DataSource: NSObject, NSCoding {

    
    @objc dynamic var analyses: [Analysis] = [Analysis(name: "untitled analysis")] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    @objc dynamic var selectionIndexes: NSIndexSet = NSIndexSet()
    
    
    func encode(with coder: NSCoder) {
         coder.encode(analyses, forKey: "analyses")
    }
    
    convenience init(analyses: [Analysis]) {
        self.init()
        self.analyses = analyses
    }
    
    required convenience init(coder: NSCoder) {
        self.init()
        analyses = coder.decodeObject(forKey: "analyses") as! [Analysis]
    }
    
  
    

}
