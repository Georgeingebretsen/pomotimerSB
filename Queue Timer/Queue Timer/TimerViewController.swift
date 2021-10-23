//
//  TimerViewController.swift
//  Queue Timer
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa
import Foundation
import UserNotifications

class TimerViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    //Text fields and button texts
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
    var seconds = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("executing viewDidLoad")
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //save what page the user is on
        itemManager.setMostRecentVC(recentVC: "TimerPage")
        //load the current version of the timer
        timer = queueManagerClass.timer
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
        //updates the current time displayed on the screen
        if(queueManagerClass.currentTimeRemaining == 0){
            displayGivenDuration(duration: queueManagerClass.findFirstTimer().getLengthSec())
        }else{
            displayGivenDuration(duration: queueManagerClass.currentTimeRemaining)
        }
        //kill any existing notification recievers
        NotificationCenter.default.removeObserver(self)
        //kill any existing timers
        stopTimer()
        //refreshes the table before beginning the timer
        tableView.reloadData()
        //refresh the pause button image so it matches the state
        if(queueManagerClass.timerIsPaused){
            pauseButton.image = NSImage.init(systemSymbolName: "play.circle.fill", accessibilityDescription: "play")
        }
        //begins the timer process
        startTimer()
    }
    
    //cancel button. works as back button and clears out the timer manager
    @IBAction func backToSetup(_ sender: NSButton) {
        //kills the timer
        self.stopTimer()
        //kill the notification reciever
        NotificationCenter.default.removeObserver(self)
        //resets the queueManager class
        queueManagerClass.resetTasks()
        queueManagerClass.resetValues()
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.showSetup()
    }
    
    //pause or resume button
    @IBAction func togglePause(_ sender: NSButton) {
        if(queueManagerClass.timerIsPaused){
            //changes button image
            pauseButton.image = NSImage.init(systemSymbolName: "pause.circle.fill", accessibilityDescription: "play")
            //resume the timer
            queueManagerClass.timerIsPaused = false
        }else{
            //changes button image
            pauseButton.image = NSImage.init(systemSymbolName: "play.circle.fill", accessibilityDescription: "pause")
            //pause the timer
            queueManagerClass.timerIsPaused = true
        }
    }

    @IBAction func editButton(_ sender: NSButton) {
        //kill the timer
        stopTimer()
        //kill the notification reciever
        NotificationCenter.default.removeObserver(self)
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that takes us back to the first page
        itemManager.editPage()
    }
    
    func startTimer(){
        guard self.timer == nil else{
            print("A timer is already running. Ending StartTimer method.")
            return
        }
        //checks if this is the first time we're dealing with this timer
        if(queueManagerClass.currentTimeRemaining == 0){
            //sets the values that need to be set at the beginning
            //sets how long the timer is
            seconds = queueManagerClass.findFirstTimer().getLengthSec()
        }else{
            //loads where the timer was at when the user closed the window
            self.seconds = self.queueManagerClass.currentTimeRemaining
            //kill any existing timers
            stopTimer()
        }
        //start the countdown repeater
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            //saves how many seconds have passed in a different viewcontoller to be accessed in case the window is closed
            self.queueManagerClass.currentTimeRemaining = self.seconds
            if(!self.queueManagerClass.timerIsPaused){
                self.seconds -= 1
            }
            print(self.seconds)
            if(self.seconds <= 0){
                //kills the timer now that it's done
                self.stopTimer()
                //refreshes the time left, making sure it's updated
                self.queueManagerClass.currentTimeRemaining = 0
                if(self.queueManagerClass.futureTaskDictionary.count <= 1){
                    print("last timer reached")
                    //code for when the last timer is finished
                    //send notification telling user theyre all done
                    self.sendNotification(notificationTitle: self.queueManagerClass.findFirstTimer().getTitle(), lastTimer: true)
                    //kills the notification reciever
                    NotificationCenter.default.removeObserver(self)
                    //resets all timers
                    self.queueManagerClass.resetTasks()
                    self.queueManagerClass.resetValues()
                    print("taking to done page")
                    //access running instance of statusItemManager
                    guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
                    //call the showSetup() method in that instance
                    itemManager.setMostRecentVC(recentVC: "DonePage")
                    //call the method that takes us to the done page
                    itemManager.showDone()
                }else{
                    //code for when there are still timers left
                    self.sendNotification(notificationTitle: self.queueManagerClass.findFirstTimer().getTitle(), lastTimer: false)
                    self.nextTimer()
                }
            }
            
            //updates the current time displayed on the screen
            self.displayGivenDuration(duration: self.seconds)
            //saves all storage values in the queueManagerClass
            self.queueManagerClass.changeTimeRemaining(timeRemaining: self.seconds)
            self.queueManagerClass.timer = self.timer
        }
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func displayGivenDuration(duration: Int){
        //displays everything
        var hoursString = String(duration / 3600) + ":"
        if(hoursString == "0:"){
            hoursString = ""
        }
        var minutesString = String((duration % 3600) / 60) + ":"
        if(minutesString == "0:"){
            minutesString = "00:"
        }
        var secondsString = String((duration % 3600) % 60)
        if(secondsString == "0"){
            secondsString = "00"
        }
        self.timerText.stringValue = hoursString + minutesString + secondsString
    }
    
    func sendNotification(notificationTitle: String, lastTimer: Bool) {
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
    
    func nextTimer(){
        queueManagerClass.removeTimer(cellToRemove: 0)
        indexToLoad = 1
        tableView.reloadData()
        startTimer()
        timerName.stringValue = queueManagerClass.findFirstTimer().getTitle()
    }
    
    //code for loading the custom cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //print("building cell")
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
