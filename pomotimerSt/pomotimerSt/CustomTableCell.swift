//
//  CustomTableCell.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/26/21.
//

import Cocoa

class CustomTableCell: NSTableCellView {

    @IBOutlet weak var activityTextField: NSTextField!
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
    
    @IBAction func editingHoursTextField(_ sender: NSTextField) {
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
            print("valid input")
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
            print("valid input")
        }
    }
    
    @IBAction func editedSecondsTextField(_ sender: NSTextField) {
        let currentInput = secondsTextField.stringValue
        // Refuse more than 2 chars
        if (currentInput.count >= 3) {
            // Clear it
            secondsTextField.stringValue = ""
            // Could play a beep
            return
        }
        ss = currentInput
        // checks if the min are valid
        if Int(ss) == nil || Int(ss)! > 59  {
            secondsTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the mm to an int
            ssI = Int(ss)!
            print("valid input")
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
        let totalMin = (hhI * 60 * 60) + (mmI * 60) + ssI
        print("total sec:" + String(totalMin))
        return String(totalMin)
    }
}
