//
//  TimerViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa

class TimerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //Text fields and button texts
    //top text to display quotes
    @IBOutlet weak var quoteText: NSTextField!
    //text to display how much time is remaining on the current timer
    @IBOutlet weak var timerText: NSTextField!
    //text to display current timer activity name
    @IBOutlet weak var timerName: NSTextField!
    //button text to pause. chagnes to resume when pressed
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    //set to 1 so that it loads the second item and skips the first
    var indexToLoad = 1
    var isPaused = false
    var queueManagerClass = TimerQueueManager.sharedInstance
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("num in task directory:")
        print(queueManagerClass.futureTaskDictionary.count)
        // Do any additional setup after loading the view.
        print("timerViewController")
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
        tableView.reloadData()
        startFirstTimer()
    }
    
    //cancel button. works as back button and clears out the timer manager
    @IBAction func backToSetup(_ sender: NSButton) {
        print("backToSetup")
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.backToSetupPage()
        //resets all timers
        queueManagerClass.resetTasks()
        //stop and reset the timer
        timer?.invalidate()
        timer = nil
    }
    
    //pause or resume button
    @IBAction func togglePause(_ sender: NSButton) {
        print("togglePause")
        if(isPaused){
            //resumed the timer
            print("resumed")
            //changes button text
            pauseButton.title = "pause"
            isPaused = false
        }else{
            //paused the timer
            print("paused")
            //changes button text
            pauseButton.title = "resume"
            isPaused = true
        }
    }
    
    @IBAction func editButton(_ sender: NSButton) {
        //kill the timer
        stopTimer()
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.editPage()
    }
    
    func startFirstTimer(){
        //how long the timer lasts
        var seconds = queueManagerClass.findFirstTimer().getLengthSec()
        //start the countdown repeater
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            if(!self.isPaused){
                seconds -= 1
            }
            if(seconds == 0){
                self.stopTimer()
                if(self.queueManagerClass.futureTaskDictionary.count == 1){
                    print("timers done")
                    //access running instance of statusItemManager
                    guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
                    //resets all timers
                    self.queueManagerClass.resetTasks()
                    //call the method that takes us to the done page
                    itemManager.showDone()
                }else{
                    self.nextTimer()
                }
            }
            let hoursString = String(seconds / 3600)
            let minutesString = String((seconds % 3600) / 60)
            let secondsString = String((seconds % 3600) % 60)
            self.queueManagerClass.changeTimeRemaining(timeRemaining: seconds)
            self.timerText.stringValue = hoursString + ":" + minutesString + ":" + secondsString
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        self.timerText.stringValue = "00:00:00"
    }
    
    func nextTimer(){
        queueManagerClass.removeTimer(cellToRemove: 0)
        indexToLoad = 1
        tableView.reloadData()
        startFirstTimer()
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
    }
    
    //code for loading the custom cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("building cell")
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "secondUserCell"), owner: self) as? SecondCustomTableCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (orderNum, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(orderNum == indexToLoad){
                //sets the activity and duration strings to what was stored for this particular dictionary entry
                let activity = task.getTitle()
                let duration = String(task.getLengthSec())
                //loads those strings into the lables on the cells
                userCell.setActivity(activity: activity)
                userCell.setDuration(duration: duration)
            }
        }
        indexToLoad += 1
        //tells the computer what to load as the custom cell
        return userCell
    }
    
    //code for telling how many rows there are
    func numberOfRows(in tableView: NSTableView) -> Int {
        return queueManagerClass.futureTaskDictionary.count - 1
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
