//
//  InfoButton.swift
//  macgui
//
//  Created by Svetlana Krasikova on 6/27/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ActionButton: NSButton {

    enum ButtonState {
        case idle
        case pressed
        case highlighted
    }
    
    enum ActionButtonType {
        case Info
        case Inspector
        case Default
    }
    
    override var isHidden: Bool {
        didSet {
            if let delegate = self.delegate, delegate.isDisplayDataTool() {
                needsLayout = true
            }
        }
        
    }
    
    private let shapeLayer = CAShapeLayer()
    
    var buttonState: ButtonState = .idle { didSet { needsLayout = true } }
    
    var mouseIsInside = false
    
    var labelColor: CGColor? = NSColor.white.cgColor
    
    var buttonType: ActionButtonType {
        switch tag {
        case 0:
            return .Info
        case 1:
            return .Inspector
        default:
            return .Default
        }
    }
    
    weak var delegate: ActionButtonDelegate?
    
    private var observer: NSKeyValueObservation?
    
    func observeDataChange(){
        if let delegate = self.delegate, delegate.isDisplayDataTool(), let toolVC = delegate as? CanvasToolViewController {
            let tool = toolVC.tool as! DataTool
            self.observer = tool.observe(\DataTool.dataMatrices, options: [.initial]) {(tool, change) in
                if self.buttonType == .Inspector {
                    if tool.dataMatrices.isEmpty { self.isHidden = true} else { self.isHidden = false }
                }
            }
       }
    }
    
    override func mouseEntered(with event: NSEvent) {
        mouseIsInside = true
        buttonState = .highlighted
    }
    
    override func mouseExited(with event: NSEvent) {
        mouseIsInside = false
        buttonState = .idle
    }

    override func mouseDown(with event: NSEvent) {
        buttonState = .pressed
    }
    
    
    override func mouseUp(with event: NSEvent) {
        if mouseIsInside {
            switch buttonType {
            case .Info:
                print("from mouse up")
                delegate?.infoButtonClicked()
            case .Inspector:
                delegate?.inspectorButtonClicked()
            default:
                print("No default action button implemented.")
            }
        } else {
            buttonState = .idle
        }
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        wantsLayer = true
        observeDataChange()
    }
   
    override func updateTrackingAreas() {
        self.addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow], owner: self, userInfo: nil))
    }
    override func makeBackingLayer() -> CALayer {
        return shapeLayer
    }
    
    override func layout() {
        super.layout()
        setAppearanceForState()
        shapeLayer.path = CGPath(ellipseIn: bounds, transform: nil)
        switch buttonType {
        case .Info:
            if  let backingScaleFactor = self.window?.backingScaleFactor {
                shapeLayer.contentsScale = backingScaleFactor * 4
                addInfoLabel(scaleFactor: backingScaleFactor * 4)
            }
        case .Inspector:
            addMagnifierImage()
        default:
            addDefaultImage()
        }
    }
    
    
    private func addInfoLabel(scaleFactor: CGFloat) {
        let textLayer = CATextLayer()
        textLayer.frame = bounds
        textLayer.contentsScale = scaleFactor
        textLayer.font = "Hoefler Text" as CFTypeRef
        textLayer.foregroundColor = self.labelColor
        textLayer.fontSize = 7
        textLayer.string = "i"
        textLayer.allowsFontSubpixelQuantization = true
        textLayer.position = bounds.center()
        textLayer.alignmentMode = .center;
        shapeLayer.addSublayer(textLayer)
    }
   
    private func addMagnifierImage() {
        if !isHidden {
            let imageLayer = CALayer()
            imageLayer.backgroundColor = NSColor.clear.cgColor
            imageLayer.frame = bounds
            imageLayer.contents = NSImage(named: "Magnifier")
            shapeLayer.addSublayer(imageLayer)
        }
    }
    
    private func addDefaultImage() {
        let imageLayer = CALayer()
        imageLayer.backgroundColor = NSColor.clear.cgColor
        imageLayer.frame = bounds
        imageLayer.contents = NSImage(named: "AppIcon")
        shapeLayer.addSublayer(imageLayer)
    }
    
    private func setAppearanceForState() {
        switch buttonState {
        case .pressed:
            shapeLayer.fillColor = NSColor.lightGray.cgColor
        case .highlighted:
            shapeLayer.fillColor = NSColor.darkGray.cgColor
        case .idle:
            shapeLayer.fillColor = NSColor.clear.cgColor
        }
    }
}

protocol ActionButtonDelegate: class {
    func infoButtonClicked()
    func inspectorButtonClicked()
    func isDisplayDataTool() -> Bool
}


