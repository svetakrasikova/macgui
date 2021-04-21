//
//  ResizableCanvasObjectViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/12/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ResizableCanvasObjectViewController: CanvasObjectViewController, ActionButtonDelegate {
    
    var actionButton: ActionButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        view.unregisterDraggedTypes()
        view.wantsLayer = true
        if let backgroundColor = view.backgroundColor {
            view.drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.systemGray, dash: false, anchors: false)
        }
        setUp()
    }
    
    func setUp() {
        setBackgroundColor()
        setLabel()
        addActionButton()
    }
    
   
    
//    MARK: -- Background and Label
    
    func  setBackgroundColor() {}
    
    func setLabel() {
        if let loop = self.tool as? Loop, let view = view as? ResizableCanvasObjectView {
            setLabelTextFor(view, loop: loop)
            let attributes: [NSAttributedString.Key: Any] = [.font: NSFont(name: "Hoefler Text", size: view.labelFontSize) as Any]
            let attributedString = NSAttributedString(string: view.labelText!, attributes: attributes)
            view.labelFrame = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
            setLabelFrameOrigin(view)
            
        }
    }
    
    func setLabelTextFor(_ view: ResizableCanvasObjectView, loop: Loop) {
        let upperRange: String = loop.upperRange == 1 ?
            "\(loop.upperRange)" : "(1,...,\(loop.upperRange))"
        view.labelText = "\(loop.index) \(Symbol.element.rawValue) \(upperRange)"

        
    }
    
    func setLabelFrameOrigin(_ view: ResizableCanvasObjectView) {
        if let labelFrame = view.labelFrame {
            let origin = NSPoint(x: view.insetFrame.maxX - labelFrame.width - 2.0, y: view.insetFrame.minY + 2.0 )
            view.labelFrame?.origin = origin
        }
    }
    
//    MARK: -- Action Button
    
    func addActionButton(){
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        guard let fillColor = view.backgroundColor else { return }
        let infoButton = ActionButton()
        let buttonWidth: CGFloat = 8.0
        let buttonHeight: CGFloat = 8.0
        if fillColor.isLight() ?? true { infoButton.labelColor = NSColor.black }
        infoButton.frame = CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: buttonHeight))
        infoButton.tag = 0
        infoButton.isTransparent = true
        infoButton.setButtonType(.momentaryPushIn)
        self.view.addSubview(infoButton)
        infoButton.delegate = self
        actionButton = infoButton
        setActionButtonOrigin()
        actionButton?.needsLayout = true
    }
    
    func updateActionButton() {
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        guard let fillColor = view.backgroundColor else { return }
        if let button = self.actionButton {
            if fillColor.isLight() ?? true {
                button.labelColor = NSColor.black
            } else {
                button.labelColor = NSColor.white
            }
            setActionButtonOrigin()
            view.addSubview(button)
            button.needsLayout = true
        }
    }
    
    func setActionButtonOrigin() {
        guard let button = self.actionButton else { return }
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        let width = button.frame.width
        let height = button.frame.height
        button.frame.origin = CGPoint(x: view.insetFrame.maxX - width - 2.0, y: view.insetFrame.maxY - height - 2.0)
    }
    
    func addActionButtonView() {
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        guard let fillColor = view.backgroundColor else { return }
        if let button = self.actionButton {
            if fillColor.isLight() ?? true {
                button.labelColor = NSColor.black
            } else {
                button.labelColor = NSColor.white
            }
            view.addSubview(button)
            button.needsLayout = true
        }
    }
    
    func actionButtonClicked(_ button: ActionButton) {
        
    }
    
    // MARK: -- Key Events
    
    override func mouseEntered(with event: NSEvent) {
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        if !view.isMouseDown {
            actionButton?.mouseEntered(with: event)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        guard let view = self.view as? ResizableCanvasObjectView else { return }
        if !view.isMouseDown {
            actionButton?.mouseExited(with: event)
        }
       
    }
    
    
//    MARK: -- Inclusion
    
    override func checkForLoopInclusion(){
        guard let loop = self.tool as? Loop else { return }
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return }
        let loopViewControllers = canvasVC.children.filter {$0.isKind(of: ResizableCanvasObjectViewController.self) && $0 !== self} as! [ResizableCanvasObjectViewController]
        if let smallestOuterLoop = findSmallestOuterLoopFrom(loopViewControllers) {
            loop.updateOuterLoop(smallestOuterLoop.tool as! Loop)
            print(self, "outerloop found: ", smallestOuterLoop)
        }
        for node in loop.embeddedNodes {
            if let toolVC = canvasVC.findVCByTool(node) {
                toolVC.checkForLoopInclusion()
            }
        }
    }

}
