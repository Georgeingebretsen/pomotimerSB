//
//  CustomTableCell.swift
//  Queue Timer
//
//  Created by George Ingebretsen on 4/26/21.
//

import Cocoa

class CustomTableCell: NSTableCellView, NSTextFieldDelegate {

    @IBOutlet weak var activityTextField: NSTextField!
    @IBOutlet weak var hoursTextField: NSTextField!
    @IBOutlet weak var minutesTextField: NSTextField!
    
    
    
    var queueManagerClass = TimerQueueManager.sharedInstance
    var cellIdentifier = 0
    
    var task = ""
    var hh = ""
    var mm = ""
    var ss = ""
    var hhI = 0
    var mmI = 0
    var ssI = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityTextField.delegate = self
        hoursTextField.delegate = self
        minutesTextField.delegate = self
        activityTextField.tag = 0
        hoursTextField.tag = 1
        minutesTextField.tag = 2
    }
    
    @IBAction func deleteButton(_ sender: NSButton) {
        let cellIdentifierDic:[String: Int] = ["cellIdentifier": cellIdentifier]
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierSetupDeleteButton"), object: cellIdentifier, userInfo: cellIdentifierDic)
    }
    
    @IBAction func editingHoursTextField(_ sender: NSTextField) {
        let currentInput = hoursTextField.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 2) {
            // Clear it
            hoursTextField.stringValue = ""
            // Could play a beep
            return
        }else{
            hh = currentInput
        }
        // checks if the min are valid
        if Int(hh) == nil || Int(hh)! > 59  {
            hoursTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the mm to an int
            hhI = Int(hh)!
            hoursTextField.wantsLayer = false
        }
    }
    
    @IBAction func editedMinutesTextField(_ sender: NSTextField) {
        let currentInput = minutesTextField.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            minutesTextField.stringValue = ""
            // Could play a beep
            return
        }
        mm = currentInput
        // checks if the min are valid
        if Int(mm) == nil || Int(mm)! > 59  {
            //incorrect
            minutesTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //correct
            //set the mm to an int
            mmI = Int(mm)!
            minutesTextField.wantsLayer = false
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    func getActivity() -> String{
        return activityTextField.stringValue
    }
    
    func getDuration() -> String{
        makeSureValuesInstantiate()
        let totalSec = (hhI * 60 * 60) + (mmI * 60) + ssI
        return String(totalSec)
    }
    
    func makeSureValuesInstantiate(){
        mmI = Int(minutesTextField.stringValue) ?? 0
        ssI = 0
        hhI = Int(hoursTextField.stringValue) ?? 0
    }
    
    func clearAllCellValues(){
        setActivity(activity: "")
        setDuration(durationInSeconds: "")
        hh = ""
        mm = ""
        ss = ""
        hhI = 0
        mmI = 0
        ssI = 0
    }
    
    func setActivity(activity:String){
        activityTextField.stringValue = activity
    }
    
    func setDuration(durationInSeconds: String){
        if(durationInSeconds == ""){
            minutesTextField.stringValue = ""
            hoursTextField.stringValue = ""
        }else{
            //the total amount of time in seconds
            let total = Int(durationInSeconds)!
            //logic to find all of the hours minutes seconds values
            var minutesString = String(total / 60)
            let hoursString = String((total / 60) / 60)
            minutesString = String((total / 60) % 60)
            //set all of the text fields
            minutesTextField.stringValue = minutesString
            hoursTextField.stringValue = hoursString
        }
    }
    
    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            textFieldShouldReturn(findFirstResponder())
            return true
        }
        // return true if the action was handled; otherwise false
        return false
    }
    
    func findFirstResponder() -> NSTextField{
        if((activityTextField.currentEditor()) != nil){
            return activityTextField
        }
        if((hoursTextField.currentEditor()) != nil){
            return hoursTextField
        }
        if((minutesTextField.currentEditor()) != nil){
            return minutesTextField
        }
        return hoursTextField
    }
    
    func textFieldShouldReturn(_ textField: NSTextField) {
        let currentTag = textField.tag
        var nextTag = 0
        if(currentTag < 3){
            nextTag = currentTag + 1
        }
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

    }
    
}


