//
//  CanvasObjectView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasObjectView: NSView {
    
    override var wantsUpdateLayer: Bool {return true}
    var firstMouseDownPoint: NSPoint?
    var isSelected: Bool = false
    { didSet { needsDisplay = true } }
    
    weak var delegate: CanvasObjectViewController? = nil
    
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: kUTTypeData as String)])
    }
    
    // MARK: - First Responder
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {return true}
    override func resignFirstResponder() -> Bool {return true}
    
    
//   MARK: - Mouse and Key Events

    override func mouseDown(with event: NSEvent) {
        let shiftKeyDown = (event.modifierFlags.rawValue &  NSEvent.ModifierFlags.shift.rawValue) != 0
        delegate?.setObjectViewSelected(flag: shiftKeyDown)
        firstMouseDownPoint = (self.window?.contentView?.convert(event.locationInWindow, to: self))!
    }
    
    override func mouseDragged(with event: NSEvent) {
        if let newPoint = self.window?.contentView?.convert(event.locationInWindow, to: self), let firstMouseDownPoint = firstMouseDownPoint {
            let offset = NSPoint(x: newPoint.x - firstMouseDownPoint.x, y: newPoint.y - firstMouseDownPoint.y)
            let origin = self.frame.origin
            let newOrigin = NSPoint(x: origin.x + offset.x, y: origin.y + offset.y)
            delegate?.updateFrame()
            self.setFrameOrigin(newOrigin)
        }
    }
      
      override func mouseUp(with event: NSEvent) {
          delegate?.updateFrame()
      }
      
      override func viewDidEndLiveResize() {
          super.viewDidEndLiveResize()
          delegate?.updateFrame()
      }
    
    override func updateLayer() {
        layer?.masksToBounds =  false
        layer?.borderColor = NSColor.clear.cgColor
        
    }
}

//   MARK: - CanvasObjectViewDelegate Protocol

protocol CanvasObjectViewDelegate: class {
    func setObjectViewSelected(flag: Bool)
    func updateFrame()
}
