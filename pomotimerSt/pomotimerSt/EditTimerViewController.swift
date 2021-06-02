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
    var additionalTimers = 0
    var queueManagerClass = TimerQueueManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(queueManagerClass.futureTaskDictionary.count)
        // Do any additional setup after loading the view.
        fillTextBoxes()
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierDeleteButton"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        reloadTable()
    }
    
    @IBAction func backButton(_ sender: NSButton) {
        saveCells()
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.showTimer()
    }
    
    @IBAction func newCell(_ sender: NSButton) {
        additionalTimers += 1
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
    
    //code for loading the custom cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print(queueManagerClass.futureTaskDictionary.count)
        print("building cell")
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CustomEditTimerCell"), owner: self) as? CustomEditTimerCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (_, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(task.getOrderNum() == indexToLoad){
                //sets the activity and duration strings to what was stored for this particular dictionary entry
                let activity = task.getTitle()
                let duration = String(task.getLengthSec())
                //loads those strings into the lables on the cells
                userCell.setActivity(activity: activity)
                userCell.setDuration(durationInSeconds: duration)
            }
        }
        indexToLoad += 1
        //tells the computer what to load as the custom cell
        return userCell
    }

    //code for telling how many rows there are
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (queueManagerClass.futureTaskDictionary.count - 1) + additionalTimers
    }

    func reloadTable(){
        print("reloading")
        tableView.reloadData()
    }

    func saveCells(){
        print(queueManagerClass.futureTaskDictionary.count)
        //delete the current dictionary of tasks
        queueManagerClass.reset()
        //save the top timer
        let hourValue = Int(hoursTextBox.stringValue)!
        let minutesValue = Int(hoursTextBox.stringValue)!
        let secondsValue = Int(secondsTextBox.stringValue)!
        let totalDurationTop = String((hourValue * 60 * 60) + (minutesValue * 60) + secondsValue)
        let activityTop = timerName.stringValue
        queueManagerClass.createNewTask(duration: totalDurationTop, title: activityTop)
        //save everything in the tableView
        let dictionaryCount = queueManagerClass.futureTaskDictionary.count
        print(dictionaryCount)
        var i = 0
        while(i < (dictionaryCount - 1) + additionalTimers){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomEditTimerCell
            let duration = view?.getDuration()
            let activity = view?.getActivity()
            queueManagerClass.createNewTask(duration: duration ?? "", title: activity ?? "")
            i += 1
            print("added timer")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
