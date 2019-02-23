//
//  AnalysisViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AnalysisViewController: NSViewController {

    let imageLoader = ImageLoader(folder: "toolImages")
    var indexPathsOfItemsBeingDragged: Set<NSIndexPath>!
    
    @IBOutlet weak var toolView: NSCollectionView!
    @IBOutlet weak var canvasViewContainer: NSView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForDragAndDrop()
    
    }
    
    func registerForDragAndDrop() {
        toolView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
        toolView.setDraggingSourceOperationMask(.every, forLocal: true)
        toolView.setDraggingSourceOperationMask(.every, forLocal: false)
    }
    
    func loadCanvasForSelectedAnalysis(_ analysis: Analysis){
//        add a new subview for the selected analysis
    }
    
}

// MARK: - NSCollectionViewDelegate methods for handling drag from the collection view

extension AnalysisViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        
        let imageFile = imageLoader.getImageFileForPathIndex(indexPath: indexPath as IndexPath)
        return imageFile.url as NSURL
    }
    
}

// MARK: - NSCollectionViewDataSource methods

extension AnalysisViewController: NSCollectionViewDataSource {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of images in toolImages
        return imageLoader.getImagesCount()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let tool = toolView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Tool"), for: indexPath) as! Tool
        tool.imageFile = imageLoader.getImageFileForPathIndex(indexPath: indexPath)
        return tool
    }
    
    
}


