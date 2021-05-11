//
//  PreferancesViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/25/21.
//

import Cocoa

class PreferancesViewController: NSViewController {

    @IBAction func goToQuotes(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the showSetup() method in that instance
        itemManager.showQuotes()
    }
    
    @IBAction func backToMain(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.backToStartPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("quote page loaded")
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
