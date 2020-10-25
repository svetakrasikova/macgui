import Cocoa


class Tree: NSObject, NSCoding {
    

    var nodes: [Node] = []
    var root: Node?
    
    
    var tSequence: [Node] {
        return root?.passDown(node: root, tSeq: []) ?? []

    }
    
    var numberOfTaxa: Int {
        (self.nodes.filter { $0.isLeaf }).count
    }
    
    var nodeCoordinates: [NSPoint] = []

     enum TreeError: Error {
     
         case badNewickString
    }
    
    enum Key: String {
        case nodes, root, nodeCoordinates
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(nodes, forKey: Key.nodes.rawValue)
        coder.encode(root, forKey: Key.root.rawValue)
        coder.encode(nodeCoordinates, forKey: Key.nodeCoordinates.rawValue)
    }
    
    required init?(coder: NSCoder) {
        nodes = coder.decodeObject(forKey: Key.nodes.rawValue) as? [Node] ?? []
        root = coder.decodeObject(forKey: Key.nodes.rawValue) as? Node
        nodeCoordinates = coder.decodeObject(forKey: Key.nodeCoordinates.rawValue) as? [NSPoint] ?? []
    }
    
    init(root: Node, nodes: [Node]) {
        self.root = root
        self.nodes = nodes
    }
    
    func rooted() -> Tree {
        
        if root == nil {
            var rootedTreeNodes: [Node] = []
            var root: Node = Node()
            rootedTreeNodes.append(root)
            
            let nodesWithoutAncestor: [Node] = self.nodes.filter { $0.ancestor == nil }
            let nodesWithAncestor: [Node] = self.nodes.filter { $0.ancestor != nil }
            if nodesWithoutAncestor.count == 1 {
                root = nodesWithoutAncestor.first!
                rootedTreeNodes.append(contentsOf: nodesWithAncestor)
            } else {
                var outgroup: Node = Node()
                let ingroup: Node = Node()
                ingroup.ancestor = root
                outgroup.ancestor = root
                var addedOutgroup = false
                for node in self.nodes {
                    rootedTreeNodes.append(node)
                    if node.ancestor == nil, !addedOutgroup{
                        outgroup = node
                        root.descendants.append(outgroup)
                        addedOutgroup = true
                        
                    } else if node.ancestor == nil {
                        ingroup.descendants.append(node)
                    }
                }
                root.descendants.append(ingroup)
                rootedTreeNodes.append(ingroup)
            }
            return Tree(root: root, nodes: rootedTreeNodes)
            
        } else { return self }
    }
    
//    MARK: - Coordinates
    
    func setCoordinates(drawMonophyleticWrOutgroup: Bool) {
        
        guard !tSequence.isEmpty else { return }
        
        for node in tSequence {
            if node.isLeaf {
                node.depthFromTip = 0
            } else {
                let maxDepth = (node.descendants.map {($0.depthFromTip)}).max()
                node.depthFromTip = (maxDepth ?? 0) + 1
            }
            
        }
        guard var depthOfRoot = root?.depthFromTip else { return }
        
        if drawMonophyleticWrOutgroup {
            depthOfRoot += 1
        }
        
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
                
                for (i,d) in node.descendants.enumerated(){
                    if i == 0, node === root, drawMonophyleticWrOutgroup {
                        continue
                    }
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
