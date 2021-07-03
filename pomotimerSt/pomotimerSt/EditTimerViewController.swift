//
//  EditTimerViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 5/16/21.
//


import Cocoa

class EditTimerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //Text fields and button texts
    
    //text to display the name of the current timer
    @IBOutlet weak var timerName: NSTextField!
    //text boxes to display how much time is remaining on the current timer
    @IBOutlet weak var hoursTextBox: NSTextField!
    @IBOutlet weak var minutesTextBox: NSTextField!
    @IBOutlet weak var secondsTextBox: NSTextField!
    //table to hold editable task cells
    @IBOutlet weak var tableView: NSTableView!
    
    //set to 1 so that it loads the second item and skips the first
    var indexToLoad = 1
    var queueManagerClass = TimerQueueManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(queueManagerClass.futureTaskDictionary.count)
        // Do any additional setup after loading the view.
        fillTextBoxes()
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
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
        //save all of the cells that are currently displayed
        saveCells()
        //take you back to the timer page
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.showTimer()
    }
    
    @IBAction func newCell(_ sender: NSButton) {
        saveCells()
        queueManagerClass.createNewTask(duration: "", title: "")
        reloadTable()
    }
    
    @IBAction func editingHoursTopText(_ sender: NSTextField) {
        let currentInput = hoursTextBox.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            hoursTextBox.stringValue = ""
            // Could play a beep
            return
        }
        // checks if the min are valid
        if Int(currentInput) == nil || Int(currentInput)! > 23  {
            hoursTextBox.stringValue = ""    // Clear it
            // Could play a beep
            return
        }
    }

    @IBAction func editingMinutesTopText(_ sender: NSTextField) {
        let currentInput = minutesTextBox.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            minutesTextBox.stringValue = ""
            // Could play a beep
            return
        }
        // checks if the min are valid
        if Int(currentInput) == nil || Int(currentInput)! > 59  {
            minutesTextBox.stringValue = ""    // Clear it
            // Could play a beep
            return
        }
    }

    @IBAction func editingSecondsTopText(_ sender: NSTextField) {
        let currentInput = secondsTextBox.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            secondsTextBox.stringValue = ""
            // Could play a beep
            return
        }
        // checks if the min are valid
        if Int(currentInput) == nil || Int(currentInput)! > 59  {
            secondsTextBox.stringValue = ""    // Clear it
            // Could play a beep
            return
        }
    }
    
    func fillTextBoxes(){
        //fill the name of timer text box
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
        //fill the "time remaining" text boxes
        let totalSeconds = queueManagerClass.getTimeRemaining()
        hoursTextBox.stringValue = String(totalSeconds / 3600)
        minutesTextBox.stringValue = String((totalSeconds % 3600) / 60)
        secondsTextBox.stringValue = String((totalSeconds % 3600) % 60)
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
        return (queueManagerClass.futureTaskDictionary.count - 1)
    }

    func reloadTable(){
        print("reloading")
        indexToLoad = 1
        tableView.reloadData()
    }

    func saveCells(){
        //save the amount of tasks we had before deleting
        let dictionaryCount = queueManagerClass.futureTaskDictionary.count
        //delete the current dictionary of tasks
        queueManagerClass.resetTasks()
        //save the top timer
        let hourValue = Int(hoursTextBox.stringValue)!
        let minutesValue = Int(hoursTextBox.stringValue)!
        let secondsValue = Int(secondsTextBox.stringValue)!
        let totalDurationTop = String((hourValue * 60 * 60) + (minutesValue * 60) + secondsValue)
        let activityTop = timerName.stringValue
        queueManagerClass.createNewTask(duration: totalDurationTop, title: activityTop)
        self.queueManagerClass.currentTimeRemaining = Int(totalDurationTop)!
        //save everything in the tableView
        print("dictionary count: " + String(dictionaryCount))
        var i = 0
        while(i < dictionaryCount - 1){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomEditTimerCell
            let duration = view?.getDuration()
            let activity = view?.getActivity()
            queueManagerClass.createNewTask(duration: duration ?? "", title: activity ?? "")
            i += 1
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
