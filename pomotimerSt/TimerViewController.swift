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
    //text to display upcoming timers
    @IBOutlet weak var upcomingTimers: NSTextField!
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
        // Do any additional setup after loading the view.
        print("timerViewController")
        if(QuoteManager.sharedInstance.amountQuotes != 0){
            quoteText.stringValue = QuoteManager.sharedInstance.getRandomQuote()
        }
        /*upcomingTimers.stringValue = SetupViewController().mainQueueClass.getCurrentTimers()*/
        timerName.stringValue = "current timer: " + queueManagerClass.findFirstTimer().getTitle()
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
        queueManagerClass.reset()
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
    
    func startFirstTimer(){
        //first timer in the dictionary
        let activeTimer = queueManagerClass.findFirstTimer()
        //creates a new instantiation with the same values except that its now set to "active"
        let newActiveTimer = queueManagerClass.setToActive(activeTimer: activeTimer)
        //how long the item lasts
        var seconds = newActiveTimer.getLengthSec()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            if(!self.isPaused){
                seconds -= 1
            }
            self.timerText.stringValue = "0:00:" + String(seconds)
            if(seconds == 0){
                self.stopTimer()
                if(self.queueManagerClass.completedTaskDictionary.count == self.queueManagerClass.numAdded){
                    print("timers done")
                    //access running instance of statusItemManager
                    guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
                    //resets all timers
                    self.queueManagerClass.reset()
                    //call the method that takes us to the done page
                    itemManager.showDone()
                }
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        self.timerText.stringValue = "0:00:00"
        self.nextTimer()

    }
    
    func nextTimer(){
        queueManagerClass.removeFirstTimer()
        indexToLoad = 1
        tableView.reloadData()
        startFirstTimer()
        timerName.stringValue = "current timer: " + queueManagerClass.findFirstTimer().getTitle()
    }
    
    //code for loading the custom cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print("building cell")
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "secondUserCell"), owner: self) as? SecondCustomTableCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (_, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(task.getOrderNum() == indexToLoad){
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
