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
        guard var fillColor = preferencesManager.modelCanvasBackgroundColor
            else { return nil }
        guard let node = tool as? ModelNode else { return nil }
        if node.clamped {
            fillColor = fillColor.isLight() ?? true ? fillColor.darker(componentDelta: 0.2) : fillColor.lighter(componentDelta: 0.2)
        }
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
    
    var drawLabelAndDivider: Bool? {
        guard let node = self.tool as? ModelNode else { return nil }
        return node.name == PalettItem.treeTopologyType ? false : true
    }
    
    var actionButton: ActionButton?
    
    var modelCanvas: ModelCanvasViewController? {
        if let canvasViewController = self.parent as? ModelCanvasViewController {
            return canvasViewController
        }
        return nil
    }
    
    lazy var variableController: ModelStochasticVariableController = {
        let variableController = NSStoryboard.loadVC(StoryBoardName.variableController) as! ModelStochasticVariableController
        if let node = self.tool as? ModelNode, let canvasVC = self.modelCanvas {
            variableController.modelNode = node
            variableController.delegate = canvasVC
        }
        return variableController
    }()
    
    lazy var constantController: ModelConstantController = {
        let constantController = NSStoryboard.loadVC(StoryBoardName.constantController) as! ModelConstantController
        if let node = self.tool as? ModelNode, let canvasVC = self.modelCanvas {
            constantController.modelNode = node
        }
        return constantController
    }()
    
    lazy var functionController: ModelDeterministicVariableController = {
        let functionController = NSStoryboard.loadVC(StoryBoardName.functionController) as! ModelDeterministicVariableController
        if let node = self.tool as? ModelNode, let canvasVC = self.modelCanvas {
            functionController.modelNode = node
            functionController.delegate = canvasVC
        }
        return functionController
    }()
    
    
    lazy var topologyController: TreeTopologyController = {
        let controller = NSStoryboard.loadVC(StoryBoardName.treeTopologyController) as! TreeTopologyController
        if let node = self.tool as? ModelNode, let canvasVC = self.modelCanvas {
            controller.modelNode = node
        }
        return controller
    }()
    
    override weak var outerLoopViewController: ResizableCanvasObjectViewController? {
        didSet {
            guard let modelNode =  self.tool as? ModelNode else { return }
            guard let canvasVC = self.parent as? ModelCanvasViewController else { return }
            if let outerLoop = self.outerLoopViewController?.tool as? Loop {
                plateIndex = outerLoop.indexPath()
                if oldValue == nil && !canvasVC.resettingCanvasView {
                    modelNode.observedValue = NumberList()
                }
                
            } else {
                plateIndex = nil
                if oldValue != nil && !canvasVC.resettingCanvasView {
                    modelNode.observedValue = NumberList()
                }
            }
            view.needsDisplay = true
          }
    }
    
    var plateIndex: String?
    
    
    
//    MARK: -- Observers
    
    private var observers = [NSKeyValueObservation]()
    
    
    func addObservations() {
        
        if let node = self.tool as? ModelNode {
            observers = [
                node.observe(\ModelNode.parameterName, options: [.old, .new]) {(_, change) in
                    let pattern: String = "Parameter (\\d+)"
                    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    if let oldName = change.oldValue as? String, let match = regex?.firstMatch(in: oldName, options: [], range: NSRange(location: 0, length: oldName.utf16.count)) {
                        if let numberRange = Range(match.range(at:1), in: oldName) {
                            let index: String = String(oldName[numberRange])
                            NotificationCenter.default.post(name: .didChangeModelParameterName, object: nil, userInfo: ["index": index])
                        }
                    }
                },
                node.observe(\ModelNode.observedValue, options: [.old, .new], changeHandler: { (node, _) in
                        self.view.needsDisplay = true
    
                  
                    
                })
                
            ]
        }
    }
     
//    MARK: -- Interaction with Tree Plate
    func checkForTreePlateInclusion() {
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return }
        for case let treePlateController as TreePlateViewController in canvasVC.children.filter({$0.isKind(of: TreePlateViewController.self)}) {
            if treePlateController.view.frame.intersection(view.frame) == view.frame {
                treePlateController.embedNodeInTreePlate(nodeVC: self)
            } else {
                treePlateController.removeNodeFromTreePlate(nodeVC: self)
            }
        }
    }
    
    
    override func checkForLoopInclusion() {
        super.checkForLoopInclusion()
        checkForTreePlateInclusion()
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
        addObservations()
    }
    
//    MARK: -- Setting up View
    
    func setUp(){
        view.wantsLayer = true
        setFrame()
        addShape()
        if self.drawLabelAndDivider ?? true
        {
            addDividerLine()
        } else {
            addImage()
        }
        setUpActionButton()
    }
    func setFrame() {
        view.frame = self.frame
    }
    
    func addImage() {
        guard let node = self.tool as? ModelNode, node.treePlate != nil
        else {
            print("Tree topolgy node is not pointing to tree plate.")
            return
            
        }
        guard let strokeColor = self.strokeColor else {
            print("drawShapeInLayer: stroke color for the shape layer is undefined.")
            return
        }
        let drawAsRooted = false
        if let view = view as? ModelCanvasItemView {
            view.drawTreeTopologyImage(strokeColor: strokeColor, lineWidth: 1.5, rooted: drawAsRooted)
        }
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
        if drawLabelAndDivider ?? true {
            addDividerLine()
            addLabel()
        } else {
            addImage()
        }
        addActionButtonView()
    }
    
    
    func setUpActionButton(){
        guard let fillColor = self.fillColor else { return }
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
        guard let fillColor = self.fillColor else { return }
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
        guard let fillColor = self.fillColor else { return }
        guard let label = self.label else { return }
        if let view = self.view as? ModelCanvasItemView {
            if fillColor.isLight() ?? true {
                view.drawLabel(labelColor: NSColor.black, label: label, plateIndex: plateIndex)
            } else {
                view.drawLabel(labelColor: NSColor.white, label: label, plateIndex: plateIndex)
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
        
        guard let node = self.tool as? ModelNode else { return }
        if node.treePlate != nil {
            self.presentAsModalWindow(topologyController)
        } else {
            switch node.nodeType {
            case .function: self.presentAsModalWindow(functionController)
            case .constant: self.presentAsModalWindow(constantController)
            case .randomVariable: self.presentAsModalWindow(variableController)
            default: break
            }
        }
    }
    
 
    
}
