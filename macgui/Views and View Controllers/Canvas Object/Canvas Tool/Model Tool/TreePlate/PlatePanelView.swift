//
//  PlatePanelView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/24/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class PlatePanelView: NSView {
    
    
    enum PanelType: Int, CaseIterable {
        case root, internals, tips
    }
    
    override var frame: CGRect {
        didSet {
            if let delegate = self.delegate, let labelFrame = delegate.platePanelViewFrame(view: self){
                label.frame = labelFrame
               
                
            }
        }
    }

    var label =  CATextLayer()
   
    var nodeType: Int?
    
    var nodeTypeString: String {
        var str = ""
        switch nodeType {
        case PanelType.root.rawValue:
            str = "root node"
        case PanelType.internals.rawValue:
            str = branchPanel ? "branches to internal nodes" : "internal nodes"
        case PanelType.tips.rawValue:
            str = branchPanel ? "branches to tips" : "tip nodes"
        default: break
        }
        return str
    }

    var branchPanel: Bool = false
    
    
    weak var delegate: PlatePanelViewDelegate?
    
    var labelFontSize: CGFloat = 8.0
    
    var labelText: String? {
        guard let delegate = self.delegate, let nodeType = self.nodeType else
        {
            return nil
        }
        return delegate.platePanelViewLabel(nodeType: nodeType)
    }
    
    var labelFrame: NSRect? {
        guard let delegate = self.delegate else
        {
            return nil
        }
        return delegate.platePanelViewFrame(view: self)
    }
    
    
    func addIndexLabel() {
        setUpTextLabel(label, fontSize: labelFontSize)
        setLabelText()
        setLabelFrame()
        layer?.addSublayer(label)
    }

    
    
    func setUpTextLabel(_ label: CATextLayer, fontSize: CGFloat) {
        if  var backingScaleFactor = self.window?.backingScaleFactor {
            backingScaleFactor *= 4
            label.contentsScale = backingScaleFactor
        }
        label.font = NSFont(name: "Hoefler Text", size: fontSize)
        label.fontSize = labelFontSize
        label.backgroundColor = NSColor.clear.cgColor
        label.foregroundColor = NSColor.black.cgColor
        label.alignmentMode = .center
    }
    
    
    func setLabelText() {
        guard let text = labelText else  { return }
        label.setAttributedTextWithItalics(text: text, indicesOfSubscripts: [0])
    }
    
    
    func setLabelFrame() {
        guard let frame = labelFrame else { return }
        label.frame = frame
    }

    
    
    override func updateLayer() {
        super.updateLayer()
        if branchPanel {
            label.string = labelText
        }
     
    }
    

}

protocol PlatePanelViewDelegate: AnyObject {
    func platePanelViewLabel(nodeType: Int) -> String
    func platePanelViewFrame(view: PlatePanelView) -> NSRect?
}

