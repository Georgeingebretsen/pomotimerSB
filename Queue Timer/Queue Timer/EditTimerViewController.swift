//
//  EditTimerViewController.swift
//  Queue Timer
//
//  Created by George Ingebretsen on 5/16/21.
//


import Cocoa

class EditTimerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //table to hold editable task cells
    @IBOutlet weak var tableView: NSTableView!
    
    var indexToLoad = 0
    var queueManagerClass = TimerQueueManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(queueManagerClass.futureTaskDictionary.count)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationDeleteButton(notification:)), name: Notification.Name("NotificationIdentifierEditDeleteButton"), object: nil)
        //set the recentVC to this page (save what page you're on)
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the showSetup() method in that instance
        itemManager.setMostRecentVC(recentVC: "EditPage")
    }

    @objc func methodOfReceivedNotificationDeleteButton(notification: Notification) {
        saveCells()
        //get the number of the cell that we want to delete
        let passedDictionary = notification.userInfo
        let numToDelete = passedDictionary!["cellIdentifier"]
        //delete the entry in the dictionary with the given cell identifier
        queueManagerClass.removeTimer(cellToRemove: numToDelete as! Int)
        //refresh the table to show the new dictionary values
        reloadTable()
    }
    
    @IBAction func backButton(_ sender: NSButton) {
        let dicCount = queueManagerClass.futureTaskDictionary.count
        var i = 0
        var redBox = false
        //check to see if the timers are valid
        while (i < dicCount - 1){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomEditTimerCell
            let duration = view?.getDuration()
            let activity = view?.getActivity().trimmingCharacters(in: .whitespacesAndNewlines)
            if(duration == "0"){
                //highlight red the duration text boxes of the cell that was left blank
                //make a beep sound
                highlightRed(textbox: (view?.hoursTextField)!)
                highlightRed(textbox: (view?.minutesTextField)!)
                redBox = true
            }
            if(activity == "" || activity?.count ?? 0 > 35){
                //highlight red the activity text box of the cell that was left blank or had too much text
                //make a beep sound
                highlightRed(textbox: (view?.editActivityTextField)!)
                redBox = true
            }
            i += 1
        }
        if(!redBox){
            //remove the notification center observer
            NotificationCenter.default.removeObserver(self)
            //instantiates the timers with the text values
            saveCells()
            //take you back to the timer page
            //access running instance of statusItemManager
            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
            //call the method that takes us back to the first page
            itemManager.showTimer()
        }
    }
    
    func highlightRed(textbox: NSTextField) {
        textbox.wantsLayer = true
        textbox.layer?.borderColor = NSColor.red.cgColor
        textbox.layer?.borderWidth = 1.0
        textbox.layer?.cornerRadius = 0.0
    }
    
    @IBAction func newCell(_ sender: NSButton) {
        saveCells()
        queueManagerClass.createNewTask(duration: "", title: "")
        reloadTable()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CustomEditTimerCell"), owner: self) as? CustomEditTimerCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (orderNum, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(orderNum == indexToLoad){
                //sets the activity and duration strings to what was stored for this particular dictionary entry
                let activity = task.getTitle()
                let duration = String(task.getLengthSec())
                //loads those strings into the lables on the cells
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

    //code for telling how many rows there are
    func numberOfRows(in tableView: NSTableView) -> Int {
        return queueManagerClass.futureTaskDictionary.count
    }

    func reloadTable(){
        //print("reloading")
        indexToLoad = 0
        tableView.reloadData()
    }

    func saveCells(){
        //save the amount of tasks we had before deleting
        let dictionaryCount = queueManagerClass.futureTaskDictionary.count
        //delete the current dictionary of tasks
        queueManagerClass.resetTasks()
        //save everything in the tableView
        var i = 0
        while(i < dictionaryCount){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomEditTimerCell
            let duration = view?.getDuration()
            let activity = view?.getActivity()
            queueManagerClass.createNewTask(duration: duration ?? "", title: activity ?? "")
            if(i == 0){
                self.queueManagerClass.currentTimeRemaining = Int(duration ?? "0")!
            }
            i += 1
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
