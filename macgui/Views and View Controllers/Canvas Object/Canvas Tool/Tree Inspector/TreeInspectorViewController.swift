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
    
    let carouselViewBackgroundImage = NSImage(named: "page300x625")

    var trees: [Tree] = []

    
//    MARK: - iCarouselDataSource
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return trees.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: NSView?) -> NSView {

        let treeView = TreeSetView(image: carouselViewBackgroundImage!, tree: trees[index])
        treeView.delegate = self
        return treeView
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let inspectorWC = view.window?.windowController as? TreeInspectorWindowController, let trees = inspectorWC.trees else { return }
        self.trees = trees
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
            tree.setCoordinates()
        }
        return tree.tSequence
    }

    
}
