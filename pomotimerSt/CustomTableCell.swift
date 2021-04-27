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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
