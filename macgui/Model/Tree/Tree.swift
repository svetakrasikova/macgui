import Cocoa


class Tree: NSObject {

    var nodes : [Node] = []
    var root : Node? = nil
    var tSequence : [Node] {
        return root?.passDown(node: root, tSeq: []) ?? []

    }

     enum TreeError: Error {
     
         case badNewickString
    }

    init(newickString: String) throws {
        
        super.init()
        
        
        do {
            
            let newick = try NewickString(nStr: newickString)
            treeFromNewick(newickTokens: newick.newickTokens)
            
        } catch {
            throw TreeError.badNewickString
        }
        
        
    }
    
    override var description: String {

        var str: String = ""
        str += "Tree\n"
        str += "   Number of nodes = \(nodes.count)\n"
        str += "   Root = \(String(describing: root?.index))\n"
        str += "   Postorder = ( "
        for n in tSequence {
            str += "\(String(describing: n.index)) "
        }
        str += ")\n"
        
        return str
    }
    
    func showTree() {
        
        root?.show(node: root!, indent: 0)
    }
    
    func treeFromNewick(newickTokens: [String]) {

        var p : Node? = nil
        var readingBrlen : Bool = false
        var idx : Int = 0
        for token in newickTokens {
        
            if token == "(" {
                if nodes.count == 0 {
                    p = Node()
                    p?.index = idx
                    idx += 1
                    root = p
                    nodes.append(p!)
                } else {
                    let q = Node()
                    q.index = idx
                    idx += 1
                    nodes.append(q)
                    q.ancestor = p
                    p?.descendants.append(q)
                    p = q
                }
                readingBrlen = false
            } else if token == ")" {
                p = p?.ancestor
                readingBrlen = false
            } else if token == "," {
                p = p?.ancestor
                readingBrlen = false
            } else if token == ":" {
                readingBrlen = true
            } else if token == ";" {
            
            } else {
                if readingBrlen == false {
                    let q = Node()
                    q.index = idx
                    idx += 1
                    q.name = String(token)
                    nodes.append(q)
                    q.ancestor = p
                    p?.descendants.append(q)
                    p = q
                } else {
                    p?.branchLength = Double(token)!
                    readingBrlen = false
                }
            }
        }

    }

}
