//
//  ModelNodeChecker.swift
//  macgui
//
//  Created by Svetlana Krasikova on 12/14/21.
//  Copyright © 2021 Svetlana Krasikova. All rights reserved.
//

import Cocoa
/**
 ModelNodeChecker runs a validation check on a model node. It stores a list of errors and the name of a data matrix if the node is associated with throu the through the observed data field or in one of it's distribution parameters.
 */
class ModelNodeChecker: NSObject {
    
    enum ModelNodeCheckerError: Error {
        case UndefinedNodeType
    }
    
    enum ModelNodeError: Error {
        case constantValueUndefined
        case distributionUndefined
        case distributionParametersUndefined(Int)
    }
    var node: ModelNode
    var errors: [Error] = []
    var linkedData: String?
    
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
            return [ModelNodeError.constantValueUndefined]
        }
        return nil
    }
    
 
    func checkFunctionAndRandomVariable() -> Error? {
        guard let _ = node.distribution else {
            return ModelNodeError.distributionUndefined
        }
        if let paramError = checkDistributionParameters() {
            return paramError
        }
       return nil
    }
    
    
    func checkDistributionParameters() -> Error? {
        guard let distribution = node.distribution else { return nil }
        let paramDiff = distribution.parameters.count - node.distributionParameters.count
        guard paramDiff == 0
        else {
            return ModelNodeError.distributionParametersUndefined(paramDiff)
        }
        return nil
    }
}


