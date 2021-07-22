//
//  EdgeView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/20/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class EdgeView: NSView {

    weak var delegate: EdgeViewDelegate?
    
    override func updateLayer() {
        delegate?.updateEdgeInLayer()
    }
    
}

protocol EdgeViewDelegate: AnyObject {
    func updateEdgeInLayer()

}


