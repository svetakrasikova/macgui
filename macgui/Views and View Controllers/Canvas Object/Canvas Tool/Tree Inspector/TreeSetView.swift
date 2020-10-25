//
//  TreeSetView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/19/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSetView: NSView {
    
    enum Key: String {
        case tree
    }
    
    weak var delegate: TreeSetViewDelegate?
    
    var tree: Tree
    
    var fontSize: CGFloat {
        let numberOfLabels = self.tree.numberOfTaxa
        return chooseFontSize(for: bounds.size.width, numberOfLabels: numberOfLabels)
    }
    
    var labelAttributes: [NSAttributedString.Key: Any] {
        [.font: NSFont.systemFont(ofSize: self.fontSize)]
    }
    
    var biggestNameRect: NSRect? {
        var rect: NSRect?
        if let delegate = self.delegate {
            rect = delegate.biggestNameRect(attributes: labelAttributes, tree: self.tree)
        }
        return rect
    }
    
    init(frame: NSRect, tree: Tree){
        self.tree = tree
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        tree = coder.decodeObject(forKey: Key.tree.rawValue) as! Tree
        super.init(coder: coder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(tree, forKey: Key.tree.rawValue)
        super.encode(with: coder)
    }
    
    
    func drawTree(nodesWithCoordinates: [Node], attributes: [NSAttributedString.Key: Any]) {
        
        guard let biggestNameRect = self.biggestNameRect else { return }
        guard let drawMonophyleticWrOutgroup = self.delegate?.isDrawMonophyleticWrOutgroup() else { return }
        
        NSBezierPath.defaultLineWidth = 1.0
        NSColor.black.withAlphaComponent(1.0).set()
        
        let factor: CGFloat = 0.95
        let xOffset = bounds.size.width * 0.025
        let yOffset = bounds.size.height * 0.025
        let xStart = xOffset
        let xEnd = bounds.size.height * factor - biggestNameRect.size.width
        let h = xEnd - xStart;
        
        for node in nodesWithCoordinates {
  
            var a = NSZeroPoint, b = NSZeroPoint
            a.x = xOffset + bounds.size.width * factor * node.x
            a.y = yOffset + h * node.y
            
            if node.isRoot {
                
                b.x = xOffset + bounds.size.width * factor * node.x
                b.y = yOffset
            } else if let ancestor = node.ancestor {
                
                b.x = xOffset + bounds.size.width * factor * node.x
                b.y = yOffset + h * ancestor.y
                
                if ancestor === self.tree.root, drawMonophyleticWrOutgroup,
                   node === ancestor.descendants.first {
                    b.y = yOffset
                }
            }
            
            NSBezierPath.strokeLine(from: a, to: b)
            
            if !node.isLeaf {
                var l = NSZeroPoint, m = NSZeroPoint, r = NSZeroPoint
            
                if node.isRoot, drawMonophyleticWrOutgroup {
                    
                    m.x = xOffset + bounds.size.width * factor * node.x
                    m.y = a.y
                    l.x = xOffset + bounds.size.width * factor * node.descendants[1].x - CGFloat(0.5*1.0);
                    l.y = a.y
                    r.x = xOffset + bounds.size.width * factor * node.descendants.last!.x + CGFloat(0.5*1.0);
                    r.y = a.y
                } else {
                    
                    m.x = xOffset + bounds.size.width * factor * node.x;
                    m.y = a.y
                    l.x = xOffset + bounds.size.width * factor * node.descendants.first!.x - CGFloat(0.5*1.0);
                    l.y = a.y
                    r.x = xOffset + bounds.size.width * factor * node.descendants.last!.x + CGFloat(0.5*1.0);
                    r.y = a.y
                }
                NSBezierPath.strokeLine(from: l, to: m)
                NSBezierPath.strokeLine(from: r, to: m)
                
            } else {
                
                var drawPoint = NSZeroPoint
                drawPoint.x = xOffset + bounds.size.width * factor * node.x
                drawPoint.y = yOffset + bounds.size.height * factor * node.y
                drawPoint.x += biggestNameRect.size.height * 0.5
                drawPoint.y -= biggestNameRect.size.width
                NSGraphicsContext.saveGraphicsState()
                let taxonName = node.name
                let attrString = NSAttributedString(string: taxonName, attributes: attributes)
                let xform = NSAffineTransform()
                xform.translateX(by: drawPoint.x, yBy: drawPoint.y)
                xform.rotate(byDegrees: 90.0)
                xform.translateX(by: -drawPoint.x, yBy: -drawPoint.y)
                xform.concat()
                attrString.draw(at: drawPoint)
                NSGraphicsContext.restoreGraphicsState()
            }
        }
        
        if drawMonophyleticWrOutgroup {
            
            var a = NSZeroPoint, b = NSZeroPoint
            guard let root = self.tree.root else { return }
            a.x = xOffset + bounds.size.width * factor * root.descendants.first!.x
            a.y = yOffset
            b.x = xOffset + bounds.size.width * factor * root.x;
            b.y = yOffset
            NSBezierPath.strokeLine(from: a, to: b)
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        if let delegate = self.delegate, let nodes = delegate.nodesWithCoordinates(tree: self.tree) {
            drawTree(nodesWithCoordinates: nodes, attributes: self.labelAttributes)
        }
    }
    
    func chooseFontSize(for width: CGFloat, numberOfLabels: Int) -> CGFloat {
        for i in (1...100).reversed(){
            let s: CGFloat = (CGFloat(i)+1) * 0.2
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: s)]
            let str = "THIS IS A SIMPLE STRING"
            let attributedString = NSAttributedString(string: str, attributes: attributes)
            let textSize = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
            if textSize.size.height * CGFloat(numberOfLabels) < width {
                return s
            }
        }
        return 1.0
    }

    
}

protocol TreeSetViewDelegate: class {
    
    func biggestNameRect(attributes: [NSAttributedString.Key: Any], tree: Tree) -> NSRect
    func nodesWithCoordinates(tree: Tree) -> [Node]?
    func isDrawMonophyleticWrOutgroup() -> Bool
}
