//
//  QuotesViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/18/21.
//

import Cocoa

class QuotesViewController: NSViewController {
    @IBOutlet weak var quoteField1: NSTextField!
    @IBOutlet weak var quoteField2: NSTextField!
    @IBOutlet weak var quoteField3: NSTextField!
    @IBOutlet weak var quoteField4: NSTextField!
    @IBOutlet weak var quoteField5: NSTextField!
    @IBOutlet weak var quoteField6: NSTextField!
    @IBOutlet weak var quoteField7: NSTextField!
    var quoteManagerClass = QuoteManager.sharedInstance
    @IBAction func backButton(_ sender: NSButton) {
        //instantiate the new quotes
        if(quoteField1.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField1.stringValue)
            print("added 1 ")
        }
        if(quoteField2.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField2.stringValue)
            print("added 2 ")
        }
        if(quoteField3.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField3.stringValue)
            print("added 3 ")
        }
        if(quoteField4.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField4.stringValue)
            print("added 4 ")
        }
        if(quoteField5.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField5.stringValue)
            print("added 5 ")
        }
        if(quoteField6.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField6.stringValue)
            print("added 6 ")
        }
        if(quoteField7.stringValue != ""){
            quoteManagerClass.makeNewQuote(newQuote: quoteField7.stringValue)
            print("added 7 ")
        }
        
        
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

