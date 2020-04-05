//
//  MainWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/5/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    

    @IBOutlet weak var zoom: NSPopUpButton!
    var notebooks: [NotebookWindowController]? = []
    
    override var document: AnyObject? {
        didSet {
            if let document = self.document as? Document {
                self.contentViewController?.representedObject = document
            }
        }
    }
    
    var activeAnalysis: Analysis {
        if let analysis = (self.contentViewController as! MainSplitViewController).detailViewController.canvasViewController?.analysis {
            return analysis
        }
        else {return Analysis()}
    }
    
    weak var navigator: NSSplitViewItem? {
        if let navigator = (contentViewController as? MainSplitViewController)?.splitViewItems[0] {
            return navigator
        }
        return nil
    }
  
    
    @IBAction func openNotebook(_ sender: Any) {
        showNotebookWindow()
    }
    
    
    
    @objc func changeZoomTitle(notification: Notification){
        let userInfo = notification.userInfo! as! [String : Float]
        let magnification = userInfo["magnification"]!/0.015
        let title = String(format:"%.0f", magnification)
        zoom.setTitle("\(title)%")
    }
    
    func showNotebookWindow() {
        let notebookWC = NSStoryboard.loadWC(StoryBoardName.notebook) as! NotebookWindowController
        let notebookVC = notebookWC.contentViewController as! NotebookViewController
        notebookVC.analysis = self.activeAnalysis
        notebooks?.append(notebookWC)
        notebookWC.showWindow(self)
    }
    
    @objc func closeNotebookWindow(notification: Notification) {
        let closedWC = (notification.object as! NSWindow).windowController
        guard  closedWC != nil && closedWC!.isKind(of: NotebookWindowController.self)
        else { return }
        (closedWC?.contentViewController as! NotebookViewController).saveText()
        notebooks?.removeAll{$0 == closedWC}
    }
    

    
    @IBAction func collapseExpandSidebar(_ sender: NSButton) {
        guard let  navigator = self.navigator else {
            return
        }
        if navigator.isCollapsed {
            navigator.isCollapsed = false
        } else {
            navigator.isCollapsed = true
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeZoomTitle(notification:)),
                                               name: .didChangeMagnification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeNotebookWindow(notification:)),
                                               name: NSWindow.willCloseNotification,
                                               object: nil)
        
    }
    
    func windowWillClose(_ notification: Notification) {
        guard var notebooks = self.notebooks else { return  }
        for nbController in notebooks {
            nbController.window?.close()
        }
        notebooks.removeAll()
    }
  
}
