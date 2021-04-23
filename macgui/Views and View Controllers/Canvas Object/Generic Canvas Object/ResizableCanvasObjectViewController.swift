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
    
    var resizableView: ResizableCanvasObjectView { return self.view as! ResizableCanvasObjectView}
    
    var loop: Loop { return self.tool as! Loop }
    
    private var observers = [NSKeyValueObservation]()
    
   func observeLabelChange(){
        
        if let loop = tool as? Loop {
            
            self.observers = [
                loop.observe(\Loop.upperRange, options: [.initial]) {_,_  in
                    self.view.self.needsDisplay = true },
                loop.observe(\Loop.index, options: [.initial]) {_,_  in
                    self.view.self.needsDisplay = true },
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.unregisterDraggedTypes()
        view.wantsLayer = true
        if let backgroundColor = resizableView.backgroundColor {
            resizableView.drawLayerContents(fillcolor: backgroundColor, strokeColor: NSColor.systemGray, dash: false, anchors: false)
        }
        setUp()
        observeLabelChange()
    }
    
    func setUp() {
        setBackgroundColor()
        setLabel()
        addActionButton()
    }
    
   
    
//    MARK: -- Background and Label
    
    func  setBackgroundColor() {}
    
    func setLabel() {
        setLabelText()
        setLabelFrameOrigin()
    }
    
    func setLabelText() {
        let upperRange: String = loop.upperRange == 1 ?
            "\(loop.upperRange)" : "(1,...,\(loop.upperRange))"
        resizableView.labelText = "\(loop.index) \(Symbol.element.rawValue) \(upperRange)"
    }
    
    
    func setLabelFrameOrigin() {
        guard let labelText = resizableView.labelText else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: NSFont(name: "Hoefler Text", size: resizableView.labelFontSize) as Any]
        let attributedString = NSAttributedString(string: labelText, attributes: attributes)
        let frame = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
        let origin = NSPoint(x: resizableView.insetFrame.maxX - frame.width - 2.0, y: resizableView.insetFrame.minY + 2.0 )
        resizableView.labelFrame = frame
        resizableView.labelFrame?.origin = origin
        
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
