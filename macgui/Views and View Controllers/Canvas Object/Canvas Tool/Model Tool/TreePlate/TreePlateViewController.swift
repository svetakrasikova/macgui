//
//  TreePlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateViewController: ResizableCanvasObjectViewController {
    
    enum BasePanel: Int, CaseIterable {
        case root, internals, tips
    }
    
    lazy var plateController: TreePlateController = {
        let plateController = NSStoryboard.loadVC(StoryBoardName.treePlateController) as! TreePlateController
        
        if let plate = self.tool as? TreePlate {
            plateController.loop = plate
        }
        if let canvasVC = self.parent as? GenericCanvasViewController {
            plateController.delegate = canvasVC
        }
        return plateController
    }()
    
    var treePlateView: TreePlateView {
        return self.view as! TreePlateView
    }
    
    var backgroundColor: NSColor? {
        let preferencesManager = (NSApp.delegate as! AppDelegate).preferencesManager
        return preferencesManager.modelCanvasBackgroundColor
    }
    
    var topologyNodeViewController: ModelCanvasItemViewController?
    var edgeViewController: EdgeViewController?
    
    var rootPanel: PlatePanelView!
   
    var rootPanelFocusRingFrame: NSRect {
        let origin = rootPanel.frame.insetBy(dx: treePlateView.frameOffset, dy: treePlateView.frameOffset).origin
        let size = CGSize(width: rootPanel.frame.width + treePlateView.frameOffset, height: rootPanel.frame.height - treePlateView.frameOffset*2)
        return NSRect(origin: origin, size: size)
    }
    
    var internalsBranchesPanel: PlatePanelView!
    
    var internalsBranchesPanelFocusRingFrame: NSRect {
        let origin = internalsBranchesPanel.frame.origin
        let size = CGSize(width: internalsBranchesPanel.frame.width, height: internalsBranchesPanel.frame.height)
        return NSRect(origin: origin, size: size)
    }
    var tipsBranchesPanel: PlatePanelView!
    
    var tipsBranchesPanelFocusRingFrame: NSRect {
        let origin = tipsBranchesPanel.frame.origin
        let size = CGSize(width: tipsBranchesPanel.frame.width, height: tipsBranchesPanel.frame.height)
        return NSRect(origin: origin, size: size)
    }
    var internalsNodesPanel: PlatePanelView!
    var tipsNodesPanel: PlatePanelView!
    
    var rootInternalsTipsStack: NSStackView!
    
    override func loadView() {
        if let treePlate = self.tool as? TreePlate {
            view = TreePlateView(frame: treePlate.frameOnCanvas)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resizableView.delegate = self
        addHorizontalStack()
        addBranchesNodesStacks()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        addLabelLayer()
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return }
        print(rootPanel.convert(rootPanel.bounds, to: canvasVC.canvasView), internalsBranchesPanel.convert(internalsNodesPanel.bounds, to: canvasVC.canvasView))
    }
    
    override func  setBackgroundColor() {
        guard let view = view as? TreePlateView else { return }
        view.backgroundColor = backgroundColor
        
    }
    
    override func actionButtonClicked(_ button: ActionButton) {
        self.presentAsModalWindow(plateController)
    }

}

extension TreePlateViewController {
    
    func makePanelViewWithLabel(type: Int, branchNode: Bool = false) -> PlatePanelView {
        let panel = PlatePanelView()
        panel.delegate = self
        panel.nodeType = type
        panel.branchPanel = branchNode
        panel.translatesAutoresizingMaskIntoConstraints = false
        panel.wantsLayer = true
        panel.layer?.backgroundColor = NSColor.clear.cgColor
        return panel
    }
    
    func makeBasePanelView() -> NSView {
        let row = NSView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.wantsLayer = true
        row.layer?.backgroundColor = NSColor.clear.cgColor
        return row
    }
    
    func addHorizontalStack() {
        rootPanel = makePanelViewWithLabel(type: BasePanel.root.rawValue)
        rootInternalsTipsStack = NSStackView(views: [rootPanel!, makeBasePanelView(), makeBasePanelView()])
        rootInternalsTipsStack.spacing = 0.5
        setupStackView(rootInternalsTipsStack, horizontal: true)
        self.view.addSubview(rootInternalsTipsStack)
        setConstraintsForStackView(rootInternalsTipsStack, view: self.view)
    }
    
    func addBranchesNodesStacks() {
        let internals = rootInternalsTipsStack.arrangedSubviews[1]
        internalsNodesPanel = makePanelViewWithLabel(type: BasePanel.internals.rawValue)
        internalsBranchesPanel = makePanelViewWithLabel(type: BasePanel.internals.rawValue, branchNode: true)
        let internalsBranchesNodesStack = NSStackView(views: [internalsBranchesPanel, internalsNodesPanel])
        internalsBranchesNodesStack.setCustomSpacing(0.5, after: internalsBranchesPanel)
        setupStackView(internalsBranchesNodesStack, horizontal: false)
        internals.addSubview(internalsBranchesNodesStack)
        setConstraintsForStackView(internalsBranchesNodesStack, view: internals)
        
        let tips = rootInternalsTipsStack.arrangedSubviews[2]
        tipsNodesPanel = makePanelViewWithLabel(type: BasePanel.tips.rawValue)
        tipsBranchesPanel = makePanelViewWithLabel(type: BasePanel.tips.rawValue, branchNode: true)
        let tipsBranchesNodesStack = NSStackView(views: [tipsBranchesPanel, tipsNodesPanel])
        tipsBranchesNodesStack.setCustomSpacing(0.5, after: tipsBranchesPanel)
        setupStackView(tipsBranchesNodesStack, horizontal: false)
        tips.addSubview(tipsBranchesNodesStack)
        setConstraintsForStackView(tipsBranchesNodesStack, view: tips)
    }
    
    func setConstraintsForStackView(_ stackView: NSStackView, view: NSView) {
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        for view in stackView.arrangedSubviews {
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .horizontal)
            view.setContentHuggingPriority(NSLayoutConstraint.Priority(1), for: .vertical)
        }
    }
    
    func setupStackView(_ stackView: NSStackView, horizontal: Bool) {
        stackView.distribution = .fillEqually
        stackView.orientation = horizontal ? .horizontal : .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addLabelLayer() {
        rootPanel?.addIndexLabel()
       
        tipsNodesPanel?.addIndexLabel()
        
        internalsNodesPanel?.addIndexLabel()

    }
    
    func createLinePath(beg: NSPoint, end: NSPoint) -> CGMutablePath {
        let path = CGMutablePath()
        path.addLines(between: [beg, end])
        return path
    }
    
}


extension TreePlateViewController: PlatePanelViewDelegate {
    
    func platePanelViewLabel(nodeType: Int) -> String {
        var range = ""
        switch nodeType {
        case 0: range = "root"
        case 1: range = "internals"
        case 2: range = "tips"
        default: break
        }
        let sign = nodeType == BasePanel.root.rawValue ? "=" : "\(Symbol.element.rawValue)"
        return "\(loop.index) \(sign) \(range)"
    }
    
    func platePanelViewFrame(view: PlatePanelView) -> NSRect? {
        guard let text = view.labelText else { return nil }
        let attributes: [NSAttributedString.Key: Any] = [.font: NSFont(name: "Hoefler Text", size: resizableView.labelFontSize) as Any]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        var frame = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
        let origin = NSPoint(x: view.bounds.minX + view.frame.width/2 - frame.width/2, y: view.bounds.minY + 2.0 )
        frame.origin = origin
        return frame
    }
    
    func drawFocusRingAroundReceivingDragPanel(dragLocation: NSRect) {
        
        let focusRingLayer = CAShapeLayer()
        focusRingLayer.strokeColor = NSColor.lightGray.cgColor
        focusRingLayer.fillColor = NSColor.clear.cgColor
        focusRingLayer.lineWidth = 2.0
        let focusRingPath = CGMutablePath()
       
        if  dragIntoPanel(rootPanel, dragLocation: dragLocation) {
            focusRingPath.addRect(rootPanelFocusRingFrame)
            focusRingLayer.path = focusRingPath
        }
        if dragIntoPanel(internalsBranchesPanel, dragLocation: dragLocation) {
            focusRingPath.addRect(internalsBranchesPanelFocusRingFrame)
            focusRingLayer.path = focusRingPath
        }
        
        if dragIntoPanel(tipsBranchesPanel, dragLocation: dragLocation) {
            focusRingPath.addRect(tipsBranchesPanelFocusRingFrame)
            focusRingLayer.path = focusRingPath
        }
        view.layer?.addSublayer(focusRingLayer)
        
    }
    
    func dragIntoPanel(_ panel: NSView, dragLocation: NSRect) -> Bool {
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return false }
        let convertedOrigin = self.view.convert(panel.frame.origin, to: canvasVC.canvasView)
        let newFrame = NSRect(origin: convertedOrigin, size: panel.frame.size)
        return  newFrame.intersects(dragLocation)
    }
    
    
}
