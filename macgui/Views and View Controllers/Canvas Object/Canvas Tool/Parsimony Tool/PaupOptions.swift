import Cocoa

class PaupOptions: NSObject, NSCoding {
    

    // MARK: - Coding Keys

    private enum CodingKeys: String {
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
        coder.encode(hsNBest.rawValue, forKey: CodingKeys.hsNBest.rawValue)
        coder.encode(hsNBestVal, forKey: CodingKeys.hsNBestVal.rawValue)
        coder.encode(hsRetain.rawValue, forKey: CodingKeys.hsRetain.rawValue)
        coder.encode(hsAllSwap.rawValue, forKey: CodingKeys.hsAllSwap.rawValue)
        coder.encode(hsUseNonMin.rawValue, forKey: CodingKeys.hsUseNonMin.rawValue)
        coder.encode(hsSteepest.rawValue, forKey: CodingKeys.hsSteepest.rawValue)
        coder.encode(hsRearrLimit .rawValue, forKey: CodingKeys.hsRearrLimit.rawValue)
        coder.encode(hsRearrLimitVal, forKey: CodingKeys.hsRearrLimitVal.rawValue)
        coder.encode(hsAbortRep.rawValue, forKey: CodingKeys.hsAbortRep.rawValue)
        coder.encode(hsRandomize.rawValue, forKey: CodingKeys.hsRandomize.rawValue)
        coder.encode(hsAddSeq.rawValue, forKey: CodingKeys.hsAddSeq.rawValue)
        coder.encode(hsHold.rawValue, forKey: CodingKeys.hsHold.rawValue)
        coder.encode(hsHoldVal, forKey: CodingKeys.hsHoldVal.rawValue)
        coder.encode(hsNChuck.rawValue, forKey: CodingKeys.hsNChuck.rawValue)
        coder.encode(hsNChuckVal, forKey: CodingKeys.hsNChuckVal.rawValue)
        coder.encode(hsChuckScore.rawValue, forKey: CodingKeys.hsChuckScore.rawValue)
        coder.encode(hsChuckScoreVal, forKey: CodingKeys.hsChuckScoreVal.rawValue)
        coder.encode(hsNreps.rawValue, forKey: CodingKeys.hsNreps.rawValue)
        coder.encode(hsNrepsVal, forKey: CodingKeys.hsNrepsVal.rawValue)
        coder.encode(bbKeep.rawValue, forKey: CodingKeys.bbKeep.rawValue)
        coder.encode(bbKeepVal, forKey: CodingKeys.bbKeepVal.rawValue)
        coder.encode(bbMulTrees.rawValue, forKey: CodingKeys.bbMulTrees.rawValue)
        coder.encode(bbUpBound.rawValue, forKey: CodingKeys.bbUpBound.rawValue)
        coder.encode(bbUpBoundVal, forKey: CodingKeys.bbUpBoundVal.rawValue)
        coder.encode(bbAddSeq.rawValue, forKey: CodingKeys.bbAddSeq.rawValue)
        coder.encode(exKeep.rawValue, forKey: CodingKeys.exKeep.rawValue)
        coder.encode(exKeepVal, forKey: CodingKeys.exKeepVal.rawValue)
        coder.encode(lsNst, forKey: CodingKeys.lsNst.rawValue)
        coder.encode(lsTRatio.rawValue, forKey: CodingKeys.lsTRatio.rawValue)
        coder.encode(lsTRatioVal, forKey: CodingKeys.lsTRatioVal.rawValue)
        coder.encode(lsRMatrix.rawValue, forKey: CodingKeys.lsRMatrix.rawValue)
        coder.encode(lsRMatrixVal, forKey: CodingKeys.lsRMatrixVal.rawValue)
        coder.encode(lsBasefreq.rawValue, forKey: CodingKeys.lsBasefreq.rawValue)
        coder.encode(lsBasefreqVal, forKey: CodingKeys.lsBasefreqVal.rawValue)
        coder.encode(lsRates.rawValue, forKey: CodingKeys.lsRates.rawValue)
        coder.encode(lsRates.rawValue, forKey: CodingKeys.lsRates.rawValue)
        coder.encode(lsShape.rawValue, forKey: CodingKeys.lsShape.rawValue)
        coder.encode(lsShapeVal, forKey: CodingKeys.lsShapeVal.rawValue)
        coder.encode(lsNCat.rawValue, forKey: CodingKeys.lsNCat.rawValue)
        coder.encode(lsNCatVal, forKey: CodingKeys.lsNCatVal.rawValue)
        coder.encode(lsReprate.rawValue, forKey: CodingKeys.lsReprate.rawValue)
        coder.encode(lsPinvar.rawValue, forKey: CodingKeys.lsPinvar.rawValue)
        coder.encode(lsPinvarVal, forKey: CodingKeys.lsPinvarVal.rawValue)
        coder.encode(lsClock.rawValue, forKey: CodingKeys.lsClock.rawValue)
    }
       
    required init?(coder: NSCoder) {
        criterion =  Criteria(rawValue: coder.decodeObject(forKey: CodingKeys.criterion.rawValue) as! Int) ?? Criteria.parsimony
        searchMethod =  SearchMethod(rawValue: coder.decodeObject(forKey: CodingKeys.searchMethod.rawValue) as! Int) ?? SearchMethod.heuristic
        hsSwap =  HSSwap(rawValue: coder.decodeObject(forKey: CodingKeys.hsSwap.rawValue) as! Int) ?? HSSwap.tbr
        hsKeep =  HSKeep(rawValue: coder.decodeObject(forKey: CodingKeys.hsKeep.rawValue) as! Int) ?? HSKeep.no
        hsKeepVal = coder.decodeDouble(forKey: CodingKeys.hsKeepVal.rawValue)
        hsMulTrees =  HSMulTrees(rawValue: coder.decodeObject(forKey: CodingKeys.hsMulTrees.rawValue) as! Int) ?? HSMulTrees.yes
        hsReconLimit =  HSReconLimit(rawValue: coder.decodeObject(forKey: CodingKeys.hsReconLimit.rawValue) as! Int) ?? HSReconLimit.integerValue
        hsReconLimitVal = coder.decodeInteger(forKey: CodingKeys.hsReconLimitVal.rawValue)
        hsNBest  =  HSNBest(rawValue: coder.decodeObject(forKey: CodingKeys.hsNBest.rawValue) as! Int) ?? HSNBest.all
        hsNBestVal = coder.decodeInteger(forKey: CodingKeys.hsNBestVal.rawValue)
        hsRetain  =  HSRetain(rawValue: coder.decodeObject(forKey: CodingKeys.hsRetain.rawValue) as! Int) ?? HSRetain.no
        hsAllSwap  =  HSAllSwap(rawValue: coder.decodeObject(forKey: CodingKeys.hsAllSwap.rawValue) as! Int) ?? HSAllSwap.no
        hsUseNonMin  =  HSUseNonMin(rawValue: coder.decodeObject(forKey: CodingKeys.hsUseNonMin.rawValue) as! Int) ?? HSUseNonMin.no
        hsSteepest  =  HSSteepest(rawValue: coder.decodeObject(forKey: CodingKeys.hsSteepest.rawValue) as! Int) ?? HSSteepest.no
        hsRearrLimit  =  HSRearrLimit(rawValue: coder.decodeObject(forKey: CodingKeys.hsRearrLimit.rawValue) as! Int) ?? HSRearrLimit.none
        hsRearrLimitVal = coder.decodeInteger(forKey: CodingKeys.hsRearrLimitVal.rawValue)
        hsAbortRep  =  HSAbortRep(rawValue: coder.decodeObject(forKey: CodingKeys.hsAbortRep.rawValue) as! Int) ?? HSAbortRep.no
        hsRandomize  =  HSRandomize(rawValue: coder.decodeObject(forKey: CodingKeys.hsRandomize.rawValue) as! Int) ?? HSRandomize.addSeq
        hsAddSeq  =  HSAddSeq(rawValue: coder.decodeObject(forKey: CodingKeys.hsAddSeq.rawValue) as! Int) ?? HSAddSeq.simple
        hsHold  =  HSHold(rawValue: coder.decodeObject(forKey: CodingKeys.hsHold.rawValue) as! Int) ?? HSHold.integerValue
        hsHoldVal = coder.decodeInteger(forKey: CodingKeys.hsHoldVal.rawValue)
        hsNChuck  =  HSNChuck(rawValue: coder.decodeObject(forKey: CodingKeys.hsNChuck.rawValue) as! Int) ?? HSNChuck.integerValue
        hsNChuckVal = coder.decodeInteger(forKey: CodingKeys.hsNChuckVal.rawValue)
        hsChuckScore =  HSChuckScore(rawValue: coder.decodeObject(forKey: CodingKeys.hsChuckScore.rawValue) as! Int) ?? HSChuckScore.no
        hsChuckScoreVal = coder.decodeDouble(forKey: CodingKeys.hsChuckScoreVal.rawValue)
        hsNreps =  HSNreps(rawValue: coder.decodeObject(forKey: CodingKeys.hsNreps.rawValue) as! Int) ?? HSNreps.integerValue
        hsNrepsVal = coder.decodeInteger(forKey: CodingKeys.hsNrepsVal.rawValue)
        bbKeep =  BBKeep(rawValue: coder.decodeObject(forKey: CodingKeys.bbKeep.rawValue) as! Int) ?? BBKeep.no
        bbKeepVal = coder.decodeDouble(forKey: CodingKeys.bbKeep.rawValue)
        bbMulTrees =  BBMulTrees(rawValue: coder.decodeObject(forKey: CodingKeys.bbMulTrees.rawValue) as! Int) ?? BBMulTrees.yes
        bbUpBound =  BBUpBound(rawValue: coder.decodeObject(forKey: CodingKeys.bbUpBound.rawValue) as! Int) ?? BBUpBound.realValue
        bbUpBoundVal = coder.decodeDouble(forKey: CodingKeys.bbUpBoundVal.rawValue)
        bbAddSeq =  BBAddSeq(rawValue: coder.decodeObject(forKey: CodingKeys.bbAddSeq.rawValue) as! Int) ?? BBAddSeq.furthest
        exKeep =  EXKeep(rawValue: coder.decodeObject(forKey: CodingKeys.exKeep.rawValue) as! Int) ?? EXKeep.no
        exKeepVal = coder.decodeInteger(forKey: CodingKeys.exKeepVal.rawValue)
        lsNst = coder.decodeInteger(forKey: CodingKeys.lsNst.rawValue)
        lsTRatio =  LSTRatio(rawValue: coder.decodeObject(forKey: CodingKeys.lsTRatio.rawValue) as! Int) ?? LSTRatio.estimate
        lsTRatioVal = coder.decodeDouble(forKey: CodingKeys.lsTRatioVal.rawValue)
        lsRMatrix =  LSRMatrix(rawValue: coder.decodeObject(forKey: CodingKeys.lsRMatrix.rawValue) as! Int) ?? LSRMatrix.estimate
        lsRMatrixVal = coder.decodeObject(forKey: CodingKeys.lsRMatrixVal.rawValue) as! [Double]
        lsBasefreq  =  LSBasefreq(rawValue: coder.decodeObject(forKey: CodingKeys.lsBasefreq.rawValue) as! Int) ?? LSBasefreq.estimate
        lsBasefreqVal = coder.decodeObject(forKey: CodingKeys.lsBasefreqVal.rawValue) as! [Double]
        lsRates  =  LSRates(rawValue: coder.decodeObject(forKey: CodingKeys.lsRates.rawValue) as! Int) ?? LSRates.equal
        lsShape  =  LSShape(rawValue: coder.decodeObject(forKey: CodingKeys.lsShape.rawValue) as! Int) ?? LSShape.estimate
        lsShapeVal = coder.decodeDouble(forKey: CodingKeys.lsShapeVal.rawValue)
        lsNCat  =  LSNCat(rawValue: coder.decodeObject(forKey: CodingKeys.lsNCat.rawValue) as! Int) ?? LSNCat.integerValue
        lsNCatVal = coder.decodeInteger(forKey: CodingKeys.lsNCatVal.rawValue)
        lsReprate  =  LSReprate(rawValue: coder.decodeObject(forKey: CodingKeys.lsReprate.rawValue) as! Int) ?? LSReprate.mean
        lsPinvar  =  LSPinvar(rawValue: coder.decodeObject(forKey: CodingKeys.lsPinvar.rawValue) as! Int) ?? LSPinvar.estimate
        lsPinvarVal = coder.decodeDouble(forKey: CodingKeys.lsPinvarVal.rawValue)
        lsClock  =  LSClock(rawValue: coder.decodeObject(forKey: CodingKeys.lsClock.rawValue) as! Int) ?? LSClock.no
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
