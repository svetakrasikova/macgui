//
//  Loop.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/9/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers

class Loop: ToolObject {
    
    enum CodingKeys: String {
        case outerLoop, embeddedNodes, index, upperRange
    }
  
    var outerLoop: Loop? {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    var embeddedNodes: [Connectable] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var index: String {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    dynamic var upperRange: Int = 1 {
        didSet {
            NotificationCenter.default.post(name: .didUpdateDocument, object: nil)
        }
    }
    
    
    init(frameOnCanvas: NSRect, analysis: Analysis, index: String){
        self.index = index
        super.init(name: ToolType.loop.rawValue, frameOnCanvas: frameOnCanvas, analysis: analysis)
    }
    
    
    override func encode(with coder: NSCoder) {
        coder.encode(outerLoop, forKey: CodingKeys.outerLoop.rawValue)
        coder.encode(embeddedNodes, forKey: CodingKeys.embeddedNodes.rawValue)
        coder.encode(index, forKey: CodingKeys.index.rawValue)
        coder.encode(upperRange, forKey: CodingKeys.upperRange.rawValue)
        super.encode(with: coder)
    }
    
    required init?(coder decoder: NSCoder) {
        outerLoop = decoder.decodeObject(forKey: CodingKeys.outerLoop.rawValue) as? Loop
        embeddedNodes = decoder.decodeObject(forKey: CodingKeys.embeddedNodes.rawValue) as? [Connectable] ?? []
        index = decoder.decodeObject(forKey: CodingKeys.index.rawValue) as? String ?? "i"
        upperRange = decoder.decodeInteger(forKey: CodingKeys.upperRange.rawValue)
        super.init(coder: decoder)
    }
    
    func indexPath() -> String {
        var path = index
        if let outerLoop = self.outerLoop {
            path = outerLoop.indexPath() + path
            return path
        } else {
            return path
        }
    }
    
    func embedLevel() -> Int {
        guard let outerLoop = outerLoop else { return 0 }
        return outerLoop.embedLevel() + 1
    }
    
    func updateOuterLoop(_ loop: Loop) {
        if outerLoop !== loop {
            outerLoop = loop
        }
    }
    
    func addEmbeddedNode(_ node: Connectable){
        if embeddedNodes.firstIndex(of: node) == nil {
            embeddedNodes.append(node)
        }
    }
    
    func removeEmbeddedNode(_ node: Connectable) {
        if let index = embeddedNodes.firstIndex(of: node) {
            embeddedNodes.remove(at: index)
        }
    }
    
    func contains(node: Connectable) -> Bool {
        return embeddedNodes.contains(node)
    }

}
