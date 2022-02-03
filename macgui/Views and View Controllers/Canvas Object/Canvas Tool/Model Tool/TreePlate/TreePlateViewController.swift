//
//  TreePlateViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/18/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreePlateViewController: ResizableCanvasObjectViewController {
    
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
    
    var internalsBranchesPanel: PlatePanelView!

    var tipsBranchesPanel: PlatePanelView!
    
    var internalsNodesPanel: PlatePanelView!
   
    var tipsNodesPanel: PlatePanelView!
    
    var panels: [PlatePanelView] {
            return [rootPanel,
                    internalsNodesPanel,
                    internalsBranchesPanel,
                    tipsNodesPanel,
                    tipsBranchesPanel]
    }
    
    
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
        panel.toolTip = panel.nodeTypeString
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
        rootPanel = makePanelViewWithLabel(type: PlatePanelView.PanelType.root.rawValue)
        rootInternalsTipsStack = NSStackView(views: [rootPanel!, makeBasePanelView(), makeBasePanelView()])
        rootInternalsTipsStack.spacing = 0.5
        setupStackView(rootInternalsTipsStack, horizontal: true)
        self.view.addSubview(rootInternalsTipsStack)
        setConstraintsForStackView(rootInternalsTipsStack, view: self.view)
    }
    
    func addBranchesNodesStacks() {
        let internals = rootInternalsTipsStack.arrangedSubviews[1]
        internalsNodesPanel = makePanelViewWithLabel(type: PlatePanelView.PanelType.internals.rawValue)
        internalsBranchesPanel = makePanelViewWithLabel(type: PlatePanelView.PanelType.internals.rawValue, branchNode: true)
        let internalsBranchesNodesStack = NSStackView(views: [internalsBranchesPanel, internalsNodesPanel])
        internalsBranchesNodesStack.setCustomSpacing(0.5, after: internalsBranchesPanel)
        setupStackView(internalsBranchesNodesStack, horizontal: false)
        internals.addSubview(internalsBranchesNodesStack)
        setConstraintsForStackView(internalsBranchesNodesStack, view: internals)
        
        let tips = rootInternalsTipsStack.arrangedSubviews[2]
        tipsNodesPanel = makePanelViewWithLabel(type: PlatePanelView.PanelType.tips.rawValue)
        tipsBranchesPanel = makePanelViewWithLabel(type: PlatePanelView.PanelType.tips.rawValue, branchNode: true)
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
    
    func embedNodeInTreePlate(nodeVC: ModelCanvasItemViewController) {
        guard let node = nodeVC.tool as? ModelNode else { return }
        guard let plate = self.tool as? TreePlate else { return }
        guard let canvasVC = self.parent as? GenericCanvasViewController else { return }
        plate.addEmbeddedNode(node)
        plate.removeFromPanels(node)
        var foundPanel = false
        for panel in panels {
        let convertedFrame = panel.convert(panel.bounds, to: canvasVC.canvasView)
            if convertedFrame.intersection(node.frameOnCanvas) == node.frameOnCanvas {
                switch panel.nodeType {
                case PlatePanelView.PanelType.root.rawValue:
                    plate.root = node
                case PlatePanelView.PanelType.internals.rawValue:
                    if panel.branchPanel {
                        plate.internalBranches.append(node)
                    } else {
                        plate.internalNodes.append(node)
                    }
                case PlatePanelView.PanelType.tips.rawValue:
                    if panel.branchPanel {
                        plate.tipBranches.append(node)
                    } else {
                        plate.tipNodes.append(node)
                    }
                default: break
                }
                foundPanel = true
                break
            }
        }
        if !foundPanel {
            nodeVC.outerLoopViewController = nil
            let alert = NSAlert()
            alert.messageText = "Problem adding the node to the tree plate."
            alert.informativeText =  "Adjust the node position so that it is fully included in one of the 5 plate panels."
            alert.runModal()
        }
    }
    
    func removeNodeFromTreePlate(nodeVC: ModelCanvasItemViewController) {
        guard let node = nodeVC.tool as? ModelNode else { return }
        guard let plate = self.tool as? TreePlate else { return }
        plate.removeEmbeddedNode(node)
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
        let sign = nodeType == PlatePanelView.PanelType.root.rawValue ? "=" : "\(Symbol.element.rawValue)"
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
    
}
