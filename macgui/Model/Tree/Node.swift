import Cocoa


/**
 An object that models a node of an evolutionary tree. It has an optional ancestor and zero, or two and more children. The name property is otional. It holds the taxon name for leaf nodes.
 */

class Node: NSObject, NSCoding {
    
    
    var descendants: [Node] = []
    var ancestor: Node?
    var index: Int = 0
    var branchLength: Double = 0.0
    var name: String = ""
    var depthFromTip: Int = 0
    
    var isLeaf: Bool {
        return descendants.isEmpty
    }
    
    var isRoot: Bool {
        return ancestor == nil
    }
    
    var x: CGFloat {
        point.x
    }
    
    var y: CGFloat {
        point.y
    }
    
    /// The coordinates of the node for displaying in UI
    
    var point: NSPoint = NSPoint(x: 0.0, y: 0.0)
    
    
    enum Key: String {
        case descendants, ancestor, index, branchLength, name, depthFromTip, x, y, point
    }
    
    override init() {
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(descendants, forKey: Key.descendants.rawValue)
        if let ancestor = self.ancestor {
            coder.encode(ancestor, forKey: Key.ancestor.rawValue)
        }
        coder.encode(index, forKey: Key.index.rawValue)
        coder.encode(branchLength, forKey: Key.branchLength.rawValue)
        coder.encode(name, forKey: Key.name.rawValue)
        coder.encode(point, forKey: Key.point.rawValue)
        coder.encode(depthFromTip, forKey: Key.depthFromTip.rawValue)
        
    }
    
    required init?(coder: NSCoder) {
        descendants = coder.decodeObject(forKey: Key.descendants.rawValue) as? [Node] ?? []
        ancestor = coder.decodeObject(forKey: Key.ancestor.rawValue) as? Node
        index = coder.decodeInteger(forKey: Key.index.rawValue)
        branchLength = coder.decodeDouble(forKey: Key.branchLength.rawValue)
        name = coder.decodeObject(forKey: Key.name.rawValue) as? String ?? ""
        point = coder.decodePoint(forKey: Key.name.rawValue)
        depthFromTip = coder.decodeInteger(forKey: Key.depthFromTip.rawValue)
    }
    
    func getDepth() -> Int {
        var depth = 1
        if let ancestor = self.ancestor {
            depth += ancestor.getDepth()
        } else {
            return depth
        }
        return depth
    }
    
    
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
    
    /**
     Perfroms a depth first traversal of the tree rooted at the given node.
     
     - Returns: an array of all descendant and self, in the post-order
     
     */
    func passDown() -> [Node] {
        var tSeq: [Node] = []
        for d in descendants {
            tSeq += d.passDown()
        }
        tSeq.append(self)
        return tSeq
    }
    
    /**
    Traverses the tree rooted at the given node recursively and creates a copy of the node with the given leaf removed.
     
     - Parameter taxonName: the name of the leaf to be removed
     - Returns: A copy of the node with the leaf node removed; nil if the node is the leaf to be removed
        
     */
    
    func removeLeafWith(taxonName: String) throws -> Node? {
        
        let newNode: Node = self
        
        switch newNode.descendants.count {
        case 0:
            if newNode.name == taxonName { return nil }
            else { return newNode }
        case 1:
            throw Tree.TreeError.unaryBranch
        default:
            for (index, node) in newNode.descendants.enumerated() {
                if node.name == taxonName {
                    newNode.descendants.remove(at: index)
                    if newNode.descendants.count == 1 {
                        let leaf = newNode.descendants.first!
                        leaf.ancestor = newNode.ancestor
                        return leaf
                    }
                }
                else if node.descendants.count > 0 {
                    if let replaceNode = try node.removeLeafWith(taxonName: taxonName) {
                        newNode.descendants[index] = replaceNode
                    }
                }
            }
        }
        return newNode
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
