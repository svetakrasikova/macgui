//
//  CanvasObjectViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasObjectViewController: NSViewController, NSWindowDelegate {
    
    var shiftKeyPressed: Bool = false
    
    var viewSelected: Bool = false {
        didSet {
            (view as! CanvasObjectView).isSelected = viewSelected
            if viewSelected && !shiftKeyPressed {
                NotificationCenter.default.post(name: .didSelectCanvasObjectController, object: self)
            }
        }
    }
    
    weak var tool: ToolObject?
    
// MARK: - Mouse and Key Events
    
    override func keyDown(with event: NSEvent) {
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            NotificationCenter.default.post(name: .didSelectDeleteKey, object: self)
        }

    }
    
// MARK: - Selectors for Observed Notifications
    
    func windowDidResize(_ notification: Notification) {
        updateFrame()
    }
    
// MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = NSApp.windows.first { window.delegate = self}
        (self.view as! CanvasObjectView).delegate = self
         NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowDidResize(_:)), name: NSWindow.didResizeNotification, object: nil)
    }
}


extension CanvasObjectViewController: CanvasObjectViewDelegate {
   
    func setObjectViewSelected(flag: Bool) {
        shiftKeyPressed = flag
        viewSelected = true
    }
    
    func updateFrame(){
            let size = tool?.frameOnCanvas.size
            let origin = view.frame.origin
            tool?.frameOnCanvas = NSRect(origin: origin, size: size!)
        }
       
}
