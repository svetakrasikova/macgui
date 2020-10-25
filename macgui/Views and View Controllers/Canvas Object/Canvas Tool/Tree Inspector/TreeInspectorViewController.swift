//
//  TreeInspectorViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 10/14/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class TreeInspectorViewController: NSViewController, iCarouselDelegate, iCarouselDataSource, TreeSetViewDelegate {


    @IBOutlet var Carousel: iCarousel!
    
    var drawMonophyleticWrOutgroup: Bool = false

    var trees: [Tree] = []
    var rootedTrees: [Tree] = []

    
//    MARK: - iCarouselDataSource
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return rootedTrees.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: NSView?) -> NSView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let treeView = TreeSetView(frame: frame, tree: rootedTrees[index])
        treeView.delegate = self
        return treeView
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let inspectorWC = view.window?.windowController as? TreeInspectorWindowController, let trees = inspectorWC.trees else { return }
        self.trees = trees
        for tree in trees {
            self.rootedTrees.append(tree.rooted())
        }
        Carousel.reloadData()
        Carousel.type = .coverFlow2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Carousel.reloadData()
        Carousel.type = .coverFlow2
    }
    
//  MARK: -- TreeSetViewDelegate
    
    func biggestNameRect(attributes: [NSAttributedString.Key : Any], tree: Tree) -> NSRect {
        var biggestNameRect: NSRect = NSZeroRect
        
        
        for node in tree.tSequence {
            if node.isLeaf {
                let taxonName = node.name
                let attributedString = NSAttributedString(string: taxonName, attributes: attributes)
                let textSize = attributedString.boundingRect(with: NSMakeSize(1e10, 1e10), options: [.usesLineFragmentOrigin], context: nil)
                if textSize.size.width > biggestNameRect.size.width {
                    biggestNameRect.size.width = textSize.size.width
                }
                if textSize.size.height > biggestNameRect.size.height {
                    biggestNameRect.size.height = textSize.size.height
                }
            }
        }
        
        
        return biggestNameRect
    }
    
    func nodesWithCoordinates(tree: Tree) -> [Node]? {
        
        if tree.nodeCoordinates.isEmpty {
            tree.setCoordinates(drawMonophyleticWrOutgroup: drawMonophyleticWrOutgroup)
        }
        return tree.tSequence
    }
    
    func isDrawMonophyleticWrOutgroup() -> Bool {
        return self.drawMonophyleticWrOutgroup
    }
    
}
