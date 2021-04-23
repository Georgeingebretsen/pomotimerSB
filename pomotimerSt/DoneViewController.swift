//
//  DoneViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/19/21.
//

import Cocoa
//page where you set up your timers
class DoneViewController: NSViewController {

    @IBAction func quitButton(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.backToStartPage()
    }
    
    //gets executed right when the view is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

