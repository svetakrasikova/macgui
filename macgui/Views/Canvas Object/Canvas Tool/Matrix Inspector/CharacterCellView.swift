//
//  CharacterCellView.swift
//  
//
//  Created by Svetlana Krasikova on 12/19/19.
//

import Cocoa

class CharacterCellView: NSTableCellView{
    
    static let characterCellSize: CGFloat = 15.0
    var characterString: String?

    var viewSize: NSSize {
        let defaultCellSize = NSSize(width: CharacterCellView.characterCellSize, height: CharacterCellView.characterCellSize)
        guard let characterString = self.characterString else { return defaultCellSize }
        let viewWidth = CGFloat(characterString.count) * CharacterCellView.characterCellSize
        return NSSize(width: viewWidth, height:CharacterCellView.characterCellSize)
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        setFrameSize(viewSize)
        wantsLayer = true
    }
    
    
    func segementColorForCharacter(_ char: Character) -> CGColor {
        return TaxonDataDNA.nucleotideColorCode(nucChar: String(char)) as! CGColor
    }
    
}
