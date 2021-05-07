//
//  CanvasObjectViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasObjectViewController: NSViewController, NSWindowDelegate {
    
    var isPartOfMultipleSelection: Bool = false
    
    var viewSelected: Bool = false {
        didSet {
            (view as! CanvasObjectView).isSelected = viewSelected
            if viewSelected && !isPartOfMultipleSelection {
                NotificationCenter.default.post(name: .didSelectCanvasObjectController, object: self)
            }
        }
    }
    
    weak var tool: ToolObject?
    
    weak var outerLoopViewController: ResizableCanvasObjectViewController?
    
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
    
//  MARK: -- Loop Inclusion
    
    func checkForLoopInclusion() {
        guard let tool = self.tool as? Connectable else { return }
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return }
        let loopViewControllers = canvasVC.children.filter {$0.isKind(of: ResizableCanvasObjectViewController.self)} as! [ResizableCanvasObjectViewController]
        if let smallestOuterLoop = findSmallestOuterLoopFrom(loopViewControllers), let newLoop = smallestOuterLoop.tool as? Loop {
            newLoop.addEmbeddedNode(tool)
            if let outerloopViewController = outerLoopViewController, let currentLoop = outerloopViewController.tool as? Loop, currentLoop !== newLoop {
                currentLoop.removeEmbeddedNode(tool)
            }
            outerLoopViewController = smallestOuterLoop
        } else {
            outerLoopViewController = nil
        }
    }
    
    func isIncludedInLoop(_ loopVC: ResizableCanvasObjectViewController) -> Bool {
        let isIncluded = loopVC.view.frame.intersection(self.view.frame) == self.view.frame
        return  isIncluded
    }
    func findSmallestOuterLoopFrom(_ list: [ResizableCanvasObjectViewController]) -> ResizableCanvasObjectViewController? {
        let newList = list.filter {self.isIncludedInLoop($0)}
        var smallest: ResizableCanvasObjectViewController?
        for vc in newList {
            if let current = smallest {
                if vc.isIncludedInLoop(current) { smallest = vc }
            } else { smallest = vc }
        }
        return smallest
    }
    
}




extension CanvasObjectViewController: CanvasObjectViewDelegate {
   
    func setObjectViewSelected(flag: Bool) {
        isPartOfMultipleSelection = flag
        viewSelected = true
    }
    
    func updateFrame(){
        let size = view.frame.size
        let origin = view.frame.origin
        tool?.frameOnCanvas = NSRect(origin: origin, size: size)
    }
       
}



