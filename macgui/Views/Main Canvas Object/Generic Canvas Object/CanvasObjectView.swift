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
    
    var isSelected: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    weak var delegate: CanvasObjectViewController? = nil
   
    enum State {
        case idle
        case source
        case target
    }
    
    
    var state: State = State.idle { didSet { needsLayout = true } }
    
    
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
    
    override func updateLayer() {
        layer?.masksToBounds =  false
        layer?.borderColor = NSColor.clear.cgColor
        
    }
    
   
    
    // MARK: - First Responder
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    override func becomeFirstResponder() -> Bool {return true}
    override func resignFirstResponder() -> Bool {return true}
    
    
//    MARK: - Mouse and Key Events
    
    override func mouseDown(with event: NSEvent) {
          let shiftKeyDown = (event.modifierFlags.rawValue &  NSEvent.ModifierFlags.shift.rawValue) != 0
        let delegate = self.delegate
          delegate?.setObjectViewSelected(flag: shiftKeyDown)
      }
    
        
    //   MARK: - Dragging Source
        
        public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
            guard case .idle = state else { return [] }
            state = .target
            return sender.draggingSourceOperationMask
        }
        
        public override func draggingExited(_ sender: NSDraggingInfo?) {
            guard case .target = state else { return }
            state = .idle
        }
        
        public override func draggingEnded(_ sender: NSDraggingInfo?) {
            guard case .target = state else { return }
            state = .idle
        }
        
        public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
            if let controller = sender.draggingSource as? ConnectionDragController {
                controller.connect(to: self)
                return true
            } else { return false }
        }
    
}

