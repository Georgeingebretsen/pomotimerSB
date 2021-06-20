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
    
    //class that manages the timers
    var queueManagerClass = TimerQueueManager.sharedInstance
    var indexToLoad = 0
    
    //gets executed right when the view is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierSetupDeleteButton"), object: nil)
        queueManagerClass.createNewTask(duration: "", title: "")
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        saveCells()
        //get the number of the cell that we want to delete
        let passedDictionary = notification.userInfo
        let numToDelete = passedDictionary!["cellIdentifier"]
        //delete the entry in the dictionary with the given cell identifier
        queueManagerClass.removeTimer(cellToRemove: numToDelete as! Int)
        //refresh the table to show the new dictionary values
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
        if(queueManagerClass.isEmptyValues()){
            //make a beep noise or figure out how to highlight the cell with the missing value
        }else{
            //instantiates the timers with the text values
            saveCells()
            //move to next screen
            //access running instance of statusItemManager
            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
            //call the method that directs us to the timer view
            itemManager.showTimer()
        }
    }
    
    @IBAction func addMore(_ sender: NSButton) {
        saveCells()
        queueManagerClass.createNewTask(duration: "", title: "")
        reloadTable()
    }
    
    func saveCells(){
        var i = 0
        let dicCount = queueManagerClass.futureTaskDictionary.count
        queueManagerClass.resetTasks()
        while(i < dicCount){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomTableCell
            i += 1
            let duration = view?.getDuration()
            let activity = view?.getActivity()
            queueManagerClass.createNewTask(duration: duration ?? "", title: activity ?? "")
        }
    }
    
    //finds how many timers have been made and tells the table to make that many rows
    func numberOfRows(in tableView: NSTableView) -> Int {
        return queueManagerClass.futureTaskDictionary.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: self) as? CustomTableCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (orderNum, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(orderNum == indexToLoad){
                //sets the activity and duration strings to what was stored for this particular dictionary entry
                let activity = task.getTitle()
                let duration = String(task.getLengthSec())
                //loads those strings into the lables on the cell
                userCell.setActivity(activity: activity)
                userCell.setDuration(durationInSeconds: duration)
                //loads other variables on the cell
                userCell.cellIdentifier = orderNum
            }
        }
        indexToLoad += 1
        //tells the computer what to load as the custom cell
        return userCell
    }
    
    func reloadTable(){
        indexToLoad = 0
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
