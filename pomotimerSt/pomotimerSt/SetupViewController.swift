//
//  SetupViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa
//page where you set up your timers
class SetupViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    var cellIdentifier = 0
    
    //class that manages the timers
    var mainQueueClass = TimerQueueManager.sharedInstance
    
    //number of instantiated timers
    var timers = 1;
    
    //gets executed right when the view is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierSetupDeleteButton"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        timers -= 1
        reloadTable()
    }
    
    //back button method
    @IBAction func backToFirstPageButton(_ sender: NSButton) {
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.backToStartPage()
    }
    
    //"done" button
    @IBAction func GoToTimer(_ sender: NSButton) {
        //instantiates the timers with the text values
        instantiateCellTimers()
        //move to next screen
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that directs us to the timer view
        itemManager.showTimer()
    }
    
    @IBAction func addMore(_ sender: NSButton) {
        timers += 1
        tableView.reloadData()
    }
    
    func instantiateCellTimers(){
        var i = 0
        while(i < timers){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomTableCell
            i += 1
            let duration = view!.getDuration()
            let activity = view!.getActivity()
            mainQueueClass.createNewTask(duration: duration, title: activity)
            print("added timer")
        }
    }
    
    //finds how many timers have been made and tells the table to make that many rows
    func numberOfRows(in tableView: NSTableView) -> Int {
        return timers
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: self) as? CustomTableCell else { return nil }
        userCell.cellIdentifier = self.cellIdentifier
        self.cellIdentifier += 1
        return userCell
    }
    
    func reloadTable(){
        print("reloading")
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
