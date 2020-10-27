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
        
        newickString = nStr.filter { !$0.isWhitespace }
        
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
    
    func simpleCheck() -> Bool {

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
    
    func check() -> Bool {
        
        var isSurroundedByParen = false
        var stack: [Int] = []
        let lastIndex = newickString.count-1
        
        for (index,char) in newickString.enumerated() {
            
            switch char {
            case "(":
                stack.append(index)
                isSurroundedByParen = false
            case ")":
                guard let top = stack.popLast() else {
                    return false
                }
                isSurroundedByParen = (top == 0)
            case ";":
                return isSurroundedByParen && index == lastIndex
            default:
                isSurroundedByParen = false
                break
            }
        }
        
        return false
        
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
        var linesWithoutSpace: [String] = []
        for line in lines {
            linesWithoutSpace.append(line.filter { !$0.isWhitespace })
        }
        let treeLines = linesWithoutSpace.filter {$0.hasPrefix("tree") }
        if !treeLines.isEmpty {
            trees = treeLines.joined()
        }
        return trees
    }
    
    func parseNewickStrings(fileURL: URL) throws -> [String] {
        var newickStrings : [String] = []
        do {
            let d = try Data(contentsOf:fileURL)
            if let dataToString = String(data:d, encoding: .utf8), let parsedString = parseNexus(dataToString) {
                
                var readingNewick : Bool = false
                var nStr : String = ""
                for char in parsedString {
                    
                    if char == "(" {
                        readingNewick = true
                    }
                    
                    if readingNewick == true {
                        nStr.append(String(char))
                    }
                    
                    if char == ";" {
                        readingNewick = false
                        newickString = nStr
                        nStr = ""
                        if check() == false {
                            print("Error: Improperly formatted Newick string")
                        }
                        else {
                            newickStrings.append(newickString)
                        }
                    }
                }
            }
            
            
        } catch {
            throw NewickError.fileParsingError
        }
        
        return newickStrings
    }

}
