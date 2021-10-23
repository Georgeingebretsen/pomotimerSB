//
//  SecondCustomTableCell.swift
//  Queue Timer
//
//  Created by George Ingebretsen on 5/3/21.
//

import Cocoa

class SecondCustomTableCell: NSTableCellView {
    
    @IBOutlet weak var activityLabel: NSTextField!
    @IBOutlet weak var durationLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    func setActivity(activity:String){
        activityLabel.stringValue = activity
    }
    
    func setDuration(duration: String){
        //displays everything
        var hoursIsPresent = true
        var hoursString = String(Int(duration)! / 3600) + ":"
        if(hoursString == "0:"){
            hoursString = ""
            hoursIsPresent = false
        }
        var minutesString = String((Int(duration)! % 3600) / 60)
        if(minutesString.count == 1 && hoursIsPresent){
            minutesString = "0" + minutesString
        }
        durationLabel.stringValue = hoursString + minutesString
    }
}
