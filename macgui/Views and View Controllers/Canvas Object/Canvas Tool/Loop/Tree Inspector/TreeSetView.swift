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
        case tree, backgroundImage
    }
    
    weak var delegate: TreeSetViewDelegate?
   
    var tree: Tree
    
    let backgroundImage: NSImage
    
    enum Attributes: String {
        case fontSize, lineWidth, treeArea, labelArea, labelAttributes, color, biggestNameRect
    }
    
    var treeAttributes: [String : Any] {
        
        var treeAttributes: [String : Any] = [:]
        let fontSize = chooseFontSize(for: bounds.size.width, numberOfLabels: tree.numberOfTaxa)
        let labelAttributes: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: fontSize)]
        let biggestNameRect = self.biggestNameRect(attributes: labelAttributes)
        let treeArea = getPrintableAreaRect(biggestNameRect: biggestNameRect)
        let labelArea = getLabelArea(treeArea: treeArea, biggestNameRect: biggestNameRect)
        let lineWidth = chooseLineWidthFor(numberOfTaxa: tree.numberOfTaxa)
        
        
        treeAttributes[Attributes.fontSize.rawValue] = fontSize
        treeAttributes[Attributes.biggestNameRect.rawValue] = biggestNameRect
        treeAttributes[Attributes.lineWidth.rawValue] = lineWidth
        treeAttributes[Attributes.treeArea.rawValue] = treeArea
        treeAttributes[Attributes.labelArea.rawValue] = labelArea
        treeAttributes[Attributes.labelAttributes.rawValue] = labelAttributes
        treeAttributes[Attributes.color.rawValue] = NSColor.black.withAlphaComponent(1.0)
       
        return treeAttributes
    }
    
    init(image: NSImage, tree: Tree){
        self.backgroundImage = image
        self.tree = tree
        let frame = NSRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        backgroundImage = coder.decodeObject(forKey: Key.backgroundImage.rawValue) as! NSImage
        tree = coder.decodeObject(forKey: Key.tree.rawValue) as! Tree
        super.init(coder: coder)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(backgroundImage, forKey: Key.backgroundImage.rawValue)
        coder.encode(tree, forKey: Key.tree.rawValue)
        super.encode(with: coder)
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
   
        backgroundImage.draw(in: bounds, from: NSRect(origin: NSZeroPoint, size: backgroundImage.size), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        
        if let delegate = self.delegate, let nodes = delegate.nodesWithCoordinates(tree: self.tree) {
            drawTree(nodesWithCoordinates: nodes, treeAttributes: self.treeAttributes)
        }
    }
    
}

protocol TreeSetViewDelegate: AnyObject {
    
    func biggestNameRect(attributes: [NSAttributedString.Key: Any], tree: Tree) -> NSRect
    func nodesWithCoordinates(tree: Tree) -> [Node]?
}

extension TreeSetView {
    
    func getLabelArea(treeArea: NSRect, biggestNameRect: NSRect) -> NSRect {
        
        let gap = biggestNameRect.size.height * 0.5
        var labelArea = treeArea
        labelArea.origin.y += treeArea.size.height + gap
        labelArea.size.height = biggestNameRect.size.width
        
        return labelArea
    }
    
    func getPrintableAreaRect(biggestNameRect: NSRect) -> NSRect {
        
        let gap = biggestNameRect.size.height * 0.5
        let printableW = 0.84 * bounds.size.width
        let printableH = 0.53 * bounds.size.height
        let bottomBuffer: CGFloat = 25.0;
        let sideMargin = printableW * 0.04
        let drawableArea = NSMakeRect((bounds.size.width-printableW)*0.5,(bounds.size.height-printableH)*0.5,printableW, printableH)
        var treeArea = drawableArea;
        treeArea.origin.x += sideMargin
        treeArea.origin.y += (5.0 + bottomBuffer)
        treeArea.size.width -= 2.0 * sideMargin
        treeArea.size.height -= (10.0 + bottomBuffer + biggestNameRect.size.width + gap)
        return treeArea
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
    
    
    func chooseLineWidthFor(numberOfTaxa: Int) -> CGFloat {
        switch numberOfTaxa {
        case 0..<50: return 1.0
        case 50..<75: return 0.8
        case 75..<100: return 0.6
        case 100..<125: return 0.4
        case 125..<150: return 0.2
        default: return 0.1
        }
    }
    
    func biggestNameRect(attributes: [NSAttributedString.Key : Any]) -> NSRect {
       
        var biggestNameRect: NSRect = NSZeroRect
        for node in self.tree.tSequence {
            if node.isLeaf {
                let taxonName = node.name
                let attributedString = NSAttributedString(string: taxonName, attributes: attributes)
                let textSize = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
                if textSize.size.width > biggestNameRect.size.width {
                    biggestNameRect.size.width = textSize.size.width
                }
                if textSize.size.height > biggestNameRect.size.height {
                    biggestNameRect.size.height = textSize.size.height
                }
            }
        }
        
        return biggestNameRect
    }
    
    
    func drawTree(nodesWithCoordinates: [Node], treeAttributes: [String : Any]) {
        
        let labelArea = treeAttributes[Attributes.labelArea.rawValue] as! NSRect
        let labelAttributes = treeAttributes[Attributes.labelAttributes.rawValue] as! [NSAttributedString.Key: Any]
        let lineWidth = treeAttributes[Attributes.lineWidth.rawValue] as! CGFloat
        let bounds = treeAttributes[Attributes.treeArea.rawValue] as! NSRect
        let color = treeAttributes[Attributes.color.rawValue] as! NSColor
        let biggestNameRect = treeAttributes[Attributes.biggestNameRect.rawValue] as! NSRect
        
        
        NSBezierPath.defaultLineWidth = lineWidth
        color.set()
        

        let xOffset = bounds.origin.x - self.bounds.origin.x
        let yOffset = bounds.origin.y - self.bounds.origin.y
        
        for node in nodesWithCoordinates {
  
            var a = NSZeroPoint, b = NSZeroPoint
            a.x = xOffset + bounds.size.width * node.x
            a.y = yOffset + bounds.size.height * node.y
            
            if node.isRoot {
        
                b.x = xOffset + bounds.size.width * node.x
                b.y = yOffset
           
            } else if let ancestor = node.ancestor {
         
                b.x = xOffset + bounds.size.width *  node.x
                b.y = yOffset + bounds.size.height * ancestor.y
                
            }
            
            NSBezierPath.strokeLine(from: a, to: b)
            
            if !node.isLeaf {
                
                var l = a, r = a
                l.x = xOffset + bounds.size.width
                r.x = 0.0
                
                for d in node.descendants {
                    
                    let dX = xOffset + bounds.size.width * d.x
                    if  dX < l.x { l.x = dX }
                    if  dX > r.x { r.x = dX }
                    
                }
                
                NSBezierPath.strokeLine(from: l, to: r)
                
                
            } else {
                
                var drawPoint = NSZeroPoint
               
                drawPoint.x = xOffset + labelArea.size.width * node.x
                drawPoint.y = labelArea.origin.y
                drawPoint.x += biggestNameRect.size.height * 0.5
                
                NSGraphicsContext.saveGraphicsState()
                let taxonName = node.name
                let attrString = NSAttributedString(string: taxonName, attributes: labelAttributes)
                let xform = NSAffineTransform()
                xform.translateX(by: drawPoint.x, yBy: drawPoint.y)
                xform.rotate(byDegrees: 90.0)
                xform.translateX(by: -drawPoint.x, yBy: -drawPoint.y)
                xform.concat()
                attrString.draw(at: drawPoint)
                NSGraphicsContext.restoreGraphicsState()
            }
        }

        
    }
    
}
