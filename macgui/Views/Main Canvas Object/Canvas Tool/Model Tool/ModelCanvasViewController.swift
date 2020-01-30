//
//  ModelCanvasViewController.swift
//  macgui
//
//  Created by Svetlana Krasikova on 1/28/20.
//  Copyright © 2020 Svetlana Krasikova. All rights reserved.
//

import Cocoa

class ModelCanvasViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var canvasView: CanvasView!
    
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.magnification = 1.5
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(didChangeModelMagnification(_ :)),
                                                      name: NSScrollView.didEndLiveMagnifyNotification,
                                                      object: nil)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        if let window = view.window  {
            window.delegate = self
        }
        canvasViewHeightConstraint.constant = scrollView.frame.size.height * 4
        canvasViewWidthConstraint.constant = scrollView.frame.size.width * 4
        
    }
    
    @IBAction func magnifyModelToolCanvas(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 1:
            scrollView.magnification = 0.375
            sender.setTitle("25%")
        case 2:
            scrollView.magnification = 0.75
            sender.setTitle("50%")
        case 3:
            scrollView.magnification = 1.125
            sender.setTitle("75%")
        case 4:
            scrollView.magnification = 1.5
            sender.setTitle("100%")
        case 5:
            scrollView.magnification = 1.875
            sender.setTitle("125%")
        case 6:
            scrollView.magnification = 2.25
            sender.setTitle("1500%")
        case 7:
            scrollView.magnification = 3.0
            sender.setTitle("200%")
        case 8:
            scrollView.magnification = 4.5
            sender.setTitle("300%")
        case 9:
            scrollView.magnification = 6.0
            sender.setTitle("400%")
        default:
            print("Switch case error!")
        }
    }
    
    
    @objc func didChangeModelMagnification(_ notification: Notification){
        NotificationCenter.default.post(name: .didChangeMagnification,
                                        object: self,
                                        userInfo: ["magnification": Float(scrollView.magnification)])
    }
    
    
}
