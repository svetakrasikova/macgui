//
//  CanvasObjectView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasObjectView: NSView {
    
    enum Appearance {
        static let selectionCornerRadius: CGFloat = 5.0
        static let selectionWidth: CGFloat = 2.0
        static let selectionColor: CGColor = NSColor.selectedKnobColor.cgColor
        
    }
    
    override var wantsUpdateLayer: Bool {return true}
    
    var delegate: CanvasObjectViewDelegate?
    
    // MARK: - First Responder    
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {return true}
    override func resignFirstResponder() -> Bool {return true}
    
    
    var isSelected: Bool = false
    { didSet { needsDisplay = true } }
   

    
    override func mouseDown(with event: NSEvent) {
        let shiftKeyDown = (event.modifierFlags.rawValue &  NSEvent.ModifierFlags.shift.rawValue) != 0
        delegate?.setObjectViewSelected(flag: shiftKeyDown)
    }
    
}

protocol CanvasObjectViewDelegate {
    func setObjectViewSelected(flag: Bool)
}
