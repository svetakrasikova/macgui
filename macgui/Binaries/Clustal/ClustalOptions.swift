import Cocoa


@objcMembers
class ClustalOptions: NSObject, Codable {
    
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        
        case align
        case wordLength
        case window
        case scoreType
        case numberDiagonals
        case pairGapPenalty
        case matrix
        case gapOpenPenalty
        case endGaps
        case gapExtensionCost
        case gapSeparationPenalty
        case iteration
        case numberOfIterations
    }
    
    // MARK: - Errors
    
    enum ClustalOptionsError: Error {
        
        case encodingError
        case decodingError
    }
    
    // MARK: - Clustal Command Options
    
    enum Align                : Int, Codable { case full, fast }
    enum WordLength           : Int, Codable { case integerValue }
    enum Window               : Int, Codable { case integerValue }
    enum ScoreType            : Int, Codable { case percent, absolute }
    enum NumberDiagonals      : Int, Codable { case integerValue }
    enum PairGapPenalty       : Int, Codable { case integerValue }
    enum Matrix               : Int, Codable { case gonnet, blosum, pam }
    enum GapOpenPenalty       : Int, Codable { case realValue }
    enum EndGaps              : Int, Codable { case no, yes }
    enum GapExtensionCost     : Int, Codable { case realValue }
    enum GapSeparationPenalty : Int, Codable { case integerValue }
    enum Iteration            : Int, Codable { case none, tree, alignment }
    enum NumberOfIterations   : Int, Codable { case integerValue }
    
    // MARK: - Clustal Command Variables
    // Default values taken from http://www.ebi.ac.uk/Tools/msa/clustalw2/help/
    
    var align                   = Align.full
    var wordLength              = 1
    var window                  = 5
    var scoreType               = ScoreType.percent
    var numberDiagonals         = 5
    var pairGapPenalty          = 3
    var matrix                  = Matrix.gonnet
    var gapOpenPenalty          = 10.0
    var endGaps                 = EndGaps.no
    var gapExtensionCost        = 0.2
    var gapSeparationPenalty    = 5
    var iteration               = Iteration.none
    var numberOfIterations      = 1
    
    
    let clustalMultipleAlignArg        = " -ALIGN"
    let clustalInfileArg               = " -INFILE="
    let clustalOutfileArg              = " -OUTFILE="
    let clustalOutputArg               = " -OUTPUT=FASTA"
    let clustalGuideTreeArg            = " -NEWTREE="
    let clustalAlignArg                = " -QUICKTREE"
    let clustalWordLengthArg           = " -KTUPLE="
    let clustalWindowArg               = " -WINDOW="
    let clustalScoreTypeArg            = " -SCORE="
    let clustalNumberDiagonalsArg      = " -TOPDIAGS="
    let clustalPairGapPenaltyArg       = " -PAIRGAP="
    let clustalMatrixArg               = " -PWMATRIX="
    let clustalGapOpenPenaltyAr        = " -PWGAPEXT="
    let clustalEndGapsArg              = " -ENDGAPS="
    let clustalGapExtensionCostArg     = " -GAPEXT="
    let clustalGapSeparationPenaltyArg = " -GAPDIST="
    let clustalIterationArg            = " -ITERATION="
    let clustalNumberOfIterationsArg   = " -NUMITER="
    
    var args: [String] = []
    
    
    // MARK: -
    
    override init() {
        
        super.init()
    }
    
    // initialize from serialized data
    required init(from decoder: Decoder) throws {
        
        do {
            let values                   = try decoder.container(keyedBy: CodingKeys.self)
            self.align                   = ClustalOptions.Align(rawValue: try values.decode(Int.self, forKey: .align))!
            self.wordLength           = try values.decode(Int.self, forKey: .wordLength)
            self.window               = try values.decode(Int.self, forKey: .window)
            self.scoreType               = ClustalOptions.ScoreType(rawValue: try values.decode(Int.self, forKey: .scoreType))!
            self.numberDiagonals      = try values.decode(Int.self, forKey: .numberDiagonals)
            self.pairGapPenalty       = try values.decode(Int.self, forKey: .pairGapPenalty)
            self.matrix                  = ClustalOptions.Matrix(rawValue: try values.decode(Int.self, forKey: .matrix))!
            self.gapOpenPenalty       = try values.decode(Double.self, forKey: .gapOpenPenalty)
            self.endGaps                 = ClustalOptions.EndGaps(rawValue: try values.decode(Int.self, forKey: .endGaps))!
            self.gapExtensionCost     = try values.decode(Double.self, forKey: .gapExtensionCost)
            self.gapSeparationPenalty = try values.decode(Int.self, forKey: .gapSeparationPenalty)
            self.iteration               = ClustalOptions.Iteration(rawValue: try values.decode(Int.self, forKey: .iteration))!
            self.numberOfIterations   = try values.decode(Int.self, forKey: .numberOfIterations)
        }
        catch {
            throw ClustalOptionsError.decodingError
        }
    }
    
    // encode the object for serialization
    func encode(to encoder: Encoder) throws {
        
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(align,                   forKey: .align)
            try container.encode(wordLength,              forKey: .wordLength)
            try container.encode(window,                  forKey: .window)
            try container.encode(scoreType,               forKey: .scoreType)
            try container.encode(numberDiagonals,         forKey: .numberDiagonals)
            try container.encode(pairGapPenalty,          forKey: .pairGapPenalty)
            try container.encode(matrix,                  forKey: .matrix)
            try container.encode(gapOpenPenalty,          forKey: .gapOpenPenalty)
            try container.encode(endGaps,                 forKey: .endGaps)
            try container.encode(gapExtensionCost,        forKey: .gapExtensionCost)
            try container.encode(gapSeparationPenalty,    forKey: .gapSeparationPenalty)
            try container.encode(iteration,               forKey: .iteration)
            try container.encode(numberOfIterations,      forKey: .numberOfIterations)
        }
        catch {
            throw ClustalOptionsError.encodingError
        }
    }
    
    func revertToFactorySettings() {
        
        align                   = Align.full
        wordLength              = 1
        window                  = 5
        scoreType               = ScoreType.percent
        numberDiagonals         = 5
        pairGapPenalty          = 3
        matrix                  = Matrix.gonnet
        gapOpenPenalty          = 10.0
        endGaps                 = EndGaps.no
        gapExtensionCost        = 0.2
        gapSeparationPenalty    = 5
        iteration               = Iteration.none
        numberOfIterations      = 1
    }
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        let domain = "UserInputValidationErrorDomain"
        let code = 0
        switch inKey {
        case CodingKeys.wordLength.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Word Length value must be an integer"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.window.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Window value must be an integer"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.numberDiagonals.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Number Diagonals value must be an integer"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.pairGapPenalty.rawValue:
            if let s = ioValue.pointee as? String {
                if Int(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Pair Gap Penalty must be an integer"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.gapOpenPenalty.rawValue:
            if let s = ioValue.pointee as? String {
                if Float(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Gap Open Penalty must be a number"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.gapExtensionCost.rawValue:
            if let s = ioValue.pointee as? String {
                if Float(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Gap Extension Cost must be a number"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.gapSeparationPenalty.rawValue:
            if let s = ioValue.pointee as? String {
                if Float(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Gap Separation Penalty must be a number"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        case CodingKeys.numberOfIterations.rawValue:
            if let s = ioValue.pointee as? String {
                if Float(s) == nil {
                    let userInfo = [NSLocalizedDescriptionKey: "Number of iterations must be an integer"]
                    throw NSError(domain: domain,
                                  code: code,
                                  userInfo: userInfo)
                }
            }
        default: break
        }
    }
    
    
    func addArg(_ prefix: String, value: String = "") {
        self.args.append(prefix)
        self.args.append(value)
    }
    
    func addArgs(inFile: String, outFile: String) {
        
        addArg(clustalInfileArg, value: inFile)
        addArg(clustalOutfileArg, value: outFile)
        addArg(clustalOutputArg)
        //            addArg(clustalGuideTreeArg, value: )
        addArg(clustalWordLengthArg, value: String(describing: wordLength))
        addArg(clustalWindowArg, value: String(describing: window))
        addArg(clustalScoreTypeArg, value: String(describing: scoreType))
        addArg(clustalNumberDiagonalsArg, value: String(describing: numberDiagonals))
        addArg(clustalPairGapPenaltyArg, value: String(describing: pairGapPenalty))
        addArg(clustalMatrixArg, value: String(describing: matrix))
        addArg(clustalGapOpenPenaltyAr, value: String(describing: gapOpenPenalty))
        addArg(clustalEndGapsArg, value: String(describing: endGaps))
        addArg(clustalGapExtensionCostArg, value: String(describing: gapExtensionCost))
        addArg(clustalGapSeparationPenaltyArg, value: String(describing: gapSeparationPenalty))
        addArg(clustalIterationArg, value: String(describing: iteration))
        addArg(clustalNumberOfIterationsArg, value: String(describing: numberOfIterations))
        addArg(clustalMultipleAlignArg)
        
        if align == Align.fast { addArg(clustalAlignArg) }
        
    }
    
}
