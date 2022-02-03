import Cocoa


class Tree: NSObject, NSCoding {
    
    var root: Node
    var tSequence : [Node] {
        return root.passDown()
    }
    
    enum TreeError: Error {
        
        case badNewickString
        case unaryBranch
    }
    
    var numberOfTaxa: Int {
        (self.tSequence.filter { $0.isLeaf }).count
    }
    
    var nodeCoordinates: [NSPoint] = []
    
    
    enum Key: String {
        case root, nodeCoordinates
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(root, forKey: Key.root.rawValue)
        coder.encode(nodeCoordinates, forKey: Key.nodeCoordinates.rawValue)
    }
    
    required init?(coder: NSCoder) {
        root = coder.decodeObject(forKey: Key.root.rawValue) as! Node
        nodeCoordinates = coder.decodeObject(forKey: Key.nodeCoordinates.rawValue) as? [NSPoint] ?? []
    }
    
    init(root: Node) {
        self.root = root
    }
    
    
    //    MARK: - Coordinates
    
    func setCoordinates() {
        
        guard !tSequence.isEmpty else { return }
        
        for node in tSequence {
            if node.isLeaf {
                node.depthFromTip = 0
            } else {
                let maxDepth = (node.descendants.map {($0.depthFromTip)}).max()
                node.depthFromTip = (maxDepth ?? 0) + 1
            }
            
        }
        
        let depthOfRoot = root.depthFromTip
        
        
        for node in tSequence {
            node.point.y = 1.0 - (CGFloat(node.depthFromTip)/CGFloat(depthOfRoot))
        }
        
        var x: CGFloat = 0.0
        var maximumX: CGFloat = 0.0
        var maximumY: CGFloat = 0.0
        
        for node in tSequence {
            
            if node.isLeaf {
                node.point.x = x
                x += 1.0
                let depth = CGFloat(node.getDepth())
                if depth > maximumY { maximumY = depth }
                
            } else {
                
                var xMin: CGFloat = 1000000000.0;
                var xMax: CGFloat = 0.0;
                
                for d in node.descendants {
//                    if i == 0, node === root, drawMonophyleticWrOutgroup {
//                        continue
//                    }
                    if d.point.x < xMin { xMin = d.point.x }
                    else if d.point.x > xMax { xMax = d.point.x }
                    
                }
                
                node.point.x = xMin + (xMax - xMin)*0.5
            }
            
            if node.x  > maximumX {
                maximumX = node.x
            }
        }
        
        for node in tSequence {
            node.point.x = node.point.x/maximumX
            let point: NSPoint = NSPoint(x: node.point.x, y: node.point.y)
            self.nodeCoordinates.append(point)
        }
        
    }
    
    //    MARK: - Tree from Newick String
    
    init(newickString: String) throws {
        
        do {
            let newick = try NewickString(nStr: newickString)
            self.root = Tree.treeFromNewick(newickTokens: newick.newickTokens)
            
        } catch {
            throw TreeError.badNewickString
        }
        
        super.init()
    }
    
    class func treeFromNewick(newickTokens: [String]) -> Node {
        var firstNode = true
        var root = Node()
        var p : Node? = nil
        var readingBrlen : Bool = false
        var idx : Int = 0
        for token in newickTokens {
            if token == "(" {
                if firstNode {
                    p = Node()
                    p?.index = idx
                    idx += 1
                    root = p!
                    firstNode = false
                } else {
                    let q = Node()
                    q.index = idx
                    idx += 1
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
                    q.ancestor = p
                    p?.descendants.append(q)
                    p = q
                } else {
                    p?.branchLength = Double(token)!
                    readingBrlen = false
                }
            }
        }
        return root
    }
    
    
//    MARK: - Printing Tree
    
    override var description: String {
        
        let nodes = tSequence
        var str: String = ""
        str += "Tree\n"
        str += "   Number of nodes = \(nodes.count)\n"
        str += "   Root = \(String(describing: root.index))\n"
        str += "   Postorder = ( "
        for n in tSequence {
            str += "\(String(describing: n.index)) "
        }
        str += ")\n"
        for n in nodes {
            print(n)
        }
        return str
    }
    
    func showTree() {
        root.show(node: root, indent: 0)
    }
    
//    MARK: - Rooting Tree
    
/**
      Creates a copy of the tree  with the birfurcating (binary) root, using the outgroup method.
     - Parameter taxon: The name of the leaf node to serve as the outgroup
     - Returns: A tree identical to the input tree with the possible exception of the root node that is obligatorily binary branching.
     - Remark: If the input tree is binary at the root, its copy is returned.
     
     */
    
    func rootWithOutgroup(_ taxon: String) throws -> Tree {
        
        guard self.root.descendants.count > 2 else { return self }
        
        let outgroup = Node()
        outgroup.name = taxon
        let newRoot = Node()
        newRoot.descendants = [outgroup]
        
        if let ingroup = try! root.removeLeafWith(taxonName: taxon) {
            newRoot.descendants.append(contentsOf: ingroup.passDown())
        }
        
        return Tree(root: newRoot)
    }
    
    class func numBranches(numLeaves: Int, rooted: Bool) -> Int {
        return rooted ? 2*numLeaves-2 : 2*numLeaves-3
    }
    
}
