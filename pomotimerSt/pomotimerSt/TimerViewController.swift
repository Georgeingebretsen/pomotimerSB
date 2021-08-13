//
//  TimerViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa
import UserNotifications

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
    var queueManagerClass = TimerQueueManager.sharedInstance
    var timer: Timer? = nil
    var viewHasAlreadyLoaded = false
    var seconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("timerViewController viewDidLoad")
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //save what page the user is on
        itemManager.setMostRecentVC(recentVC: "TimerPage")
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
        tableView.reloadData()
        startFirstTimer()
    }
    
    //cancel button. works as back button and clears out the timer manager
    @IBAction func backToSetup(_ sender: NSButton) {
        print("backToSetup")
        //resets all timers
        queueManagerClass.resetTasks()
        queueManagerClass.resetValues()
        //stop and reset the timer
        timer?.invalidate()
        timer = nil
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.showSetup()
    }
    
    //pause or resume button
    @IBAction func togglePause(_ sender: NSButton) {
        print("togglePause")
        if(queueManagerClass.timerIsPaused){
            //resumed the timer
            print("resumed")
            //changes button text
            pauseButton.title = "pause"
            queueManagerClass.timerIsPaused = false
        }else{
            //paused the timer
            print("paused")
            //changes button text
            pauseButton.title = "resume"
            queueManagerClass.timerIsPaused = true
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
        //checks if this is the first time we're dealing with this timer
        if(queueManagerClass.currentTimeRemaining == 0){
            //sets the values that need to be set at the beginning
            //sets how long the timer is
            seconds = queueManagerClass.findFirstTimer().getLengthSec()
        }else{
            //loads where the timer was at when the user closed the window
            self.seconds = self.queueManagerClass.currentTimeRemaining
        }
        //start the countdown repeater
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            //saves how many seconds have passed in a different viewcontoller to be accessed in case the window is closed
            self.queueManagerClass.currentTimeRemaining = self.seconds
            if(!self.queueManagerClass.timerIsPaused){
                self.seconds -= 1
            }
            if(self.seconds == 0){
                self.queueManagerClass.currentTimeRemaining = 0
                self.sendNotification(notificationTitle: self.queueManagerClass.findFirstTimer().getTitle(), lastTimer: true)
                self.stopTimer()
                if(self.queueManagerClass.futureTaskDictionary.count == 1){
                    //code for when that was the last timer
                    print("timers done")
                    //access running instance of statusItemManager
                    guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
                    //resets all timers
                    self.queueManagerClass.resetTasks()
                    self.queueManagerClass.resetValues()
                    //call the showSetup() method in that instance
                    itemManager.setMostRecentVC(recentVC: "DonePage")
                    //call the method that takes us to the done page
                    itemManager.showDone()
                }else{
                    //code for when there are more timers left
                    self.sendNotification(notificationTitle: self.queueManagerClass.findFirstTimer().getTitle(), lastTimer: false)
                    self.nextTimer()
                }
            }
            //just in case the invaliadation failed, invalidate the timer.
            if(self.seconds < 0){
                self.timer?.invalidate()
            }
            //displays everything
            let hoursString = String(self.seconds / 3600)
            let minutesString = String((self.seconds % 3600) / 60)
            let secondsString = String((self.seconds % 3600) % 60)
            self.queueManagerClass.changeTimeRemaining(timeRemaining: self.seconds)
            self.timerText.stringValue = hoursString + ":" + minutesString + ":" + secondsString
        }
    }
    
    func sendNotification(notificationTitle: String, lastTimer: Bool) {
        print("sending notification")
        let content = UNMutableNotificationContent()
        
        content.title = notificationTitle + " finished"
        if(lastTimer){
            content.body = "All done!"
        }else{
            content.body = "Time to work on " + (self.queueManagerClass.futureTaskDictionary[1]?.getTitle())!
        }
        content.sound = UNNotificationSound.default
        content.badge = 1

        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
    
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = TimerViewController()


}
