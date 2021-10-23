//
//  SetupViewController.swift
//  Queue Timer
//
//  Created by George Ingebretsen on 3/29/21.
//

import Cocoa
//page where you set up your timers
class SetupViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    
    //class that manages the timers
    var queueManagerClass = TimerQueueManager.sharedInstance
    var indexToLoad = 0
    var randomIndex = Int.random(in: 1..<100000);
    
    func reloadTimers() {
        tableView.reloadData()
    }
    
    //gets executed right when the view is launched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        tableView.delegate = self
        tableView.dataSource = self
        //resets the queueManager class
        queueManagerClass.resetTasks()
        queueManagerClass.resetValues()
        let deleteButtonObserver: Void = NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifierSetupDeleteButton"), object: nil)
        //create the first task
        queueManagerClass.createNewTask(duration: "", title: "")
        //save what page the user is on
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        itemManager.setMostRecentVC(recentVC: "SetupPage")
    }
    
    //delete button method
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("random delete");
        print(randomIndex);

        saveCells()
        //find the index of the cell that we want to delete
        let passedDictionary = notification.userInfo
        let numToDelete = passedDictionary!["cellIdentifier"]
        
        //delete the entry in the dictionary at the given index
        queueManagerClass.removeTimer(cellToRemove: numToDelete as! Int)
        //refresh the table to show the new dictionary values
        reloadTable()
    }
    
    //"done" button
    @IBAction func GoToTimer(_ sender: NSButton) {
        if(self.findInvalidActivities().count != 0){
            let dicCount = queueManagerClass.futureTaskDictionary.count
            var i = 0
            while (i < dicCount){
                let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomTableCell
                let duration = view?.getDuration()
                let activity = view?.getActivity().trimmingCharacters(in: .whitespacesAndNewlines)
                if(duration == "0"){
                    //highlight red the duration text boxes of the cell that was left blank
                    highlightRed(textbox: (view?.minutesTextField)!)
                    highlightRed(textbox: (view?.hoursTextField)!)
                }
                if(activity == "" || activity?.count ?? 0 > 35){
                    //highlight red the activity text box of the cell that was left blank or had too much text
                    highlightRed(textbox: (view?.activityTextField)!)
                }
                i += 1
            }
        }else{
            //remove the notification center observer
            NotificationCenter.default.removeObserver(self)
            //instantiates the timers with the text values
            saveCells()
            //move to next screen
            //access running instance of statusItemManager
            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
            //call the method that directs us to the timer view
            itemManager.showTimer()
        }
    }
    
    //"add new" button method
    @IBAction func addMore(_ sender: NSButton) {
        saveCells()
        queueManagerClass.createNewTask(duration: "", title: "")
        let dicCount = queueManagerClass.futureTaskDictionary.count
        print("amount after add = ")
        print(dicCount)
        reloadTable()
    }
    
    func highlightRed(textbox: NSTextField) {
        textbox.wantsLayer = true
        textbox.layer?.borderColor = NSColor.red.cgColor
        textbox.layer?.borderWidth = 1.0
        textbox.layer?.cornerRadius = 0.0
    }
    
    func saveCells() {
        var i = 0
        let dicCount = queueManagerClass.futureTaskDictionary.count
        queueManagerClass.resetTasks()
        while(i < dicCount){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomTableCell
            i += 1
            let duration = view?.getDuration()
            let activity = view?.getActivity()
            queueManagerClass.createNewTask(duration: duration ?? "", title: activity ?? "")
        }
        let newDicCount = queueManagerClass.futureTaskDictionary.count
    }
    
    func findInvalidActivities() -> Dictionary<Int, Int>{
        var i = 0
        var index = 0
        let dic = queueManagerClass.futureTaskDictionary
        var blanksDic: [Int:Int] = [:]
        while(i < dic.count){
            let view = self.tableView.view(atColumn: 0, row: i, makeIfNecessary: false) as? CustomTableCell
            i += 1
            let activity = view?.getActivity().trimmingCharacters(in: .whitespacesAndNewlines)
            let duration = view?.getDuration()
            if(activity == "" || activity?.count ?? 0 > 35 || duration == "0"){
                blanksDic[index] = i
                index += 1
            }
        }
        return blanksDic
    }
    
    //finds how many timers have been made and tells the table to make that many rows
    func numberOfRows(in tableView: NSTableView) -> Int {
        return queueManagerClass.futureTaskDictionary.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let userCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: self) as? CustomTableCell else { return nil }
        //goes through each entry in the directory. not nessisarily sorted by the correct order.
        for (orderNum, task) in queueManagerClass.futureTaskDictionary {
            //goes checks to see if the current token is the correct token that the cell should use
            if(orderNum == indexToLoad){
                //sets the activity and duration strings to what was stored for this particular dictionary entry
                let activity = task.getTitle()
                let duration = String(task.getLengthSec())
                if(activity == "0"){
                    userCell.setActivity(activity: "")
                }else{
                    //loads those sstrings into the lables on the cell
                    userCell.setActivity(activity: activity)
                }
                if(duration == "0"){
                    userCell.setDuration(durationInSeconds: "")
                }else{
                    userCell.setDuration(durationInSeconds: duration)
                }
                //loads other variables on the cell
                userCell.cellIdentifier = orderNum
            }
        }
        indexToLoad += 1
        //tells the computer what to load as the custom cell
        return userCell
    }
    
    func reloadTable(){
        indexToLoad = 0
        tableView.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
