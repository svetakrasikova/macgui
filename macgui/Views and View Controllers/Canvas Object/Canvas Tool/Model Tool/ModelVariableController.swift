//
//  ModelVariableController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/4/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelVariableController: ModelPaletteItemController {
    
    private var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var distributionPopup: NSPopUpButton!
    @IBOutlet weak var distributionLabel: NSTextField!
    @IBOutlet weak var distributionStackView: NSStackView!
    
    @IBOutlet weak var boxContainer: NSBox!
    @IBOutlet weak var distributionParametersStackView: NSStackView!
    
    @IBOutlet weak var distributionParametersTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var param1StackView: NSStackView!
    @IBOutlet weak var param2StackView: NSStackView!
    @IBOutlet weak var param3StackView: NSStackView!
    @IBOutlet weak var param4StackView: NSStackView!
    @IBOutlet weak var param5StackView: NSStackView!
    
    var boxHeightConstraint = NSLayoutConstraint()
    
    var parametersStack: [NSStackView] {
        return [param1StackView, param2StackView, param3StackView, param4StackView, param5StackView]
    }
    
    
    var parametersStackShouldBeHidden: Bool = true {
        didSet {
            distributionParametersTopConstraint.constant = parametersStackShouldBeHidden ? 0 : 15.0
            self.distributionParametersStackView.isHidden = parametersStackShouldBeHidden
        }
    }
    
    weak var delegate: ModelVariableControllerDelegate?
    
    var distributions: [Distribution] {
        return []
    }
    
    @objc dynamic var distributionNames: [String] {
        return distributions.map { $0.name }
    }
    
    var parameters: [Parameter] = []
    
    //    MARK: -- View Controller Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle()
        setUpDistribution()
    }
    
    override func viewWillAppear() {
        resetDistribution()
    }
    
    func setUpDistribution() {
        guard let modelNode = self.modelNode, let distributionName =  modelNode.distribution?.name, let descriptiveString = modelNode.distribution?.descriptiveString  else { return }
        distributionLabel.toolTip = descriptiveString
        let itemToSelect = self.distributionPopup.item(withTitle: distributionName)
        self.distributionPopup.select(itemToSelect)
        setDistributionParameters(distributionName: distributionName)
        parametersStackShouldBeHidden = false
    }
    
    func setDistributionParameters(distributionName: String) {
        
        for distribution in self.distributions {
            if distribution.name == distributionName {
                self.parameters = distribution.parameters
                break
            }
        }
        
        for (index, parameter) in parameters.enumerated() {
            guard index < parametersStack.count else { return }
            let parameterStackView = parametersStack[index]
            setParameterStackView(parameterStackView, parameter: parameter, index: index)
            parameterStackView.isHidden = false
        }
        
        if parameters.count < parametersStack.count {
            for index in parameters.count ... parametersStack.count-1 {
                let parameterStackView = parametersStack[index]
                parameterStackView.isHidden = true
            }
        }
    }
    
    func setParameterStackView(_ stackView: NSStackView, parameter: Parameter, index: Int) {
        stackView.toolTip = parameter.descriptiveString
        for subview in stackView.subviews {
            if let label = subview as? NSTextField {
                label.stringValue = parameter.name
            } else if let popup = subview as? NSPopUpButton {
                if let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model {
                    var selectionItemNames: [String] = []
                    switch parameter.type {
                    case "Taxon[]":
                        selectionItemNames = Array(model.taxaDict.keys)
                    default:
                        var modelNodes: [ModelNode] = []
                        for connection in model.edges {
                            if modelNode == connection.to, let modelNode = connection.from as? ModelNode {
                                if modelNode.node.type == parameter.type {
                                    modelNodes.append(modelNode)
                                }
                            }
                        }
                        selectionItemNames = modelNodes.map { ($0.parameterName ?? "Unknown") }
                    }
                    
                    
                    popup.removeAllItems()
                    popup.addItem(withTitle: "<no selection>")
                    popup.addItems(withTitles: selectionItemNames)
                    
                    if let modelNode = self.modelNode {
                        guard index < modelNode.distributionParameters.count else { return }
                        var itemToSelect: NSMenuItem?
                        if let selectedNode = modelNode.distributionParameters[index] as? ModelNode, let selectedNodeName = selectedNode.parameterName {
                            itemToSelect = popup.item(withTitle: selectedNodeName)
                        } else {
                            if let matrixTaxaPair = modelNode.distributionParameters[index] as? (String, [String]) {
                                itemToSelect = popup.item(withTitle: matrixTaxaPair.0)
                            }
                           
                        }
                        popup.select(itemToSelect)
                    } else {
                        let itemToSelect = popup.item(withTitle: "<no selection>")
                        popup.select(itemToSelect)
                    }
                }
            }
        }
    }
    
    
    
    func resetDistribution() {
        
        if let modelNode = self.modelNode, let distributionName =  modelNode.distribution?.name {
            removeHeightConstraintFromBox()
            
            let itemToSelect = self.distributionPopup.item(withTitle: distributionName)
            self.distributionPopup.select(itemToSelect)
            parametersStackShouldBeHidden = false
            
            for distribution in self.distributions {
                if distribution.name == distributionName {
                    distributionLabel.toolTip = distribution.descriptiveString
                    break
                }
            }
            
            
            setDistributionParameters(distributionName: distributionName)
            addHeightConstraintToBox(height:  boxContainer.fittingSize.height)
        } else {
            resetParametersStack()
        }
    }
    
    
    //   MARK: -- IB Actions
    
    @IBAction func selectDistribution(_ sender: NSPopUpButton) {
        
        if let distributionName = sender.selectedItem?.title, distributionNames.contains(distributionName) {
            removeHeightConstraintFromBox()
            parametersStackShouldBeHidden = false
            for distribution in self.distributions {
                if distribution.name == distributionName {
                    distributionLabel.toolTip = distribution.descriptiveString
                }
            }
            setDistributionParameters(distributionName: distributionName)
            addHeightConstraintToBox(height:  boxContainer.fittingSize.height)
            
        } else {
//            resetParametersStack()
            
        }
    }
    func addHeightConstraintToBox(height: CGFloat) {
        removeHeightConstraintFromBox()
        boxHeightConstraint    = NSLayoutConstraint(item: boxContainer as Any,
                                                    attribute: NSLayoutConstraint.Attribute.height,
                                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                                    toItem: nil,
                                                    attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                    multiplier: 1,
                                                    constant: height)
        boxContainer.addConstraint(boxHeightConstraint)
    }
    
    func removeHeightConstraintFromBox() {
        boxContainer.removeConstraint(boxHeightConstraint)
    }
    
    func resetParametersStack() {
        for subview in distributionParametersStackView.subviews {
            if subview.isHidden == false {
                subview.isHidden = true
            }
        }
        parametersStackShouldBeHidden = true
        addHeightConstraintToBox(height: boxContainer.fittingSize.height)
        
    }
    
    @IBAction override func saveClicked(_ sender: NSButton) {
        
        if let delegate = self.delegate as? ModelCanvasViewController, let modelNode = self.modelNode, let selectedDistribution = distributions.first(where: { $0.name == distributionPopup.selectedItem?.title}) {
            modelNode.distribution = selectedDistribution
            modelNode.distributionParameters.removeAll()
            for (index, _) in parameters.enumerated() {
                guard index < parametersStack.count else { return }
                let parameterStackView = parametersStack[index]
                for subview in parameterStackView.subviews {
                    if let parameterPopup = subview as? NSPopUpButton {
                        if let parameterNode = delegate.model?.nodes.first(where: {$0.parameterName == parameterPopup.selectedItem?.title}) {
                            modelNode.distributionParameters.append(parameterNode)
                        } else {
                            if let matrixName = parameterPopup.selectedItem?.title, let taxa = delegate.model?.taxaDict[matrixName] {
                                let matrixTaxaPair = (matrixName, taxa)
                                modelNode.distributionParameters.append(matrixTaxaPair)
                            }
                        }
                        break
                    }
                }
            }
            
        }
        dismiss(self)
    }
    
}

// MARK: -- ModelVariableControllerDelegate

protocol ModelVariableControllerDelegate: AnyObject {
    func getDistributionsForParameter(_ modelNode: ModelNode) -> [Distribution]
    func getFunctionsForParameter(_ modelNode: ModelNode) -> [Distribution]
}
