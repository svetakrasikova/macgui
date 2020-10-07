import Cocoa



class NewickString: NSObject {

    var newickString : String = ""
    
    var newickTokens : [String] {
        return tokenizeNewickString()
    }

     enum NewickError: Error {
     
        case badNewickStringError
        case fileParsingError
    }

    override init() {
    
        super.init()
    }
    
    init(nStr: String) throws {
        
        super.init()
        
        newickString = nStr
        
        if check() == false {
            print("Error: Improperly formatted Newick string")
            throw NewickError.badNewickStringError
        }
        
    }
    
    override var description: String {

        var str: String = ""
        str += "Newick String\n"
        str += "   String  = \"\(newickString)\"\n"
        str += "   Tokens = \"\(newickTokens)\"\n"
        return str
    }
    
    func check() -> Bool {

        var numLeft : Int = 0
        var numRight : Int = 0
        var foundSemicolon : Bool = false
        
        for char in newickString {
            
            switch char {
            case "(":
                numLeft += 1
            case ")":
                numRight += 1
            case ";":
                if foundSemicolon == true {
                    return false
                }
                foundSemicolon = true
            default:
                continue
            }
        }
        
        if numLeft != numRight {
            return false
        }
        
        if foundSemicolon == false {
            return false
        }
        
        return true
    }
    
    
    
    func tokenizeNewickString() -> [String] {
        
        var newickTokens: [String] = []
        var str : String = ""
        for char in newickString {
            if char == "(" || char == ")" || char == "," || char == ":" || char == ";" {
                if str.count > 0 {
                    newickTokens.append(str)
                    str = ""
                }
                newickTokens.append(String(char))
            } else {
                str.append(String(char))
            }
        }
        return newickTokens
    }
    
    func parseNexus(_ nexusString: String) -> String? {
        var trees: String?
        let lines = nexusString.split(separator: "\n")
        let treeLines = lines.filter {$0.hasPrefix("tree") }
        if !treeLines.isEmpty {
            trees = treeLines.joined()
        }
        return trees
    }
    
    func parseNewickStrings(fileURL: URL) throws -> [String] {
    
        var s : String?
        do {
            let d = try Data(contentsOf:fileURL)
            s = String(data:d, encoding: .utf8)
            s = parseNexus(s ?? "")
        } catch {
            throw NewickError.fileParsingError
        }
        
        var newickStrings : [String] = []
        var readingNewick : Bool = false
        var nStr : String = ""
        for char in s! {
        
            if char == "(" {
                readingNewick = true
            }
            
            if readingNewick == true {
                nStr.append(String(char))
            }
            
            if char == ";" {
                readingNewick = false
                newickString = nStr
                print(nStr)
                nStr = ""
                if check() == false {
                     print("Error: Improperly formatted Newick string")
                }
                else {
                    newickStrings.append(newickString)
                }
            }
        }

        return newickStrings
    }
}
