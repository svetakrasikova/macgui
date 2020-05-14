//
//  ModelCanvasItemViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/24/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasItemViewController: CanvasObjectViewController, ActionButtonDelegate {
    

    let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
    
    var fillColor: NSColor? {
//        TODO: If a clamped node return the clamped node color
        guard let fillColor = preferencesManager.modelCanvasBackgroundColor
            else { return nil }
        return fillColor
    }
    
    var strokeColor: NSColor? {
        guard let strokeColor = preferencesManager.modelCanvasNodeBorderColor
            else { return nil }
        return strokeColor
    }
    
    var shape: ModelParameterShape? {
        if let node = self.tool as? ModelNode {
            if let type = node.nodeType {
                switch type {
                case .constant: return .solidRectangle
                case .randomVariable: return .solidCircle
                case . function: return .dashedCircle
                }
            }
        }
        return nil
    }
    
    var label: String? {
        if let node = self.tool as? ModelNode {
            if let variable = node.node as? PaletteVariable {
                return variable.symbol
            }
        }
        return nil
    }
    
    var frame: NSRect {
        guard let node = self.tool as? ModelNode else {
            print("\(self): view frame is undefined.")
            return NSZeroRect
        }
        return node.frameOnCanvas
    }
    
    var actionButton: ActionButton?
    
    var modelCanvas: ModelCanvasViewController? {
        if let canvasViewController = self.parent as? ModelCanvasViewController {
            return canvasViewController
        }
        return nil
    }
    
    lazy var variableController: ModelVariableController = {
        let variableController = NSStoryboard.loadVC(StoryBoardName.variableController) as! ModelVariableController
        if let node = self.tool as? ModelNode, let canvasVC = self.modelCanvas {
            variableController.modelNode = node
            variableController.delegate = canvasVC
        }
        return variableController
    }()
    
//    MARK: -- Observers
    
    private var observers = [NSKeyValueObservation]()
    
    
    func addNodeNameChangeObservation() {
        if let model = self.tool as? ModelNode {
            observers = [
                model.observe(\ModelNode.parameterName, options: [.old, .new]) {(_, change) in
                    let pattern: String = "Parameter (\\d+)"
                    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    if let oldName = change.oldValue as? String, let match = regex?.firstMatch(in: oldName, options: [], range: NSRange(location: 0, length: oldName.utf16.count)) {
                        if let numberRange = Range(match.range(at:1), in: oldName) {
                            let index: String = String(oldName[numberRange])
                            NotificationCenter.default.post(name: .didChangeModelParameterName, object: nil, userInfo: ["index": index])
                        }
                    }
                }
                
            ]
        }
    }
             
    
//    MARK: -- Mouse Events
    
    override func mouseEntered(with event: NSEvent) {
        self.actionButton?.mouseEntered(with: event)
    }
    
    override func mouseExited(with event: NSEvent) {
        self.actionButton?.mouseExited(with: event)
       }
    
//    MARK: -- Controller Life Cycle
    
    override func viewDidLoad() {	
        super.viewDidLoad()
        setUp()
        addNodeNameChangeObservation()
    }
    
//    MARK: -- Setting up View
    
    func setUp(){
        view.wantsLayer = true
        setFrame()
        addShape()
        addDividerLine()
        setUpActionButton()
    }
    func setFrame() {
        view.frame = self.frame
    }
    
    func addShape() {
        guard let shape = self.shape else {
             print("drawShapeInLayer: shape type for the shape layer is undefined.")
            return
        }
        guard let fillColor = self.fillColor else {
             print("drawShapeInLayer: fill color for the shape layer is undefined.")
            return
        }
        guard let strokeColor = self.strokeColor else {
            print("drawShapeInLayer: stroke color for the shape layer is undefined.")
            return
        }
        if let view = view as? ModelCanvasItemView {
            view.drawShape(shape: shape, fillColor: fillColor, strokeColor: strokeColor, lineWidth: 1.0)
        }
    }

    
    func updateShapeLayer(_ shapeLayer: CAShapeLayer, selected:  Bool) {
        clearSublayers()
        if selected {
            addShape()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeSelectionShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeSelectionShadowRadius!
        } else {
            addShape()
            shapeLayer.shadowOpacity = Float(preferencesManager.modelCanvasNodeDefaultShadowOpacity!)
            shapeLayer.shadowRadius = preferencesManager.modelCanvasNodeDefaultShadowRadius!
        }
        addDividerLine()
        addLabel()
        addActionButtonView()
    }
    
    func setUpActionButton(){
        guard let fillColor = self.fillColor else {
            print("addInfoButton: fill color for the shape layer is undefined.")
            return
        }
        let infoButton = ActionButton()
        if fillColor.isLight() ?? true { infoButton.labelColor = NSColor.black }
        let buttonOrigin = CGPoint(x: view.bounds.center().x-4, y: view.bounds.center().y-20)
        infoButton.frame = CGRect(origin: buttonOrigin, size: CGSize(width: 8, height: 8))
        infoButton.tag = 0
        infoButton.isTransparent = true
        infoButton.setButtonType(.momentaryPushIn)
        self.view.addSubview(infoButton)
        infoButton.delegate = self
        self.actionButton = infoButton
    }
    
    func addActionButtonView() {
        guard let fillColor = self.fillColor else {
            print("addInfoButton: fill color for the shape layer is undefined.")
            return
        }
        if let button = self.actionButton {
            if fillColor.isLight() ?? true {
                button.labelColor = NSColor.black
            } else {
                button.labelColor = NSColor.white
            }
            view.addSubview(button)
            button.needsLayout = true
        }
    }
    
    func addDividerLine() {
        guard let strokeColor = self.strokeColor else {
            print("addDividerLine: stroke color for the shape layer is undefined.")
            return
        }
        if let view = self.view as? ModelCanvasItemView {
            view.drawDividerLine(strokeColor: strokeColor, lineWidth: 1.0)
        }
        
    }
    
    func addLabel() {
        guard let fillColor = self.fillColor else {
            print("addLabel: fill color for the shape layer is undefined.")
            return
        }
        guard let label = self.label else {
            print("addLabel: label for the shape layer is undefined.")
            return
        }
        if let view = self.view as? ModelCanvasItemView {
            
            if fillColor.isLight() ?? true {
                view.drawLabel(labelColor: NSColor.black, label: label)
            } else {
                view.drawLabel(labelColor: NSColor.white, label: label)
            }
          
        }
    }
    
    func clearSublayers(){
        actionButton?.removeFromSuperview()
        if let sublayers = view.layer?.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    
//    MARK: -- Action Button Delegate
    
    func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(variableController)
     }
    
 
    
}
