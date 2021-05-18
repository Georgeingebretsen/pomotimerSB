//
//  QuotesViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/18/21.
//

import Cocoa

class QuotesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var quotesTableView: NSTableView!
    var cellIdentifier = 0
    
    var quoteManagerClass = QuoteManager.sharedInstance
    //number of quotes the user has added
    var quotes = 1

    @IBAction func doneButton(_ sender: NSButton) {
        saveQuotes()
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.backToStartPage()
    }
    
    @IBAction func backToPreferances(_ sender: Any) {
        saveQuotes()
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the showSetup() method in that instance
        itemManager.showPreferances()
    }
    
    @IBAction func addQuote(_ sender: NSButton) {
        quotes += 1
        quotesTableView.reloadData()
    }
    
    func saveQuotes(){
        //instantiate the new quotes
        var i = 0
        while(i < quotes){
            let view = self.quotesTableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomQuoteTableCell
            i += 1
            let quoteText = view!.getQuote()
            quoteManagerClass.makeNewQuote(newQuote: quoteText)
            print("added quote")
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: self) as? CustomQuoteTableCell else { return nil }
        userCell.cellIdentifier = self.cellIdentifier
        self.cellIdentifier += 1
        return userCell
    }
    
    //code for telling how many rows there are
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.quotes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        print("quote page loaded")
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
