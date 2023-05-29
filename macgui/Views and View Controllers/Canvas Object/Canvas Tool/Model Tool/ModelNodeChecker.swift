//
//  ModelNodeChecker.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/14/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa
/**
 ModelNodeChecker runs a validation check on a model node. It stores a list of errors, such as undefined value and undefined parameters of the node distribution or function. 
 */
class ModelNodeChecker: NSObject {
    
    enum ModelNodeCheckerError: Error {
        case UndefinedNodeType
    }
    
    enum ModelNodeError: Error {
        case constantValueUndefined(ModelNode)
        case distributionUndefined(ModelNode)
        case distributionParametersUndefined(ModelNode, Int)
    }
    var node: ModelNode
    var errors: [Error] = []
    
    init(node: ModelNode) {
        self.node = node
    }
    
    func runCheck() throws {
        guard let type = node.nodeType
        else {
            throw ModelNodeCheckerError.UndefinedNodeType
        }
        switch type {
        case .constant:
            if let constantErrors = checkConstantValue() {
                errors.append(contentsOf: constantErrors)
                
            }
        default:
            if let funcVariableError = checkFunctionAndRandomVariable() {
                errors.append(funcVariableError)
                
            }
        }
    }
    
    func checkConstantValue() -> [Error]? {
        guard let _ = node.constantValue else {
            return [ModelNodeError.constantValueUndefined(node)]
        }
        return nil
    }
    
 
    func checkFunctionAndRandomVariable() -> Error? {
        guard let _ = node.distribution else {
            return ModelNodeError.distributionUndefined(node)
        }
        if let paramError = checkDistributionParameters() {
            return paramError
        }
       return nil
    }
    
    
    func checkDistributionParameters() -> Error? {
        guard let distribution = node.distribution else { return nil }
        let paramCount = node.distributionParameters.filter({ $0 is ModelNode }).count
        let paramDiff = distribution.parameters.count - paramCount
        
        if (distribution.parameters.count - paramCount == 0) {
            return nil
        } else {
            return ModelNodeError.distributionParametersUndefined(node, paramDiff)
        }
    }
    
    
    func errorsDescription(errors: [Error]) -> [String] {
        var errorDescriptions = [String]()
        for error in errors {
            switch error  {
            case ModelNodeChecker.ModelNodeError.distributionUndefined(let node):
                errorDescriptions.append("\(node.descriptiveName): undefined distribution.")
            case ModelNodeChecker.ModelNodeError.constantValueUndefined(let node):
                errorDescriptions.append("\(node.descriptiveName): undefined constant value.")
            case ModelNodeChecker.ModelNodeError.distributionParametersUndefined(let node, let num):
                let numParamString = num > 1 ? "\(num) undefined parameters" : "1 undefined parameter"
                errorDescriptions.append("\(node.descriptiveName): \(numParamString).")
            default: break
            }
        }
        return errorDescriptions
    }
}


