//
//  ModelVariableController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 5/4/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelVariableController: NSViewController {
    
    @objc dynamic weak var modelNode: ModelNode?
    private var observers = [NSKeyValueObservation]()

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var distributionPopup: NSPopUpButton!
    @IBOutlet weak var distributionStackView: NSStackView!
    
    @IBOutlet weak var boxContainer: NSBox!
    @IBOutlet weak var distributionParametersStackView: NSStackView!
   
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
            self.distributionParametersStackView.isHidden = parametersStackShouldBeHidden
        }
    }
   
    weak var delegate: ModelVariableControllerDelegate?
   
    var distributions: [Distribution] {
         guard let delegate = self.delegate, let modelNode = self.modelNode else { return [] }
         return delegate.getDistributionsForParameter(modelNode)
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
        print("Initial fitting size:", self.view.fittingSize.height)
    }
    
//    MARK: -- Distribution and Parameters Setup
    
    func setUpTitle() {
           if let name = modelNode?.parameterName {
               self.title = name
               nameTextField.stringValue = name
           }
           addNodeNameChangeObservation()
       }
       
       
       func setUpDistribution() {
           guard let modelNode = self.modelNode, let distributionName =  modelNode.distribution?.name, let descriptiveString = modelNode.distribution?.descriptiveString  else { return }
           distributionStackView.toolTip = descriptiveString
           let itemToSelect = self.distributionPopup.item(withTitle: distributionName)
           self.distributionPopup.select(itemToSelect)
           setDistributionParameters(distributionName: distributionName)
           parametersStackShouldBeHidden = false
       }
       
       
       
       func setDistributionParameters(distributionName: String) {
           
           for distribution in self.distributions {
               if distribution.name == distributionName {
                   self.parameters = distribution.parameters
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
                   var modelNodes: [ModelNode] = []
                   if let delegate = self.delegate as? ModelCanvasViewController, let model = delegate.model {
                       for connection in model.edges {
                           if modelNode == connection.from.neighbor, let modelNode = connection.to.neighbor as? ModelNode {
                               if modelNode.node.type == parameter.type {
                                   modelNodes.append(modelNode)
                               }
                           }
                       }
                       let modelNodeNames: [String] = modelNodes.map { ($0.parameterName ?? "Unknown") }
                       popup.removeAllItems()
                       popup.addItems(withTitles: modelNodeNames)
                    if index < (modelNode?.distributionParameters.count ?? 0), let selectedNodeName = modelNode?.distributionParameters[index].parameterName {
                           let itemToSelect = popup.item(withTitle: selectedNodeName)
                           popup.select(itemToSelect)
                       }
                   }
               }
           }
       }

   
    
    func addNodeNameChangeObservation() {
        if let model = self.modelNode {
            observers = [
                model.observe(\ModelNode.parameterName, options: [.old, .new]) {(_, change) in
                    if let newTitle = change.newValue {
                        self.title = newTitle
                        self.view.needsDisplay = true
                    }
                }
                
            ]
        }
    }
    
//   MARK: -- IB Actions
    
    @IBAction func selectDistribution(_ sender: NSPopUpButton) {
 
        if let distributionName = sender.selectedItem?.title, distributionNames.contains(distributionName) {
            removeHeightConstraintFromBox()
            parametersStackShouldBeHidden = false
            setDistributionParameters(distributionName: distributionName)
            print("Fitting size on selection of new distribution:", self.view.fittingSize.height)
            addHeightConstraintToBox(height:  boxContainer.fittingSize.height)
            
        } else {
            resetParametersStack()
            print("Fitting size after reset:", self.view.fittingSize.height)
    
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
    
    @IBAction func okClicked(_ sender: NSButton) {
        
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

protocol ModelVariableControllerDelegate: class {
    func getDistributionsForParameter(_ modelNode: ModelNode) -> [Distribution]
}
