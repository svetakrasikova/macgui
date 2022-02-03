//
//  CanvasObjectViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CanvasObjectViewController: NSViewController, NSWindowDelegate, ToolTipDelegate {
    
    var isPartOfMultipleSelection: Bool = false
    
    var viewSelected: Bool = false {
        didSet {
            if let view = view as? CanvasObjectView {
                view.isSelected = viewSelected
            }
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
    
    override func mouseEntered(with event: NSEvent) {
        if let view = view as? MovingCanvasObjectView {
            view.isMouseDown = true
            setPopoverTimers()
        }
        
    }
    
    override func mouseExited(with event: NSEvent) {
        if let view = view as? MovingCanvasObjectView {
                  view.isMouseDown = false
        }
        closePopover()
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
    
    
// MARK: -- Tooltip Popover
    let toolTipPopover: NSPopover = NSPopover()
    var startPopoverTimer: Timer?
    var closePopoverTimer: Timer?
    
    func setPopoverTimers(){
        guard let view = view as? MovingCanvasObjectView else { return }
        guard toolTipPopover.contentViewController != nil else { return }
        if !self.toolTipPopover.isShown, !view.isMouseDragged, !popOverTimersValid() {
            self.startPopoverTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(showPopover), userInfo: nil, repeats: false)
            self.closePopoverTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(closePopover), userInfo: nil, repeats: false)
        }
    }
    
    @objc func showPopover(){
        if self.view.window?.isMainWindow ?? true, let view = self.view as? MovingCanvasObjectView, view.isMouseDown {
        self.toolTipPopover.show(relativeTo: self.view.bounds, of: self.view, preferredEdge: NSRectEdge.minY)
        }
    }

    func invalidatePopoverTimers() {
        startPopoverTimer?.invalidate()
        closePopoverTimer?.invalidate()
    }
    
    func popOverTimersValid() -> Bool {
        guard let start = startPopoverTimer, let close = closePopoverTimer else { return false }
        return start.isValid && close.isValid
      
    }
    
    @objc func closePopover(){
        if self.toolTipPopover.isShown {
            self.toolTipPopover.close()
        }
        invalidatePopoverTimers()
    }
    
    func setPopOver(){
        toolTipPopover.contentViewController = NSStoryboard.loadVC(StoryBoardName.toolTip)
        if let toolTipPopoverVC = toolTipPopover.contentViewController as? ToolTipViewController{
            toolTipPopoverVC.delegate = self
        }
    }
    
    // MARK: - Tooltip Delegate
    
    func isConnected() -> Bool? {
        guard let connectable = self.tool as? Connectable else {
            return nil
        }
       return connectable.isConnected
    }
    
    func getDescriptiveToolName() -> String {
           if let toolName = self.tool?.descriptiveName { return toolName }
           return "Unnamed Tool"
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
            for loopVC in loopViewControllers {
                if let loop = loopVC.tool as? Loop {
                    loop.removeEmbeddedNode(tool)
                }
            }
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



