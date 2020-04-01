//
//  CharacterCellHeaderView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/29/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class CharacterCellHeaderView: NSTableHeaderView {

    var numberOfCharacters: Int?
    static let headerHight: CGFloat = 20.0


    var viewSize: NSSize {
        let firstColumnWidth = self.headerRect(ofColumn: 0).size.width
        let defaultCellSize = NSSize(width: firstColumnWidth, height: CharacterCellHeaderView.headerHight)
        
        guard let numberOfCharacters = self.numberOfCharacters
            else { return defaultCellSize }
       
        let viewWidth = (CGFloat(numberOfCharacters) * CharacterCellView.characterCellSize) + firstColumnWidth
        return NSSize(width: viewWidth, height: CharacterCellHeaderView.headerHight)
    }
   
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
        setFrameSize(viewSize)
        let context = NSGraphicsContext.current?.cgContext
        drawRuler(in: context)
    }
    
}

extension CharacterCellHeaderView {
    
    func drawRuler(in context: CGContext?) {
        guard let numberOfCharacters = self.numberOfCharacters else {
            return
        }
        var clipRect = self.headerRect(ofColumn: 1)
        clipRect.size.width = CharacterCellView.characterCellSize
        var ten = 1
        var hundred = (1,1)
        for cell in 1..<numberOfCharacters+1 {
            context?.saveGState()
            context?.clip(to: clipRect)
            if cell == 1 {
                drawUnit(in: clipRect, cell: 1)
            } else if cell % 10 == 0 {
                drawUnit(in: clipRect, cell: 0)
            } else if cell % 10 == 9 {
                drawUnit(in: clipRect, cell: ten)
                ten = incrementTen(unit: ten)
            } else if cell == 98 {
                drawUnit(in: clipRect, cell: hundred.0)
            } else if cell % 10 == 8 && cell > 100 {
                drawUnit(in: clipRect, cell: hundred.0)
                hundred = incrementHundred(unit: hundred)
            }
            context?.restoreGState()
            clipRect.origin.x = clipRect.maxX + 2
        }
    }
    
    func incrementTen(unit: Int) -> Int {
        return unit < 9 ? unit + 1 : 0
    }
    
    func incrementHundred(unit: (Int, Int))  -> (Int, Int){
        let step = unit.1
        let hundred = unit.0
        if step % 9 > 0 || step == 0 {
            return (hundred, step + 1)
        } else {
            return (hundred + 1, 0)
        }
    }
    
    func drawUnit(in rect: NSRect, cell: Int){
      let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let characterAttributes: [NSAttributedString.Key : Any] = [.font: NSFont.userFont(ofSize: 11) as Any, .paragraphStyle: paragraphStyle]
        let text = NSAttributedString(string: String(cell), attributes: characterAttributes)
        text.draw(in: rect)
    }
}
