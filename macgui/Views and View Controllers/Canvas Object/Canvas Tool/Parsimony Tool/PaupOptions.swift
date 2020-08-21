import Cocoa

class PaupOptions: NSObject, Codable, NSCoding {
    

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case criterion
        case searchMethod
        case hsSwap
        case hsKeep
        case hsKeepVal
        case hsMulTrees
        case hsReconLimit
        case hsReconLimitVal
        case hsNBest
        case hsNBestVal
        case hsRetain
        case hsAllSwap
        case hsUseNonMin
        case hsSteepest
        case hsRearrLimit
        case hsRearrLimitVal
        case hsAbortRep
        case hsRandomize
        case hsAddSeq
        case hsHold
        case hsHoldVal
        case hsNChuck
        case hsNChuckVal
        case hsChuckScore
        case hsChuckScoreVal
        case hsNreps
        case hsNrepsVal
        case bbKeep
        case bbKeepVal
        case bbMulTrees
        case bbUpBound
        case bbUpBoundVal
        case bbAddSeq
        case exKeep
        case exKeepVal
        case lsNst
        case lsTRatio
        case lsTRatioVal
        case lsRMatrix
        case lsRMatrixVal
        case lsBasefreq
        case lsBasefreqVal
        case lsRates
        case lsShape
        case lsShapeVal
        case lsNCat
        case lsNCatVal
        case lsReprate
        case lsPinvar
        case lsPinvarVal
        case lsClock
    }
    
    // MARK: - Errors

    enum PaupOptionsError: Error {
    
        case encodingError
        case decodingError
        case noData
    }

    // MARK: - PAUP* Command Options
    
    enum Criteria     : Int, Codable { case parsimony, distance, likelihood }
    enum SearchMethod : Int, Codable { case exhaustive, branchAndBound, heuristic }
    enum HSSwap       : Int, Codable { case none, nni, spr, tbr }
    enum HSKeep       : Int, Codable { case realValue, no }
    enum HSMulTrees   : Int, Codable { case no, yes }
    enum HSReconLimit : Int, Codable { case integerValue, infinity }
    enum HSNBest      : Int, Codable { case integerValue, all }
    enum HSRetain     : Int, Codable { case no, yes }
    enum HSAllSwap    : Int, Codable { case no, yes }
    enum HSUseNonMin  : Int, Codable { case no, yes }
    enum HSSteepest   : Int, Codable { case no, yes }
    enum HSRearrLimit : Int, Codable { case integerValue, none }
    enum HSAbortRep   : Int, Codable { case no, yes }
    enum HSRandomize  : Int, Codable { case addSeq, trees }
    enum HSAddSeq     : Int, Codable { case simple, closest, asIs, random, furthest }
    enum HSHold       : Int, Codable { case integerValue, no }
    enum HSNChuck     : Int, Codable { case integerValue }
    enum HSChuckScore : Int, Codable { case realValue, no }
    enum HSNreps      : Int, Codable { case integerValue }
    enum BBKeep       : Int, Codable { case realValue, no }
    enum BBMulTrees   : Int, Codable { case no, yes }
    enum BBUpBound    : Int, Codable { case realValue }
    enum BBAddSeq     : Int, Codable { case furthest, asIs, simple, maxMini, kMaxMini }
    enum EXKeep       : Int, Codable { case realValue, no }
    enum LSNst        : Int, Codable { case one=1, two=2, six=6 }
    enum LSTRatio     : Int, Codable { case realValue, estimate }
    enum LSRMatrix    : Int, Codable { case vectorValues, estimate }
    enum LSBasefreq   : Int, Codable { case empirical, equal, estimate, vectorValues }
    enum LSRates      : Int, Codable { case equal, gamma }
    enum LSShape      : Int, Codable { case realValue, estimate }
    enum LSNCat       : Int, Codable { case integerValue }
    enum LSReprate    : Int, Codable { case mean, median }
    enum LSPinvar     : Int, Codable { case realValue, estimate }
    enum LSClock      : Int, Codable { case no, yes }

    // MARK: - PAUP* Command Variables

    var criterion       = Criteria.parsimony
    var searchMethod    = SearchMethod.heuristic
    var hsSwap          = HSSwap.tbr
    var hsKeep          = HSKeep.no
    var hsKeepVal       = 0.0
    var hsMulTrees      = HSMulTrees.yes
    var hsReconLimit    = HSReconLimit.integerValue
    var hsReconLimitVal = 8
    var hsNBest         = HSNBest.all
    var hsNBestVal      = 1
    var hsRetain        = HSRetain.no
    var hsAllSwap       = HSAllSwap.no
    var hsUseNonMin     = HSUseNonMin.no
    var hsSteepest      = HSSteepest.no
    var hsRearrLimit    = HSRearrLimit.none
    var hsRearrLimitVal = 1
    var hsAbortRep      = HSAbortRep.no
    var hsRandomize     = HSRandomize.addSeq
    var hsAddSeq        = HSAddSeq.simple
    var hsHold          = HSHold.integerValue
    var hsHoldVal       = 1
    var hsNChuck        = HSNChuck.integerValue
    var hsNChuckVal     = 0
    var hsChuckScore    = HSChuckScore.no
    var hsChuckScoreVal = 0.0
    var hsNreps         = HSNreps.integerValue
    var hsNrepsVal      = 10
    var bbKeep          = BBKeep.no
    var bbKeepVal       = 0.0
    var bbMulTrees      = BBMulTrees.yes
    var bbUpBound       = BBUpBound.realValue
    var bbUpBoundVal    = 0.0
    var bbAddSeq        = BBAddSeq.furthest
    var exKeep          = EXKeep.no
    var exKeepVal       = 1
    var lsNst           = LSNst.two.rawValue
    var lsTRatio        = LSTRatio.estimate
    var lsTRatioVal     = 2.0
    var lsRMatrix       = LSRMatrix.estimate
    var lsRMatrixVal    = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    var lsBasefreq      = LSBasefreq.estimate
    var lsBasefreqVal   = [0.25, 0.25, 0.25, 0.25]
    var lsRates         = LSRates.equal
    var lsShape         = LSShape.estimate
    var lsShapeVal      = 0.5
    var lsNCat          = LSNCat.integerValue
    var lsNCatVal       = 4
    var lsReprate       = LSReprate.mean
    var lsPinvar        = LSPinvar.estimate
    var lsPinvarVal     = 0.1
    var lsClock         = LSClock.no

    // MARK: -
    
    override init() {
    
        super.init()
    }
    
    // initialize from serialized data
    required init(from decoder: Decoder) throws {

        do {
            let values           = try decoder.container(keyedBy: CodingKeys.self)
            self.criterion       = PaupOptions.Criteria(rawValue: try values.decode(Int.self, forKey: .criterion))!
            self.searchMethod    = PaupOptions.SearchMethod(rawValue: try values.decode(Int.self, forKey: .searchMethod))!
            self.hsSwap          = PaupOptions.HSSwap(rawValue: try values.decode(Int.self, forKey: .hsSwap))!
            self.hsKeep          = PaupOptions.HSKeep(rawValue: try values.decode(Int.self, forKey: .hsKeep))!
            self.hsKeepVal       = try values.decode(Double.self, forKey: .hsKeepVal)
            self.hsMulTrees      = PaupOptions.HSMulTrees(rawValue: try values.decode(Int.self, forKey: .hsMulTrees))!
            self.hsReconLimit    = PaupOptions.HSReconLimit(rawValue: try values.decode(Int.self, forKey: .hsReconLimit))!
            self.hsReconLimitVal = try values.decode(Int.self, forKey: .hsReconLimitVal)
            self.hsNBest         = PaupOptions.HSNBest(rawValue: try values.decode(Int.self, forKey: .hsNBest))!
            self.hsNBestVal      = try values.decode(Int.self, forKey: .hsNBestVal)
            self.hsRetain        = PaupOptions.HSRetain(rawValue: try values.decode(Int.self, forKey: .hsRetain))!
            self.hsAllSwap       = PaupOptions.HSAllSwap(rawValue: try values.decode(Int.self, forKey: .hsAllSwap))!
            self.hsUseNonMin     = PaupOptions.HSUseNonMin(rawValue: try values.decode(Int.self, forKey: .hsUseNonMin))!
            self.hsSteepest      = PaupOptions.HSSteepest(rawValue: try values.decode(Int.self, forKey: .hsSteepest))!
            self.hsRearrLimit    = PaupOptions.HSRearrLimit(rawValue: try values.decode(Int.self, forKey: .hsRearrLimit))!
            self.hsRearrLimitVal = try values.decode(Int.self, forKey: .hsRearrLimitVal)
            self.hsAbortRep      = PaupOptions.HSAbortRep(rawValue: try values.decode(Int.self, forKey: .hsAbortRep))!
            self.hsRandomize     = PaupOptions.HSRandomize(rawValue: try values.decode(Int.self, forKey: .hsRandomize))!
            self.hsAddSeq        = PaupOptions.HSAddSeq(rawValue: try values.decode(Int.self, forKey: .hsAddSeq))!
            self.hsHold          = PaupOptions.HSHold(rawValue: try values.decode(Int.self, forKey: .hsHold))!
            self.hsHoldVal       = try values.decode(Int.self, forKey: .hsHoldVal)
            self.hsNChuck        = PaupOptions.HSNChuck(rawValue: try values.decode(Int.self, forKey: .hsNChuck))!
            self.hsNChuckVal     = try values.decode(Int.self, forKey: .hsNChuckVal)
            self.hsChuckScore    = PaupOptions.HSChuckScore(rawValue: try values.decode(Int.self, forKey: .hsChuckScore))!
            self.hsChuckScoreVal = try values.decode(Double.self, forKey: .hsChuckScoreVal)
            self.hsNreps         = PaupOptions.HSNreps(rawValue: try values.decode(Int.self, forKey: .hsNreps))!
            self.hsNrepsVal      = try values.decode(Int.self, forKey: .hsNrepsVal)
            self.bbKeep          = PaupOptions.BBKeep(rawValue: try values.decode(Int.self, forKey: .bbKeep))!
            self.bbKeepVal       = try values.decode(Double.self, forKey: .bbKeepVal)
            self.bbMulTrees      = PaupOptions.BBMulTrees(rawValue: try values.decode(Int.self, forKey: .bbMulTrees))!
            self.bbUpBound       = PaupOptions.BBUpBound(rawValue: try values.decode(Int.self, forKey: .bbUpBound))!
            self.bbUpBoundVal    = try values.decode(Double.self, forKey: .bbUpBoundVal)
            self.bbAddSeq        = PaupOptions.BBAddSeq(rawValue: try values.decode(Int.self, forKey: .bbAddSeq))!
            self.exKeep          = PaupOptions.EXKeep(rawValue: try values.decode(Int.self, forKey: .exKeep))!
            self.exKeepVal       = try values.decode(Int.self, forKey: .exKeepVal)
            self.lsNst           = PaupOptions.LSNst(rawValue: try values.decode(Int.self, forKey: .lsNst))!.rawValue
            self.lsTRatio        = PaupOptions.LSTRatio(rawValue: try values.decode(Int.self, forKey: .lsTRatio))!
            self.lsTRatioVal     = try values.decode(Double.self, forKey: .lsTRatioVal)
            self.lsRMatrix       = PaupOptions.LSRMatrix(rawValue: try values.decode(Int.self, forKey: .lsRMatrix))!
            self.lsRMatrixVal    = try values.decode([Double].self, forKey: .lsRMatrixVal)
            self.lsBasefreq      = PaupOptions.LSBasefreq(rawValue: try values.decode(Int.self, forKey: .lsBasefreq))!
            self.lsBasefreqVal   = try values.decode([Double].self, forKey: .lsBasefreqVal)
            self.lsRates         = PaupOptions.LSRates(rawValue: try values.decode(Int.self, forKey: .lsRates))!
            self.lsShape         = PaupOptions.LSShape(rawValue: try values.decode(Int.self, forKey: .lsShape))!
            self.lsShapeVal      = try values.decode(Double.self, forKey: .lsShapeVal)
            self.lsNCat          = PaupOptions.LSNCat(rawValue: try values.decode(Int.self, forKey: .lsNCat))!
            self.lsNCatVal       = try values.decode(Int.self, forKey: .lsNCatVal)
            self.lsReprate       = PaupOptions.LSReprate(rawValue: try values.decode(Int.self, forKey: .lsReprate))!
            self.lsPinvar        = PaupOptions.LSPinvar(rawValue: try values.decode(Int.self, forKey: .lsPinvar))!
            self.lsPinvarVal     = try values.decode(Double.self, forKey: .lsPinvarVal)
            self.lsClock         = PaupOptions.LSClock(rawValue: try values.decode(Int.self, forKey: .lsClock))!
        }
        catch {
            throw PaupOptionsError.decodingError
        }
    }

    // encode the object for serialization
    func encode(to encoder: Encoder) throws {

        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(criterion,       forKey: .criterion)
            try container.encode(searchMethod,    forKey: .searchMethod)
            try container.encode(hsSwap,          forKey: .hsSwap)
            try container.encode(hsKeep,          forKey: .hsKeep)
            try container.encode(hsKeepVal,       forKey: .hsKeepVal)
            try container.encode(hsMulTrees,      forKey: .hsMulTrees)
            try container.encode(hsReconLimit,    forKey: .hsReconLimit)
            try container.encode(hsReconLimitVal, forKey: .hsReconLimitVal)
            try container.encode(hsNBest,         forKey: .hsNBest)
            try container.encode(hsNBestVal,      forKey: .hsNBestVal)
            try container.encode(hsRetain,        forKey: .hsRetain)
            try container.encode(hsAllSwap,       forKey: .hsAllSwap)
            try container.encode(hsUseNonMin,     forKey: .hsUseNonMin)
            try container.encode(hsSteepest,      forKey: .hsSteepest)
            try container.encode(hsRearrLimit,    forKey: .hsRearrLimit)
            try container.encode(hsRearrLimitVal, forKey: .hsRearrLimitVal)
            try container.encode(hsAbortRep,      forKey: .hsAbortRep)
            try container.encode(hsAbortRep,      forKey: .hsAbortRep)
            try container.encode(hsRandomize,     forKey: .hsRandomize)
            try container.encode(hsAddSeq,        forKey: .hsAddSeq)
            try container.encode(hsHold,          forKey: .hsHold)
            try container.encode(hsHoldVal,       forKey: .hsHoldVal)
            try container.encode(hsNChuck,        forKey: .hsNChuck)
            try container.encode(hsNChuckVal,     forKey: .hsNChuckVal)
            try container.encode(hsChuckScore,    forKey: .hsChuckScore)
            try container.encode(hsChuckScoreVal, forKey: .hsChuckScoreVal)
            try container.encode(hsNreps,         forKey: .hsNreps)
            try container.encode(hsNrepsVal,      forKey: .hsNrepsVal)
            try container.encode(bbKeep,          forKey: .bbKeep)
            try container.encode(bbKeepVal,       forKey: .bbKeepVal)
            try container.encode(bbMulTrees,      forKey: .bbMulTrees)
            try container.encode(bbUpBound,       forKey: .bbUpBound)
            try container.encode(bbUpBoundVal,    forKey: .bbUpBoundVal)
            try container.encode(bbAddSeq,        forKey: .bbAddSeq)
            try container.encode(exKeep,          forKey: .exKeep)
            try container.encode(exKeepVal,       forKey: .exKeepVal)
            try container.encode(lsNst,           forKey: .lsNst)
            try container.encode(lsTRatio,        forKey: .lsTRatio)
            try container.encode(lsTRatioVal,     forKey: .lsTRatioVal)
            try container.encode(lsRMatrix,       forKey: .lsRMatrix)
            try container.encode(lsRMatrixVal,    forKey: .lsRMatrixVal)
            try container.encode(lsRMatrixVal,    forKey: .lsRMatrixVal)
            try container.encode(lsBasefreq,      forKey: .lsBasefreq)
            try container.encode(lsBasefreqVal,   forKey: .lsBasefreqVal)
            try container.encode(lsRates,         forKey: .lsRates)
            try container.encode(lsShape,         forKey: .lsShape)
            try container.encode(lsShapeVal,      forKey: .lsShapeVal)
            try container.encode(lsNCat,          forKey: .lsNCat)
            try container.encode(lsNCatVal,       forKey: .lsNCatVal)
            try container.encode(lsReprate,       forKey: .lsReprate)
            try container.encode(lsPinvar,        forKey: .lsPinvar)
            try container.encode(lsPinvarVal,     forKey: .lsPinvarVal)
            try container.encode(lsClock,         forKey: .lsClock)
        }
        catch {
            throw PaupOptionsError.encodingError
        }
    }
    
//    MARK: -- NSCoding
    
       func encode(with coder: NSCoder) {
        coder.encode(criterion.rawValue, forKey: CodingKeys.criterion.rawValue)
        coder.encode(searchMethod.rawValue, forKey: CodingKeys.searchMethod.rawValue)
        coder.encode(hsSwap.rawValue, forKey: CodingKeys.hsSwap.rawValue)
        coder.encode(hsKeep.rawValue, forKey: CodingKeys.hsKeep.rawValue)
        coder.encode(hsKeepVal, forKey: CodingKeys.hsKeepVal.rawValue)
        coder.encode(hsMulTrees.rawValue, forKey: CodingKeys.hsMulTrees.rawValue)
        coder.encode(hsReconLimit.rawValue, forKey: CodingKeys.hsReconLimit.rawValue)
        coder.encode(hsReconLimitVal, forKey: CodingKeys.hsReconLimitVal.rawValue)

//        var hsNBest         = HSNBest.all
//        var hsNBestVal      = 1
//        var hsRetain        = HSRetain.no
//        var hsAllSwap       = HSAllSwap.no
//        var hsUseNonMin     = HSUseNonMin.no
//        var hsSteepest      = HSSteepest.no
//        var hsRearrLimit    = HSRearrLimit.none
//        var hsRearrLimitVal = 1
//        var hsAbortRep      = HSAbortRep.no
//        var hsRandomize     = HSRandomize.addSeq
//        var hsAddSeq        = HSAddSeq.simple
//        var hsHold          = HSHold.integerValue
//        var hsHoldVal       = 1
//        var hsNChuck        = HSNChuck.integerValue
//        var hsNChuckVal     = 0
//        var hsChuckScore    = HSChuckScore.no
//        var hsChuckScoreVal = 0.0
//        var hsNreps         = HSNreps.integerValue
//        var hsNrepsVal      = 10
//        var bbKeep          = BBKeep.no
//        var bbKeepVal       = 0.0
//        var bbMulTrees      = BBMulTrees.yes
//        var bbUpBound       = BBUpBound.realValue
//        var bbUpBoundVal    = 0.0
//        var bbAddSeq        = BBAddSeq.furthest
//        var exKeep          = EXKeep.no
//        var exKeepVal       = 1
//        var lsNst           = LSNst.two.rawValue
//        var lsTRatio        = LSTRatio.estimate
//        var lsTRatioVal     = 2.0
//        var lsRMatrix       = LSRMatrix.estimate
//        var lsRMatrixVal    = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
//        var lsBasefreq      = LSBasefreq.estimate
//        var lsBasefreqVal   = [0.25, 0.25, 0.25, 0.25]
//        var lsRates         = LSRates.equal
//        var lsShape         = LSShape.estimate
//        var lsShapeVal      = 0.5
//        var lsNCat          = LSNCat.integerValue
//        var lsNCatVal       = 4
//        var lsReprate       = LSReprate.mean
//        var lsPinvar        = LSPinvar.estimate
//        var lsPinvarVal     = 0.1
//        var lsClock         = LSClock.no
    
       }
       
       required init?(coder: NSCoder) {
           <#code#>
       }
       

    func revertToFactorySettings() {
    
        criterion       = Criteria.parsimony
        searchMethod    = SearchMethod.heuristic
        hsSwap          = HSSwap.tbr
        hsKeep          = HSKeep.no
        hsKeepVal       = 0.0
        hsMulTrees      = HSMulTrees.yes
        hsReconLimit    = HSReconLimit.integerValue
        hsReconLimitVal = 8
        hsNBest         = HSNBest.all
        hsNBestVal      = 1
        hsRetain        = HSRetain.no
        hsAllSwap       = HSAllSwap.no
        hsUseNonMin     = HSUseNonMin.no
        hsSteepest      = HSSteepest.no
        hsRearrLimit    = HSRearrLimit.none
        hsRearrLimitVal = 1
        hsAbortRep      = HSAbortRep.no
        hsRandomize     = HSRandomize.addSeq
        hsAddSeq        = HSAddSeq.simple
        hsHold          = HSHold.integerValue
        hsHoldVal       = 1
        hsNChuck        = HSNChuck.integerValue
        hsNChuckVal     = 0
        hsChuckScore    = HSChuckScore.no
        hsChuckScoreVal = 0.0
        hsNreps         = HSNreps.integerValue
        hsNrepsVal      = 10
        bbKeep          = BBKeep.no
        bbKeepVal       = 0.0
        bbMulTrees      = BBMulTrees.yes
        bbUpBound       = BBUpBound.realValue
        bbUpBoundVal    = 0.0
        bbAddSeq        = BBAddSeq.furthest
        exKeep          = EXKeep.no
        exKeepVal       = 1
        lsNst           = LSNst.two.rawValue
        lsTRatio        = LSTRatio.estimate
        lsTRatioVal     = 2.0
        lsRMatrix       = LSRMatrix.estimate
        lsRMatrixVal    = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
        lsBasefreq      = LSBasefreq.estimate
        lsBasefreqVal   = [0.25, 0.25, 0.25, 0.25]
        lsRates         = LSRates.equal
        lsShape         = LSShape.estimate
        lsShapeVal      = 0.5
        lsNCat          = LSNCat.integerValue
        lsNCatVal       = 4
        lsReprate       = LSReprate.mean
        lsPinvar        = LSPinvar.estimate
        lsPinvarVal     = 0.1
        lsClock         = LSClock.no
    }
    
    func setString() -> String {
    
        var str : String = "set AutoClose=yes WarnReset=no Increase=auto NotifyBeep=no ErrorBeep=no WarnTSave=no"
        str += " Criterion=\(criterion);"
        return str
    }
    
    func methodsAssumptionsString() -> String {
    
        var str : String = ""
        if criterion == Criteria.likelihood {
            str += lsetString()
        } else if criterion == Criteria.distance {
            str += dsetString()
        } else {
            str += psetString()
        }
        return str
    }
    
    func criterionString() -> String {
    
        var str : String = "set criterion="
        str += String(describing: criterion)
        str += ";"
        return str
    }
 
    func dsetString() -> String {
    
        let str : String = "dset;"
        return str
    }

    func lsetString() -> String {
    
        var str : String = "lset"
        str += " Nst=\(String(describing: lsNst))"
        if lsTRatio == LSTRatio.estimate {
            str += " TRatio=\(String(describing: lsTRatio))"
        } else {
            str += " TRatio=\(String(lsTRatioVal))"
        }
        if lsRMatrix == LSRMatrix.estimate {
            str += " RMatrix=\(String(describing: lsRMatrix))"
        } else {
            str += " RMatrix=("
            for d in lsRMatrixVal {
                str += " \(String(describing: d))"
            }
            str += " )"
        }
        if lsBasefreq == LSBasefreq.estimate {
            str += " Basefreq=\(String(describing: lsBasefreq))"
        } else {
            str += " Basefreq=("
            for d in lsBasefreqVal {
                str += " \(String(describing: d))"
            }
            str += " )"
        }
        str += " Rates=\(String(describing: lsRates))"
        if lsShape == LSShape.estimate {
            str += " Shape=\(String(describing: lsShape))"
        } else {
            str += " Shape=\(String(lsShapeVal))"
        }
        str += " Ncat=\(String(describing: lsNCatVal))"
        str += " Reprate=\(String(describing: lsReprate))"
        if lsPinvar == LSPinvar.estimate {
            str += " Pinvar=\(String(describing: lsPinvar))"
        } else {
            str += " Pinvar=\(String(lsPinvarVal))"
        }
        str += " Clock=\(String(describing: lsClock))"
        str += ";"

        return str
    }

    func psetString() -> String {
    
        let str : String = "pset;"
        return str
    }

    func searchMethodString() -> String {
    
        var str : String = ""
        
        if searchMethod == SearchMethod.exhaustive {
        
            str += "Alltrees"
            if exKeep == EXKeep.no {
                str += " Keep=\(String(describing: exKeep))"
            } else {
                str += " Keep=\(String(exKeepVal))"
            }
            str += ";"
        } else if searchMethod == SearchMethod.branchAndBound {
        
            str += "Bandb"
            if bbKeep == BBKeep.no {
                str += " Keep=\(String(describing: bbKeep))"
            } else {
                str += " Keep=\(String(bbKeepVal))"
            }
            str += " Multrees=\(String(describing: bbMulTrees))"
            str += " Addseq=\(String(describing: bbAddSeq))"
            str += " Upbound=\(String(describing: bbUpBoundVal))"
            str += ";"
        } else {
        
            str += "Hsearch"
            if hsKeep == HSKeep.no {
                str += " Keep=\(String(describing: hsKeep))"
            } else {
                str += " Keep=\(String(hsKeepVal))"
            }
            str += " Swap=\(String(describing: hsSwap))"
            str += " Multrees=\(String(describing: hsMulTrees))"
            if hsRearrLimit == HSRearrLimit.none {
                str += " RearrLimit=\(String(describing: hsRearrLimit))"
            } else {
                str += " RearrLimit=\(String(describing: hsRearrLimitVal))"
            }
            if hsReconLimit == HSReconLimit.infinity {
                str += " ReconLimit=\(String(describing: hsRearrLimit))"
            } else {
                str += " ReconLimit=\(String(describing: hsRearrLimitVal))"
            }
            if hsNBest == HSNBest.all {
                str += " NBest=\(String(describing: hsNBest))"
            } else {
                str += " NBest=\(String(describing: hsNBestVal))"
            }
            str += " Retain=\(String(describing: hsRetain))"
            str += " AllSwap=\(String(describing: hsAllSwap))"
            str += " UseNonMin=\(String(describing: hsUseNonMin))"
            str += " Steepest=\(String(describing: hsSteepest))"
            str += " NChuck=\(String(describing: hsNChuckVal))"
            if hsChuckScore == HSChuckScore.no {
                str += " ChuckScore=\(String(describing: hsChuckScore))"
            } else {
                str += " ChuckScore=\(String(describing: hsChuckScoreVal))"
            }
            str += " AbortRep=\(String(describing: hsAbortRep))"
            str += " Randomize=\(String(describing: hsRandomize))"
            str += " AddSeq=\(String(describing: hsAddSeq))"
            str += " NReps=\(String(describing: hsNrepsVal))"
            if hsHold == HSHold.no {
                str += " Hold=\(String(describing: hsHold))"
            } else {
                str += " Hold=\(String(describing: hsHoldVal))"
            }
            str += ";"
        }
        
        return str
    }
}
