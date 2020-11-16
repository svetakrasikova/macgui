import Cocoa

@objcMembers
class PaupOptions: NSObject, NSCoding {
    

    // MARK: - Coding Keys

    private enum CodingKeys: String {
        
        case criterion
        case searchMethod
        
        case hsSwap
        case hsKeep
        case hsMulTrees
        case hsReconLimit
        case hsNBest
        case hsRetain
        case hsAllSwap
        case hsUseNonMin
        case hsSteepest
        case hsRearrLimit
        case hsAbortRep
        case hsNChuck
        case hsChuckScore
        case hsNreps
        case hsRandomize
        case hsAddSeq
        case hsHold

      
        case bbKeep
        case bbMulTrees
        case bbUpBound
        case bbAddSeq
        
        case exKeep

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
    
    enum Criteria     : Int, CaseIterable { case parsimony, distance, likelihood }
    enum SearchMethod : Int { case exhaustive, branchAndBound, heuristic }
    enum HSSwap       : Int { case none, nni, spr, tbr }
    enum HSKeep       : String { case no }
    enum HSMulTrees   : Int { case no, yes }
    enum HSRearrLimit : String { case none }
    enum HSReconLimit : String { case infinity, defaultValue = "8" }
    enum HSNBest      : String { case all }
    enum HSRetain     : Int { case no, yes }
    enum HSAllSwap    : Int { case no, yes }
    enum HSUseNonMin  : Int { case no, yes }
    enum HSSteepest   : Int { case no, yes }
    enum HSAbortRep   : Int { case no, yes }
    enum HSChuckScore : String { case no }
    enum HSNChuck     : String { case defaultValue = "0" }
    enum HSNreps      : String { case defaultValue = "10" }
    enum HSRandomize  : Int { case addSeq, trees }
    enum HSAddSeq     : Int { case simple, closest, asIs, random, furthest }
    enum HSHold       : String { case defaultValue = "1" }

   
    enum BBKeep       : String { case no }
    enum BBMulTrees   : Int { case no, yes }
    enum BBUpBound    : String { case defaultValue = "0.0"}
    enum BBAddSeq     : Int { case furthest, asIs, simple, maxMini, kMaxMini }
    
    enum EXKeep       : String { case no }
    
    enum LSNst        : String { case one="1", two="2", six="6" }
    enum LSTRatio     : String { case estimate }
    enum LSRMatrix    : String { case estimate }
    enum LSBasefreq   : Int { case empirical, equal, estimate, vectorValues }
    enum LSRates      : Int { case equal, gamma }
    enum LSShape      : String { case estimate }
    enum LSNCat       : String { case defaultValue = "4"}
    enum LSReprate    : Int { case mean, median }
    enum LSPinvar     : String { case estimate }
    enum LSClock      : Int { case no, yes }
    
    class func getCriteria() -> [String] {
        var criteria: [String] = []
        for c in PaupOptions.Criteria.allCases {
            let caseAsString = String(describing: PaupOptions.Criteria(rawValue: c.rawValue)!)
            criteria.append(caseAsString)
        }
        return criteria
    }

    // MARK: - PAUP* Command Variables

    var criterion       = Criteria.parsimony.rawValue
    var searchMethod    = SearchMethod.heuristic.rawValue
    var hsSwap          = HSSwap.tbr.rawValue
    var hsKeep          = HSKeep.no.rawValue
    var hsMulTrees      = HSMulTrees.yes.rawValue
    var hsRearrLimit    = HSRearrLimit.none.rawValue
    var hsReconLimit    = HSReconLimit.defaultValue.rawValue
    var hsNBest         = HSNBest.all.rawValue
    var hsRetain        = HSRetain.no.rawValue
    var hsAllSwap       = HSAllSwap.no.rawValue
    var hsUseNonMin     = HSUseNonMin.no.rawValue
    var hsSteepest      = HSSteepest.no.rawValue
    var hsAbortRep      = HSAbortRep.no.rawValue
    var hsRandomize     = HSRandomize.addSeq.rawValue
    var hsAddSeq        = HSAddSeq.simple.rawValue
    var hsHold          = HSHold.defaultValue.rawValue
    var hsNChuck        = HSNChuck.defaultValue.rawValue
    var hsChuckScore    = HSChuckScore.no.rawValue
    var hsNreps         = HSNreps.defaultValue.rawValue

    var bbKeep          = BBKeep.no.rawValue
    var bbMulTrees      = BBMulTrees.yes.rawValue
    var bbUpBound       = BBUpBound.defaultValue.rawValue
    var bbAddSeq        = BBAddSeq.furthest.rawValue
    
    
    var exKeep          = EXKeep.no.rawValue
    
    var lsNst           = LSNst.two.rawValue
    var lsTRatio        = LSTRatio.estimate.rawValue
    var lsRMatrix       = LSRMatrix.estimate.rawValue
    var lsBasefreq      = LSBasefreq.estimate.rawValue
    var lsRates         = LSRates.equal.rawValue
    var lsShape         = LSShape.estimate.rawValue
    var lsNCat          = LSNCat.defaultValue.rawValue
    var lsReprate       = LSReprate.mean.rawValue
    var lsPinvar        = LSPinvar.estimate.rawValue
    var lsClock         = LSClock.no.rawValue

    override init() {
        super.init()
    }
    
//    MARK: -- NSCoding
    
    func encode(with coder: NSCoder) {
        
        coder.encode(criterion, forKey: CodingKeys.criterion.rawValue)
        coder.encode(searchMethod, forKey: CodingKeys.searchMethod.rawValue)
        coder.encode(hsSwap, forKey: CodingKeys.hsSwap.rawValue)
        coder.encode(hsKeep, forKey: CodingKeys.hsKeep.rawValue)
        coder.encode(hsMulTrees, forKey: CodingKeys.hsMulTrees.rawValue)
        coder.encode(hsRearrLimit, forKey: CodingKeys.hsRearrLimit.rawValue)
        coder.encode(hsReconLimit, forKey: CodingKeys.hsReconLimit.rawValue)
        coder.encode(hsNBest, forKey: CodingKeys.hsNBest.rawValue)
        coder.encode(hsRetain, forKey: CodingKeys.hsRetain.rawValue)
        coder.encode(hsAllSwap, forKey: CodingKeys.hsAllSwap.rawValue)
        coder.encode(hsUseNonMin, forKey: CodingKeys.hsUseNonMin.rawValue)
        coder.encode(hsSteepest, forKey: CodingKeys.hsSteepest.rawValue)
        coder.encode(hsAbortRep, forKey: CodingKeys.hsAbortRep.rawValue)
        coder.encode(hsRandomize, forKey: CodingKeys.hsRandomize.rawValue)
        coder.encode(hsAddSeq, forKey: CodingKeys.hsAddSeq.rawValue)
        coder.encode(hsHold, forKey: CodingKeys.hsHold.rawValue)
        coder.encode(hsNChuck, forKey: CodingKeys.hsNChuck.rawValue)
        coder.encode(hsChuckScore, forKey: CodingKeys.hsChuckScore.rawValue)
        coder.encode(hsNreps, forKey: CodingKeys.hsNreps.rawValue)
        
        
        coder.encode(bbKeep, forKey: CodingKeys.bbKeep.rawValue)
        coder.encode(bbMulTrees, forKey: CodingKeys.bbMulTrees.rawValue)
        coder.encode(bbUpBound, forKey: CodingKeys.bbUpBound.rawValue)
        coder.encode(bbAddSeq, forKey: CodingKeys.bbAddSeq.rawValue)
        
        coder.encode(exKeep, forKey: CodingKeys.exKeep.rawValue)

        coder.encode(lsNst, forKey: CodingKeys.lsNst.rawValue)
        coder.encode(lsTRatio, forKey: CodingKeys.lsTRatio.rawValue)
        coder.encode(lsRMatrix, forKey: CodingKeys.lsRMatrix.rawValue)
        coder.encode(lsBasefreq, forKey: CodingKeys.lsBasefreq.rawValue)
        coder.encode(lsRates, forKey: CodingKeys.lsRates.rawValue)
        coder.encode(lsShape, forKey: CodingKeys.lsShape.rawValue)
        coder.encode(lsNCat, forKey: CodingKeys.lsNCat.rawValue)
        coder.encode(lsReprate, forKey: CodingKeys.lsReprate.rawValue)
        coder.encode(lsPinvar, forKey: CodingKeys.lsPinvarVal.rawValue)
        coder.encode(lsClock, forKey: CodingKeys.lsClock.rawValue)
    }
       
    required init?(coder: NSCoder) {
        
        criterion =  coder.decodeInteger(forKey: CodingKeys.criterion.rawValue)
        searchMethod =  coder.decodeInteger(forKey: CodingKeys.searchMethod.rawValue)
        hsSwap =  coder.decodeInteger(forKey: CodingKeys.hsSwap.rawValue)
        hsKeep =  coder.decodeObject(forKey: CodingKeys.hsKeep.rawValue) as? String ?? HSKeep.no.rawValue
        hsMulTrees =  coder.decodeInteger(forKey: CodingKeys.hsMulTrees.rawValue)
        hsRearrLimit  =  coder.decodeObject(forKey: CodingKeys.hsRearrLimit.rawValue) as? String ?? HSRearrLimit.none.rawValue
        hsReconLimit = coder.decodeObject(forKey: CodingKeys.hsReconLimit.rawValue) as? String ?? HSReconLimit.defaultValue.rawValue
        hsNBest  =  coder.decodeObject(forKey: CodingKeys.hsNBest.rawValue) as? String ?? HSNBest.all.rawValue
        hsRetain  =  coder.decodeInteger(forKey: CodingKeys.hsRetain.rawValue)
        hsAllSwap  =  coder.decodeInteger(forKey: CodingKeys.hsAllSwap.rawValue)
        hsUseNonMin  =  coder.decodeInteger(forKey: CodingKeys.hsUseNonMin.rawValue)
        hsSteepest  =  coder.decodeInteger(forKey: CodingKeys.hsSteepest.rawValue)
        hsAbortRep  =  coder.decodeInteger(forKey: CodingKeys.hsAbortRep.rawValue)
        hsRandomize  =  coder.decodeInteger(forKey: CodingKeys.hsRandomize.rawValue)
        hsAddSeq  =  coder.decodeInteger(forKey: CodingKeys.hsAddSeq.rawValue)
        hsHold  =  coder.decodeObject(forKey: CodingKeys.hsHold.rawValue) as? String ?? HSHold.defaultValue.rawValue
        hsNChuck  =  coder.decodeObject(forKey: CodingKeys.hsNChuck.rawValue) as? String ?? HSNChuck.defaultValue.rawValue
        hsChuckScore =  coder.decodeObject(forKey: CodingKeys.hsChuckScore.rawValue) as? String  ?? HSChuckScore.no.rawValue
        hsNreps =  coder.decodeObject(forKey: CodingKeys.hsNreps.rawValue) as? String ?? HSNreps.defaultValue.rawValue
        
        bbKeep =  coder.decodeObject(forKey: CodingKeys.bbKeep.rawValue) as? String ?? BBKeep.no.rawValue
        bbMulTrees =  coder.decodeInteger(forKey: CodingKeys.bbMulTrees.rawValue)
        bbUpBound =   coder.decodeObject(forKey: CodingKeys.bbUpBound.rawValue) as? String ?? BBUpBound.defaultValue.rawValue
        bbAddSeq =  coder.decodeInteger(forKey: CodingKeys.bbAddSeq.rawValue)
        
        exKeep =  coder.decodeObject(forKey: CodingKeys.exKeep.rawValue) as? String ?? EXKeep.no.rawValue
      
        lsNst = coder.decodeObject(forKey: CodingKeys.lsNst.rawValue) as? String ?? LSNst.two.rawValue
        lsTRatio =  coder.decodeObject(forKey: CodingKeys.lsTRatio.rawValue) as? String ?? LSTRatio.estimate.rawValue
        lsRMatrix =  coder.decodeObject(forKey: CodingKeys.lsRMatrix.rawValue) as? String ?? LSRMatrix.estimate.rawValue
        lsBasefreq  =  coder.decodeInteger(forKey: CodingKeys.lsBasefreq.rawValue)
        lsRates  =  coder.decodeInteger(forKey: CodingKeys.lsRates.rawValue)
        lsShape  = coder.decodeObject(forKey: CodingKeys.lsShape.rawValue) as? String ?? LSShape.estimate.rawValue
        lsNCat  =  coder.decodeObject(forKey: CodingKeys.lsNCat.rawValue) as? String ?? LSNCat.defaultValue.rawValue
        lsReprate  = coder.decodeInteger(forKey: CodingKeys.lsReprate.rawValue)
        lsPinvar  =  coder.decodeObject(forKey: CodingKeys.lsPinvar.rawValue) as? String ?? LSPinvar.estimate.rawValue
        lsClock  =  coder.decodeInteger(forKey: CodingKeys.lsClock.rawValue)
        
    }

    func revertToFactorySettings() {
        
        criterion       = Criteria.parsimony.rawValue
        searchMethod    = SearchMethod.heuristic.rawValue
        hsSwap          = HSSwap.tbr.rawValue
        hsKeep          = HSKeep.no.rawValue
        hsMulTrees      = HSMulTrees.yes.rawValue
        hsRearrLimit    = HSRearrLimit.none.rawValue
        hsReconLimit    = HSReconLimit.defaultValue.rawValue
        hsNBest         = HSNBest.all.rawValue
        hsRetain        = HSRetain.no.rawValue
        hsAllSwap       = HSAllSwap.no.rawValue
        hsUseNonMin     = HSUseNonMin.no.rawValue
        hsSteepest      = HSSteepest.no.rawValue
        hsAbortRep      = HSAbortRep.no.rawValue
        hsRandomize     = HSRandomize.addSeq.rawValue
        hsAddSeq        = HSAddSeq.simple.rawValue
        hsHold          = HSHold.defaultValue.rawValue
        hsNChuck        = HSNChuck.defaultValue.rawValue
        hsChuckScore    = HSChuckScore.no.rawValue
        hsNreps         = HSNreps.defaultValue.rawValue
        
        bbKeep          = BBKeep.no.rawValue
        bbMulTrees      = BBMulTrees.yes.rawValue
        bbUpBound       = BBUpBound.defaultValue.rawValue
        bbAddSeq        = BBAddSeq.furthest.rawValue
        
        exKeep          = EXKeep.no.rawValue
        
        lsNst           = LSNst.two.rawValue
        lsTRatio        = LSTRatio.estimate.rawValue
        lsRMatrix       = LSRMatrix.estimate.rawValue
        lsBasefreq      = LSBasefreq.estimate.rawValue
        lsRates         = LSRates.equal.rawValue
        lsShape         = LSShape.estimate.rawValue
        lsNCat          = LSNCat.defaultValue.rawValue
        lsReprate       = LSReprate.mean.rawValue
        lsPinvar        = LSPinvar.estimate.rawValue
        lsClock         = LSClock.no.rawValue
    }
    
    func setString() -> String {
    
        var str : String = "set AutoClose=yes WarnReset=no Increase=auto NotifyBeep=no ErrorBeep=no WarnTSave=no"
        str += " Criterion=\(String(describing: Criteria(rawValue: criterion)!));"
        return str
    }
    
    func methodsAssumptionsString() -> String {
    
        var str : String = ""
        if criterion == Criteria.likelihood.rawValue {
            str += lsetString()
        } else if criterion == Criteria.distance.rawValue {
            str += dsetString()
        } else {
            str += psetString()
        }
        return str
    }

 
    func dsetString() -> String {
    
        let str : String = "dset;"
        return str
    }

    func lsetString() -> String {
    
        var str : String = "lset"
        str += " Nst=\(lsNst)"
        str += " TRatio=\(String(describing: lsTRatio))"
        str += " RMatrix=\(lsRMatrix)"
        str += " Basefreq=\(String(describing: LSBasefreq(rawValue: lsBasefreq)!))"
        str += " Rates=\(String(describing: LSRates(rawValue: lsRates)!))"
        str += " Shape=\(lsShape)"
        str += " Ncat=\(lsNCat)"
        str += " Reprate=\(String(describing: LSReprate(rawValue: lsReprate)!))"
        str += " Pinvar=\(lsPinvar)"
        str += " Clock=\(String(describing: LSClock(rawValue: lsClock)!))"
        str += ";"
        return str
        
    }

    func psetString() -> String {
    
        let str : String = "pset;"
        return str
    }

    func searchMethodString() -> String {
    
        var str : String = ""
        
        if searchMethod == SearchMethod.exhaustive.rawValue {
        
            str += "Alltrees"
            str +=  " Keep=\(exKeep)"
            str += ";"
        
        } else if searchMethod == SearchMethod.branchAndBound.rawValue {
        
            str += "Bandb"
            str += " Keep=\(bbKeep)"
            str += " Multrees=\(String(describing: BBMulTrees(rawValue: bbMulTrees)!))"
            str += " Addseq=\(String(describing: BBAddSeq(rawValue: bbAddSeq)!))"
            str += " Upbound=\(bbUpBound)"
            str += ";"
            
        } else {
        
            str += "Hsearch"
            str += " Keep=\(hsKeep)"
            str += " Swap=\(String(describing: HSSwap(rawValue: hsSwap)!))"
            str += " Multrees=\(String(describing: HSMulTrees(rawValue: hsMulTrees)!))"
            str += " RearrLimit=\(hsRearrLimit)"
            str += " ReconLimit=\(hsReconLimit)"
            str += " NBest=\(hsNBest)"
            str += " Retain=\(String(describing: HSRetain(rawValue: hsRetain)!))"
            str += " AllSwap=\(String(describing: HSAllSwap(rawValue: hsAllSwap)!))"
            str += " UseNonMin=\(String(describing: HSUseNonMin(rawValue: hsUseNonMin)!))"
            str += " Steepest=\(String(describing: HSSteepest(rawValue: hsSteepest)!))"
            str += " NChuck=\(hsNChuck)"
            str += " ChuckScore=\(hsChuckScore)"
            str += " AbortRep=\(String(describing: HSAbortRep(rawValue: hsAbortRep)!))"
            str += " NReps=\(hsNreps)"
            str += " Randomize=\(String(describing: HSRandomize(rawValue: hsRandomize)!))"
            str += " AddSeq=\(String(describing: HSAddSeq(rawValue: hsAddSeq)!))"
            str += " Hold=\(String(describing: hsHold))"
            str += ";"
        }
        
        return str
    }
}
