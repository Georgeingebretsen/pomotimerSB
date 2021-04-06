//
//  SetupViewController.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa
//page where you set up your timers
class SetupViewController: NSViewController {
    //text field variables
    @IBOutlet weak var activity: NSTextField!
    @IBOutlet weak var duration: NSTextField!
    @IBOutlet weak var activity2: NSTextField!
    @IBOutlet weak var duration2: NSTextField!
    @IBOutlet weak var activity3: NSTextField!
    @IBOutlet weak var duration3: NSTextField!
    @IBOutlet weak var activity4: NSTextField!
    @IBOutlet weak var duration4: NSTextField!
    @IBOutlet weak var activity5: NSTextField!
    @IBOutlet weak var duration5: NSTextField!
    
    //class that manages the timers
    var mainQueueClass = TimerQueueManager.sharedInstance
    
    //number of instantiated timers
    var timers = 0;
    
    //gets executed right when the view is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        //instantiates the timers with the text values
        instantiateTimers();
        //move to next screen
        //access running instance of statusItemManager
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        //call the method that directs us to the timer view
        itemManager.showTimer()
    }
    
    func instantiateTimers(){
        //instantiate the new timers
        if(activity.stringValue != "" && duration.stringValue != ""){
            mainQueueClass.createNewTask(duration: duration.stringValue, title: activity.stringValue)
            print("added 1 ")
        }
        if(activity2.stringValue != "" && duration2.stringValue != ""){
            mainQueueClass.createNewTask(duration: duration2.stringValue, title: activity2.stringValue)
            print("added 2 ")
        }
        if(activity3.stringValue != "" && duration3.stringValue != ""){
            mainQueueClass.createNewTask(duration: duration3.stringValue, title: activity3.stringValue)
            print("added 3 ")
        }
        if(activity4.stringValue != "" && duration4.stringValue != ""){
            mainQueueClass.createNewTask(duration: duration3.stringValue, title: activity4.stringValue)
            print("added 4 ")
        }
        if(activity5.stringValue != "" && duration5.stringValue != ""){
            mainQueueClass.createNewTask(duration: duration5.stringValue, title: activity5.stringValue)
            print("added 5 ")
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

