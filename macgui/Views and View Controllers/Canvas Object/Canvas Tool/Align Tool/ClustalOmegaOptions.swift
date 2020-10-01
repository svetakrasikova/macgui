//
//  ClustalOmegaOptions.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/7/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers
class ClustalOmegaOptions: NSObject, NSCoding {
   
    // MARK: - Coding Keys
    
    private enum CodingKeys: String {
        
        case dealign
        case mbedClusteringGuideTree
        case mbedClusteringIteration
        case numberCombinedIter
        case maxGuideTreeIter
        case maxHMMIter
        case order
    }
    
    // MARK: - Errors
       
    enum ClustalOmegaOptionsError: Error {
           case encodingError
           case decodingError
       }
       
       // MARK: - Clustal Command Options
       
    enum Dealign: Int { case yes, no }
    enum Order: String { case aligned = "tree-order", input = "input-order" }
    enum MBEDClusteringGuideTree: Int { case yes, no }
    enum MBEDClusteringIteration: Int { case yes, no }
    enum NumberCombinedIter: Int { case integerValue }
    enum MAXGuideTreeIter: Int { case integerValue }
    enum MAXHMMIter: Int { case integerValue }
       
       // MARK: - Clustal Command Variables
       
    var dealign = Dealign.no.rawValue
    var order = Order.aligned
    var mbedClusteringGuideTree = MBEDClusteringGuideTree.yes.rawValue
    var mbedClusteringIteration = MBEDClusteringIteration.yes.rawValue
    var numberCombinedIter = 0
    var maxGuideTreeIter = 0
    var maxHMMIter = 0

       
    let dealignArg = "--dealign"
    let infileArg = "--infile="
    let outfileArg = "--outfile="
    let orderArg =  "--output-order="
    let mbedClusteringGuideTreeArg = "--full"
    let mbedClusteringIterationArg  = "--full-iter"
    let numberCombinedIterArg = "--iter="
    let maxGuideTreeIterArg = "--max-guidetree-iterations="
    let maxHMMIterArg = "--max-hmm-iterations="
    let forceOverwritingArg = "--force"

    
    
    var args: [String] = []
       
    
    // MARK: -
    
    override init() {
        
        super.init()
    }
    
    
    func encode(with coder: NSCoder) {
        
        coder.encode(dealign, forKey: CodingKeys.dealign.rawValue)
        coder.encode(order.rawValue, forKey: CodingKeys.order.rawValue)
        coder.encode(mbedClusteringGuideTree, forKey: CodingKeys.mbedClusteringGuideTree.rawValue)
        coder.encode(mbedClusteringIteration, forKey: CodingKeys.mbedClusteringIteration.rawValue)
        coder.encode(numberCombinedIter, forKey: CodingKeys.numberCombinedIter.rawValue)
        coder.encode(maxGuideTreeIter, forKey: CodingKeys.maxGuideTreeIter.rawValue)
        coder.encode(maxHMMIter, forKey: CodingKeys.maxHMMIter.rawValue)
        
    }
    
    required init?(coder: NSCoder) {
        dealign =  coder.decodeInteger(forKey: CodingKeys.dealign.rawValue)
        order =  Order(rawValue: coder.decodeObject(forKey: CodingKeys.order.rawValue) as! String) ?? Order.aligned
        mbedClusteringGuideTree =  coder.decodeInteger(forKey: CodingKeys.mbedClusteringGuideTree.rawValue)
        mbedClusteringIteration =  coder.decodeInteger(forKey: CodingKeys.mbedClusteringIteration.rawValue)
        numberCombinedIter = coder.decodeInteger(forKey: CodingKeys.numberCombinedIter.rawValue)
        maxHMMIter = coder.decodeInteger(forKey: CodingKeys.maxHMMIter.rawValue)
        maxGuideTreeIter = coder.decodeInteger(forKey: CodingKeys.maxGuideTreeIter.rawValue)
        
    }
    
       
    
    func revertToFactorySettings() {
        
        dealign = Dealign.no.rawValue
        order = Order.aligned
        mbedClusteringGuideTree = MBEDClusteringGuideTree.yes.rawValue
        mbedClusteringIteration = MBEDClusteringIteration.yes.rawValue
        numberCombinedIter = 0
        maxGuideTreeIter = 0
        maxHMMIter = 0
    }
    
    func addArg(_ prefix: String, value: String = "") {
            self.args.append(prefix)
            self.args.append(value)
        }
        
        func addArgs(inFile: String, outFile: String) {
            args = []
            args.append(infileArg + inFile)
            args.append(outfileArg + outFile)
            args.append(orderArg + order.rawValue)
            args.append(numberCombinedIterArg + String(describing: numberCombinedIter))
            args.append(maxGuideTreeIterArg + String(describing: maxGuideTreeIter))
            args.append(maxHMMIterArg + String(describing: maxHMMIter))
            args.append(forceOverwritingArg)
            
            if dealign == Dealign.yes.rawValue { args.append(dealignArg) }
            if mbedClusteringIteration == MBEDClusteringIteration.yes.rawValue { args.append(mbedClusteringIterationArg) }
            if mbedClusteringGuideTree == MBEDClusteringGuideTree.yes.rawValue { args.append(mbedClusteringGuideTreeArg) }
            
        }
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        
        let domain = "UserInputValidationErrorDomain"
        let code = 0
        
        switch inKey {
            
        case CodingKeys.numberCombinedIter.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil || Int(s)! > 5 || Int(s)! < 0 {
                    let userInfo = [NSLocalizedDescriptionKey: "Number of combined iterations must be an number between 0 and 5"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.maxGuideTreeIter.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil || Int(s)! > 5 || Int(s)! < 0 {
                    let userInfo = [NSLocalizedDescriptionKey: "Max Guide Tree Iterations value must be an integer between 0 and 5"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.maxHMMIter.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil || Int(s)! > 5 || Int(s)! < 0 {
                    let userInfo = [NSLocalizedDescriptionKey: "Max HMM Iterations value must be an integer between 0 and 5"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
            
        default: break
        }
    }
    

}
