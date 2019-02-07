//
//  AnalysisViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 2/4/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class AnalysisViewController: NSViewController {
    
    @IBOutlet weak var toolView: NSCollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension AnalysisViewController: NSCollectionViewDataSource {
    
    static let tool = "ToolView"
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = toolView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: AnalysisViewController.tool), for: indexPath)
        return item
    }
    
    
}
