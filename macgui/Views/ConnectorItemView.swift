//
//  ConnectorItemView.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/2/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ConnectorItemView: NSView {
    

    enum State {
        case idle
        case source
        case target
    }
    
    var state: State = State.idle { didSet { needsLayout = true } }
    
    private let shapeLayer = CAShapeLayer()
    private let arrowLayer = CAShapeLayer()
    
    var arrowColor: NSColor?
    
    var delegate: ConnectorItemViewDelegate?
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard case .idle = state else { return [] }
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint != nil else { return [] }
        guard (sender.draggingSource as? ConnectionDragController)?.sourceEndpoint?.arrowColor == self.arrowColor else { return [] }
        guard ((sender.draggingSource as? ConnectionDragController)?.sourceEndpoint?.delegate?.isOutlet())!  else { return [] }
        guard !(self.delegate?.isOutlet())!  else { return [] }
        state = .target
        return sender.draggingSourceOperationMask
        }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }
    
    public override func draggingEnded(_ sender: NSDraggingInfo?) {
        guard case .target = state else { return }
        state = .idle
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let controller = sender.draggingSource as? ConnectionDragController{
            controller.connect(to: self)
            return true
        } else { return false }
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
        registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: kUTTypeData as String)])
    }
    
    override func makeBackingLayer() -> CALayer {
        return shapeLayer
    }
    
    override var intrinsicContentSize: CGSize { return CGSize(width: 80, height: 80) }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        shapeLayer.frame = frame
        layer = shapeLayer
    }
    
    override func layout() {
        super.layout()
        setAppearanceForState()
    }
    
    func drawArrow(color: NSColor){
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height/2))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        arrowLayer.strokeColor = NSColor.darkGray.cgColor
        arrowLayer.lineWidth = 0.5
        self.arrowColor = color
        arrowLayer.path = path
        shapeLayer.addSublayer(arrowLayer)
    }
    
    private func setAppearanceForState() {
        switch state {
        case .source:
            arrowLayer.fillColor = NSColor.gray.cgColor
        case .target:
            arrowLayer.fillColor = NSColor.gray.cgColor
        default:
            arrowLayer.fillColor = arrowColor?.cgColor
        }
    }
}

protocol ConnectorItemViewDelegate {
    func getTool() -> Any?
    func getConnector() -> Any?
    func isOutlet() -> Bool
}
