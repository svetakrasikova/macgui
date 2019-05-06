//
//  ConnectorItem.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/21/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItem: NSCollectionViewItem {
    
    var type: Connector? {
        didSet{
            guard isViewLoaded else { return }
            if let type = type{
                let fillColor = getColor(colorType: type.color)
                arrowCAShapeLayer(color: fillColor)
            }
        }
    }
   
    let rootLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        rootLayer.frame = view.frame
        view.layer = rootLayer
        view.wantsLayer = true
    }
    
    func arrowCAShapeLayer(color: NSColor){
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: view.frame.size.height))
        path.addLine(to: CGPoint(x: view.frame.size.width, y: view.frame.size.height/2))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        layer.strokeColor = NSColor.darkGray.cgColor
        layer.lineWidth = 0.5
        layer.fillColor = color.cgColor
        layer.path = path
        rootLayer.addSublayer(layer)
    }
    
    func getColor(colorType: ConnectorColor) -> NSColor {
        switch colorType {
        case .blue: return NSColor.blue
        case .green: return NSColor.green
        case .orange: return NSColor.orange
        case .red: return NSColor.red
        case .magenta: return NSColor.magenta
        }
    }
    
}
