//
//  ViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/28/21.
//

import Cocoa

class ViewController: NSViewController {
    
    //move to the set up page
    @IBAction func showSetup(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the showSetup() method in that instance
        itemManager.showSetup()
    }
    
    @IBAction func showPreferances(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the showSetup() method in that instance
        itemManager.showPreferances()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
