//
//  CustomTableCell.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/26/21.
//

import Cocoa

class CustomTableCell: NSTableCellView {

    @IBOutlet weak var activityTextField: NSTextField!
    @IBOutlet weak var durationTextField: NSTextField!
    var cellIdentifier = 0
    var mm = ""
    var ss = ""
    var mmI = 0
    var ssI = 0
    
    @IBAction func editingDurationField(_ sender: NSTextField) {
        let currentInput = durationTextField.stringValue
            if currentInput.count > 5 || currentInput.count < 3 {   // Refuse more than 5 chars as 23:59 or less than 3 chars but accepts 123 as 1:23
            durationTextField.stringValue = ""    // Clear it
                // Could play a beep
            return
        }

        let posOfColon = currentInput.firstIndex(of: ":")
        let withColon = posOfColon != nil

        if withColon {
            mm = String(currentInput[..<posOfColon!])
            let mmIndex = currentInput.index(posOfColon!, offsetBy: 1)
            ss = String(currentInput[mmIndex...])
        } else {
            ss = String(currentInput.suffix(2))     // Always 2 digits for minutes
            if currentInput.count == 4 {  // format as 1234
                mm = String(currentInput.prefix(2))     // first 2 digits
            } else {  // Only 3 chars
                mm = String(currentInput.prefix(1))     // Only one digit here
            }
        }
        // checks if the min are valid
        if Int(mm) == nil || Int(mm)! > 59  {
            durationTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the mm to an int
            mmI = Int(mm)!
        }
        // checks if the sec are valid
        if Int(ss) == nil || Int(ss)! > 59  {
            durationTextField.stringValue = ""    // Clear it
            // Could play a beep
            return
        }else{
            //if it is valid, set the ss to an int
            ssI = Int(ss)!
        }
        print(ss)
        print(mm)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    func getActivity() -> String{
        return activityTextField.stringValue
    }
    
    func getDuration() -> String{
        let totalSec = (mmI * 60) + ssI
        print("total sec:" + String(totalSec))
        return String(totalSec)
    }
}
