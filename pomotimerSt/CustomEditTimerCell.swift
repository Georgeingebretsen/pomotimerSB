//
//  CustomEditTimerCell.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 5/16/21.
//

import Cocoa

class CustomEditTimerCell: NSTableCellView {
    @IBOutlet weak var editActivityTextField: NSTextField!
    @IBOutlet weak var hoursTextField: NSTextField!
    @IBOutlet weak var minutesTextField: NSTextField!
    @IBOutlet weak var secondsTextField: NSTextField!
    var cellIdentifier = 0
    var hh = ""
    var mm = ""
    var ss = ""
    var hhI = 0
    var mmI = 0
    var ssI = 0
    @IBAction func editedEditActivityField(_ sender: NSTextField) {
    }
    @IBAction func editedHoursTextField(_ sender: NSTextField) {
        let currentInput = hoursTextField.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
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
            minutesTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the mm to an int
            mmI = Int(mm)!
        }
    }
    @IBAction func editedSecondsTextField(_ sender: NSTextField) {
        let currentInput = secondsTextField.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            minutesTextField.stringValue = ""
            // Could play a beep
            return
        }
        ss = currentInput
        // checks if the min are valid
        if Int(ss) == nil || Int(ss)! > 59  {
            minutesTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the mm to an int
            ssI = Int(ss)!
        }
    }
    @IBAction func deleteTask(_ sender: NSButton) {
    }
    
    
    func setActivity(activity:String){
        editActivityTextField.stringValue = activity
    }
    
    func setDuration(durationInSeconds: String){
        //the total amount of time in seconds
        let total = Int(durationInSeconds)!
        //logic to find all of the hours minutes seconds values
        var minutesString = String(total / 60)
        let secondsString = String(total % 60)
        let hoursString = String((total / 60) / 60)
        minutesString = String((total / 60) % 60)
        //set all of the text fields
        minutesTextField.stringValue = minutesString
        secondsTextField.stringValue = secondsString
        hoursTextField.stringValue = hoursString

    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
}
