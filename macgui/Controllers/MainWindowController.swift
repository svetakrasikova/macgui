//
//  MainWindowController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 4/5/19.
//  Copyright © 2019 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    @IBOutlet weak var zoom: NSPopUpButton!
    
   
    var notebooks: [NotebookWindowController]? = []
    
    var activeAnalysis: Analysis? {
        if let analysis = (self.contentViewController as! MainSplitViewController).detailViewController.canvasViewController?.analysis {
            return analysis
        }
        else {return Analysis()}
    }
  
    
    @IBAction func openNotebook(_ sender: Any) {
        showNotebookWindow()
        print("Number of open notebooks: ", String(notebooks!.count))
    }
    
    
    
    @objc func changeZoomTitle(notification: Notification){
        let userInfo = notification.userInfo! as! [String : Float]
        let magnification = userInfo["magnification"]!/0.015
        let title = String(format:"%.0f", magnification)
        zoom.setTitle("\(title)%")
    }
    
    func showNotebookWindow() {
        let notebookWC = NSStoryboard.loadWC(StoryBoardName.notebook)
            notebooks?.append(notebookWC as! NotebookWindowController)
        notebookWC.showWindow(self)
    }
    
    @objc func closeNotebookWindow(notification: Notification) {
        let closedWC = (notification.object as! NSWindow).windowController
        guard  closedWC != nil && closedWC!.isKind(of: NotebookWindowController.self)
        else { return }
        notebooks?.removeAll{$0 == closedWC}
        print("Number of open notebooks: ", String(notebooks!.count))
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeZoomTitle(notification:)),
                                               name: .didChangeMagnification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(closeNotebookWindow(notification:)),
                                               name: NSWindow.willCloseNotification,
                                               object: nil)
    }
    
}
