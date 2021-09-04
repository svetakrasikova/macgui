//
//  TreePlate.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlate: Plate {
    
    enum Keys: String {
        case model
    }
    weak var model: Model?
    
    
    var internalNodes: [ModelNode] = []
    var internalBranches: [ModelNode] = []
    var tipNodes: [ModelNode] = []
    var tipBranches: [ModelNode] = []
    var root: ModelNode?
   
    override init(frameOnCanvas: NSRect, analysis: Analysis, index: String){
        super.init(frameOnCanvas: frameOnCanvas, analysis: analysis, index: index)
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(model, forKey: Keys.model.rawValue)
    }
    
    required init?(coder: NSCoder) {
        model = coder.decodeObject(forKey: Keys.model.rawValue) as? Model
        super.init(coder: coder)
    }
    
    func removeFromPanels(_ node: Connectable) {
        if root === node {
            root = nil
        } else {
            if let index = internalNodes.firstIndex(of: node as! ModelNode) {
                internalNodes.remove(at: index)
                return
            }
            if let index = internalBranches.firstIndex(of: node as! ModelNode) {
                internalBranches.remove(at: index)
                return
            }
            if let index = tipNodes.firstIndex(of: node as! ModelNode) {
                tipNodes.remove(at: index)
                return
            }
            if let index = tipBranches.firstIndex(of: node as! ModelNode) {
                tipBranches.remove(at: index)
                return
            }
            
        }
    }
    
    override func removeEmbeddedNode(_ node: Connectable) {
        super.removeEmbeddedNode(node)
        removeFromPanels(node)
    }
}

   
    
    
