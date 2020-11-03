/**
 
An object that holds a string representation of a tree in Newick format.
 
 */

import Cocoa

class NewickString: NSObject {


    var newickString: String
    
    var newickTokens: [String] {
        return tokenizeNewickString()
    }

     enum NewickError: Error {
     
        case badNewickStringError
        case fileParsingError
    }

    override init() {
        newickString = ""
        super.init()
    }
    
    init(nStr: String) throws {
        
         let inputString = nStr.filter { !$0.isWhitespace }

        if NewickString.check(inputString) == false {
            print("Error: Improperly formatted Newick string")
            throw NewickError.badNewickStringError
        }
        
        self.newickString = inputString
        
        super.init()
        
    }
    
    override var description: String {

        var str: String = ""
        str += "Newick String\n"
        str += "   String  = \"\(newickString)\"\n"
        str += "   Tokens = \"\(newickTokens)\"\n"
        return str
    }
    
/**
     
     Checks the syntax. Three conditions need to be met for a string to be well-formed:
     
     * Surrounded by outer parentheses
     * Parentheses are balanced
     * Ends with a semicolon
    
*/
    class func check(_ newickString: String) -> Bool {
        
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
    
    /**
        Keeps the lines from a nexus formated file that begin with *tree*.
     */
    
    class func parseNexus(_ nexusString: String) -> String? {
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
    
    /**
        Reads a nexus formated file and returns a list of Newick formatted strings.
     
     - Parameter fileURL: The url for the input file.
     - Returns: An array of properly formatted Newick strings.
     - Throws: An error if the contents of the file is not accessible to intialize a `Data` object.
     
     */
    
    class func parseNewickStrings(fileURL: URL) throws -> [String] {
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
                        let newickString = nStr
                        nStr = ""
                        if NewickString.check(newickString) == false {
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
