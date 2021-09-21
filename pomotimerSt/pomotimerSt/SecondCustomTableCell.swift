//
//  SecondCustomTableCell.swift
//  pomotimerSt
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
        var hoursString = String(Int(duration)! / 3600) + ":"
        if(hoursString == "0:"){
            hoursString = ""
        }
        var minutesString = String((Int(duration)! % 3600) / 60) + ":"
        if(minutesString == "0:"){
            minutesString = "00:"
        }
        var secondsString = String((Int(duration)! % 3600) % 60)
        if(secondsString == "0"){
            secondsString = "00"
        }
        durationLabel.stringValue = hoursString + minutesString + secondsString
    }
}
