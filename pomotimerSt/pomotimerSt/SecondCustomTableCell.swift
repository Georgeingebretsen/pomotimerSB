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
        let hourValue = Int(duration)! / 3600
        let minutesValue = (Int(duration)! % 3600) / 60
        let secondsValue = String((Int(duration)! % 3600) % 60)
        durationLabel.stringValue = duration
    }
}
