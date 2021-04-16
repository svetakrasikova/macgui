//
//  ResizableCanvasObjectViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/12/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ResizableCanvasObjectViewController: CanvasObjectViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.unregisterDraggedTypes()
        setLabel()
    }
    
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
    
}
