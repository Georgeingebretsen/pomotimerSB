//
//  CustomQuoteTableCell.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 5/15/21.
//

import Cocoa

class CustomQuoteTableCell: NSTableCellView {
    @IBOutlet weak var quoteTextField: NSTextField!
    var cellIdentifier = 0
    var quoteManagerClass = QuoteManager.sharedInstance
    
    @IBAction func editingQuoteField(_ sender: NSTextField) {
        let currentInput = quoteTextField.stringValue
            if currentInput.count > 150 {   // Refuse more than 5 chars as 23:59 or less than 3 chars but accepts 123 as 1:23
                quoteTextField.stringValue = ""    // Clear it
                // Could play a beep
            return
        }
    }
    
    @IBAction func deleteQuote(_ sender: NSButton) {
        //clear this cells text
        quoteTextField.stringValue = ""
        //tell the quote manager class to delete this cell
        quoteManagerClass.removeQuote(cellIdentifier: cellIdentifier)
        //tell the tableview to reload the table
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierQuoteDeleteButton"), object: nil)
    }
    
    func getQuote() -> String{
        return quoteTextField.stringValue
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
}
