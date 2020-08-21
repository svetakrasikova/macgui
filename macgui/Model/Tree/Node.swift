import Cocoa



class Node: NSObject {

    var descendants : [Node] = []
    var ancestor : Node? = nil
    var index : Int = 0
    var branchLength : Double = 0.0
    var name : String = ""
    
    // MARK: -

    override var description: String {

        var str: String = ""
        str += "Node\n"
        str += "   Name  = \"\(name)\"\n"
        str += "   Index = \"\(index)\"\n"
        str += "   Lengh = \(branchLength)\n"
        str += "   Anc = \(String(describing: ancestor?.index))\n"
        str += "   Des = ( "
        for d in descendants {
            str += "\(d.index) "
        }
        str += ")\n"
        return str
    }
    
    func passDown(node: Node?, tSeq: inout [Node]) {
        
        if let node = node {
            
            for d in node.descendants {
                passDown(node: d, tSeq: &tSeq)
            }
            tSeq.append(node)
        }
    }
    
    func passDown(node: Node?, tSeq: [Node]) -> [Node] {
        
        if let node = node {
            var updatedTSeq: [Node] = []
            for d in node.descendants {
                updatedTSeq += passDown(node: d, tSeq: tSeq)
            }
            updatedTSeq.append(node)
            return updatedTSeq
        }
        return tSeq
    }
    
    func show(node: Node?, indent: Int) {
    
        if let node = node {

            var str : String = ""
            for _ in 0...indent {
                str += " "
            }
            str += "\(node.index) -- "
            str += node.ancestor == nil ? "nil ( " : "\(node.ancestor!.index) ( "
 
            for d in node.descendants {
                str += "\(d.index) "
            }
            str += ") \"" + node.name + "\""
            
            for d in node.descendants {
                let idn = indent + 3
                show(node:d, indent:idn)
            }
        }
    }
}
