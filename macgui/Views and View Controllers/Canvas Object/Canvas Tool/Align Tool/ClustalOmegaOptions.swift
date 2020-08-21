//
//  ClustalOmegaOptions.swift
//  macgui
//
//  Created by Svetlana Krasikova on 7/7/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

@objcMembers
class ClustalOmegaOptions: NSObject, Codable {
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        
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
       
    enum Dealign: Int, Codable { case yes, no }
    enum Order: String, Codable { case aligned = "tree-order", input = "input-order" }
    enum MBEDClusteringGuideTree: Int, Codable { case yes, no }
    enum MBEDClusteringIteration: Int, Codable { case yes, no }
    enum NumberCombinedIter: Int, Codable { case integerValue }
    enum MAXGuideTreeIter: Int, Codable { case integerValue }
    enum MAXHMMIter: Int, Codable { case integerValue }
       
       // MARK: - Clustal Command Variables
       
    var dealign = Dealign.no
    var order = Order.aligned
    var mbedClusteringGuideTree = MBEDClusteringGuideTree.yes
    var mbedClusteringIteration = MBEDClusteringIteration.yes
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
    

    required init(from decoder: Decoder) throws {
        
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.dealign = ClustalOmegaOptions.Dealign(rawValue: try values.decode(Int.self, forKey: .dealign))!
            self.order = ClustalOmegaOptions.Order(rawValue: try values.decode(String.self, forKey: .order))!
            self.mbedClusteringGuideTree = ClustalOmegaOptions.MBEDClusteringGuideTree(rawValue: try values.decode(Int.self, forKey: .mbedClusteringGuideTree))!
            self.mbedClusteringIteration = ClustalOmegaOptions.MBEDClusteringIteration(rawValue: try values.decode(Int.self, forKey: .mbedClusteringIteration))!
            self.numberCombinedIter = try values.decode(Int.self, forKey: .numberCombinedIter)
            self.maxHMMIter = try values.decode(Int.self, forKey: .maxHMMIter)
            self.maxGuideTreeIter = try values.decode(Int.self, forKey: .maxGuideTreeIter)
        }
        catch {
            throw ClustalOmegaOptionsError.decodingError
        }
    }
    

    func encode(to encoder: Encoder) throws {
        
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(dealign, forKey: .dealign)
            try container.encode(order, forKey: .order)
            try container.encode(mbedClusteringIteration, forKey: .mbedClusteringIteration)
            try container.encode(mbedClusteringGuideTree, forKey: .mbedClusteringGuideTree)
            try container.encode(numberCombinedIter, forKey: .numberCombinedIter)
            try container.encode(maxGuideTreeIter, forKey: .maxGuideTreeIter)
            try container.encode(maxHMMIter, forKey: .maxHMMIter)
        }
        catch {
            throw ClustalOmegaOptionsError.encodingError
        }
    }
    
    func revertToFactorySettings() {
        
        dealign = Dealign.no
        order = Order.aligned
        mbedClusteringGuideTree = MBEDClusteringGuideTree.yes
        mbedClusteringIteration = MBEDClusteringIteration.yes
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
            
            if dealign == Dealign.yes { args.append(dealignArg) }
            if mbedClusteringIteration == MBEDClusteringIteration.yes { args.append(mbedClusteringIterationArg) }
            if mbedClusteringGuideTree == MBEDClusteringGuideTree.yes { args.append(mbedClusteringGuideTreeArg) }
            
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
