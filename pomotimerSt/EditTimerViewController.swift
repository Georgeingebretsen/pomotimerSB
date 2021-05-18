//
//  EditTimerViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 5/16/21.
//


import Cocoa

class EditTimerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //Text fields and button texts
    
    //text to display how much time is remaining on the current timer
    @IBOutlet weak var timerText: NSTextField!
    //text to display current timer activity name
    @IBOutlet weak var timerName: NSTextField!
    //button text to pause. chagnes to resume when pressed
    @IBOutlet weak var tableView: NSScrollView!
    
    //set to 1 so that it loads the second item and skips the first
    var indexToLoad = 1
    
    var additionalTimers = 0
    
    var queueManagerClass = TimerQueueManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*upcomingTimers.stringValue = SetupViewController().mainQueueClass.getCurrentTimers()*/
        timerName.stringValue = "current timer: " + queueManagerClass.findFirstTimer().getTitle()
        let seconds = queueManagerClass.getTimeRemaining()
        let timerTextDisplayed = String(seconds / 3600) + ":" + String((seconds % 3600) / 60) + ":" + String((seconds % 3600) % 60)
        timerText.stringValue = timerTextDisplayed
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
    }
    
    //code for loading the custom cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
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
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
