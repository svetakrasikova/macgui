//
//  TreeSet.swift
//  macgui
//
//  Created by Svetlana Krasikova on 9/11/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeSet: DataTool {
    
    enum Key: String {
        
        case unconnected = "unconnected inlet"
        case treeSourceMap
        case sources
    }
    
    var treeSourcesMap: [Int] = []
    @objc dynamic var sources: [TreeSource] = [TreeSource()]
    
    func emptyTreeSet () {
        sources.removeAll()
        treeSourcesMap.removeAll()
        trees.removeAll()
    }
    
    func removeTreesFrom(hash: Int) {
        
        var sourceToRemove: TreeSource?
        var index: Int?
        for (i,s) in sources.enumerated() {
            if s.hashVal == hash {
                sourceToRemove = s
                index = i
                break
            }
        }
        guard let i = index, let source = sourceToRemove else { return }
        if sources[i].tool != nil {
            sources[i] = TreeSource()
        }
        else {
            sources.remove(at: i)
        }
       
        if let firstTreeIndex = treeSourcesMap.firstIndex(of: hash){
            let lastTreeIndex = firstTreeIndex + source.count
            treeSourcesMap.removeSubrange(firstTreeIndex..<lastTreeIndex)
            trees.removeSubrange(firstTreeIndex..<lastTreeIndex)
        }
        
    }
    
    override init(name: String, frameOnCanvas: NSRect, analysis: Analysis) {
        
        super.init(name: name, frameOnCanvas: frameOnCanvas, analysis: analysis)
        
        self.inlets = [Connector(type: .treedata)]
        self.outlets = [Connector(type: .orange)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        treeSourcesMap = aDecoder.decodeObject(forKey: Key.treeSourceMap.rawValue) as? [Int] ?? []
        sources = aDecoder.decodeObject(forKey: Key.sources.rawValue) as? [TreeSource] ?? [TreeSource()]
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(treeSourcesMap, forKey: Key.treeSourceMap.rawValue)
        aCoder.encode(sources, forKey: Key.sources.rawValue)
    }
    
    
    func connectTreeData(from: DataTool) {
        trees.append(contentsOf: from.trees)
        addTreeSource(tool: from, key: from.description, count: from.trees.count)
    }
    
    func importTreesFrom(_ url: URL, trees: [Tree], overwrite: Bool) {
        if overwrite {
            emptyTreeSet()
            self.trees = trees
            
        } else {
            self.trees.append(contentsOf: trees)
            addTreeSource(tool: nil, key: url.lastPathComponent, count: trees.count)
        }
    }
    
    func addTreeSource(tool: AnyObject?, key: String, count: Int) {
        
        var index = -1
        if tool != nil {
            for (i,s) in sources.enumerated() {
                if s.key == Key.unconnected.rawValue {
                    index = i
                    break
                }
            }
        }
        
        let newSource = TreeSource(count: count, source: tool, key: key)
       
        index >= 0 ? sources[index] = newSource : sources.append(newSource)
        
        
        if count > 0 {
            let treesToAppend = [key.hashValue] + Array(repeating: 0, count: count-1)
            treeSourcesMap.append(contentsOf: treesToAppend)
        }
    }
    
//    func printTreeSourcesMap() {
//        var s = "##### Tree sources map #####: "
//        for (i,v) in self.treeSourcesMap.enumerated() {
//            s += "index \(i): tree hash \(v); "
//        }
//        print(s)
//    }
//    

    
    func runBackgroundImportTask(url: URL) {
        
        var successfullyReadData = true
          DispatchQueue.global(qos: .background).async {
            [unowned self] in
                do {
                    let readTrees = try readTreeDataTask(url)
            
                    if !readTrees.isEmpty {
                        DispatchQueue.main.async {
                            importTreesFrom(url, trees: readTrees, overwrite: false)
                        }
                    }
                } catch {
                   successfullyReadData = false
                }
                DispatchQueue.main.async {
                    delegate?.endProgressIndicator()
                    if !successfullyReadData {
                        readDataAlert(informativeText: "No trees could be imported. An error occurred while parsing the file(s).")
                    }
                }
            }
    }

}

class TreeSource: NSObject, NSCoding {
    
    
    enum Key: String {
        case hashVal, count, tool, key
    }
    
    var key: String
    var hashVal: Int {
       return key.hashValue
    }
    var count: Int
    var tool: DataTool?
    
    
    init(count: Int, source: AnyObject?, key: String) {
        self.count = count
        if let tool = source as? DataTool {
            self.tool = tool
        }
        self.key = key
        
    }
    
    override init() {
        key = TreeSet.Key.unconnected.rawValue
        count = 0
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(key, forKey: Key.key.rawValue)
        coder.encode(count, forKey: Key.count.rawValue)
        coder.encode(tool, forKey: Key.tool.rawValue)
    }
        
    required init?(coder: NSCoder) {
        key = coder.decodeObject(forKey: Key.key.rawValue) as! String
        count = coder.decodeInteger(forKey: Key.count.rawValue)
        tool = coder.decodeObject(forKey: Key.tool.rawValue) as? DataTool
    }

}
