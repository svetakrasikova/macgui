//
//  CharacterCellView.swift
//  
//
//  Created by Svetlana Krasikova on 12/19/19.
//

import Cocoa

class CharacterCellView: NSTableCellView{
    
    static let characterCellSize: CGFloat = 18.0
    
    var characterString: String?

    var viewSize: NSSize {
        let defaultCellSize = NSSize(width: CharacterCellView.characterCellSize, height: CharacterCellView.characterCellSize)
        guard let characterString = self.characterString else { return defaultCellSize }
        let viewWidth = CGFloat(characterString.count) * CharacterCellView.characterCellSize
        return NSSize(width: viewWidth, height:CharacterCellView.characterCellSize)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
        let context = NSGraphicsContext.current?.cgContext
        drawCharacterCells(context: context)
    }
  
    
    override func awakeFromNib() {
        setFrameSize(viewSize)
    }
    
}

extension CharacterCellView {
    func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                         radius: CGFloat, borderColor: CGColor, fillColor: CGColor) {
        let path = CGMutablePath()
        
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        
        context?.setLineWidth(1.0)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }
    
    
    func drawCharacterCells(context: CGContext?){
        guard let characters = self.characterString else {
            return
        }
        var clipRect = self.bounds
        clipRect.size.width = CharacterCellView.characterCellSize
        for character in characters {
            let color = segementColorForCharacter(character)
            context?.saveGState()
            context?.clip(to: clipRect)
            drawRoundedRect(rect: bounds, inContext: context,
                            radius: 1.0,
                            borderColor: NSColor.white.cgColor,
                            fillColor: color.cgColor)
            drawCharacterLabel(in: clipRect, character: character)
            context?.restoreGState()
            clipRect.origin.x = clipRect.maxX + 2.0
        }
    }
    
    func drawCharacterLabel(in rect: NSRect, character: Character) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let characterAttributes: [NSAttributedString.Key : Any] = [.font: NSFont.userFont(ofSize: 11) as Any, .paragraphStyle: paragraphStyle]
        let text = NSAttributedString(string: String(character), attributes: characterAttributes)
        text.draw(in: rect)
    }
    
    
       func segementColorForCharacter(_ char: Character) -> NSColor {
           return TaxonDataDNA.nucleotideColorCode(nucChar: String(char))
       }
    
}
