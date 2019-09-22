//
//  Document.swift
//  test-document-based
//
//  Created by Svetlana Krasikova on 9/20/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var dataSource: DataSource? = DataSource()
   
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        if let dataSource = self.dataSource {
                  return NSKeyedArchiver.archivedData(withRootObject: dataSource)
              } else {
                  throw NSError(domain: "Document", code: 0, userInfo: nil)
              }
    }

    override func read(from data: Data, ofType typeName: String) throws {
       if let dataSource = NSKeyedUnarchiver.unarchiveObject(with: data) as? DataSource {
            self.dataSource = dataSource
        } else {
            throw NSError(domain: "Document", code: 0, userInfo: nil)
        }
    }


}

