//
//  TimerViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa

class TimerViewController: NSViewController {
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
    
    var isPaused = false
    var queueManagerClass = TimerQueueManager.sharedInstance
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("timerViewController")
        upcomingTimers.stringValue = SetupViewController().mainQueueClass.getCurrentTimers()
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
        let newActiveTimer = queueManagerClass.setToActive(activeTimer: queueManagerClass.findFirstTimer())
        //how long the item lasts
        var seconds = newActiveTimer.getLengthSec()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            seconds -= 1
            self.timerText.stringValue = String(seconds)
            if(seconds == 0){
                self.stopTimer()
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        self.timerText.stringValue = "0:00:00"
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
