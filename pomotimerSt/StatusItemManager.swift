//
//  StatusItemManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/28/21.
//

import Cocoa


class StatusItemManager: NSObject {
    
    var statusItem: NSStatusItem?
     
    var popover: NSPopover?
     
    //note: in the tutorial, they made their own view controller named ConverterViewController...
    //if somethings not working try looking into that
    var timerVC: ViewController?

    fileprivate func initStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImage = NSImage(named: "timerDrawing")
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(showConverterVC)
    }
    
    //opens the popover by clicking on the icon
    @objc func showConverterVC() {
        //1) makes sure that the method wont execute if the display hasn't been initialized
        guard let popover = popover, let button = statusItem?.button else { return }
        if timerVC == nil {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "MenuPage")) as? ViewController else { return }
            timerVC = vc
        }
        //2) assignes popover as the view controller for the popover
        popover.contentViewController = timerVC
        //3) display the popover
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    //takes you to the setup setup page
    func showSetup() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "SetupPage")) as? SetupViewController else { return }
        popover.contentViewController = vc
    }
    
    func showPreferances() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "PreferancesPage")) as? PreferancesViewController else { return }
        popover.contentViewController = vc
    }
    
    func showQuotes() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "QuotesPage")) as? QuotesViewController else { return }
        popover.contentViewController = vc
    }
    
    //takes you to the timer setup page
    func showTimer() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "TimerPage")) as? TimerViewController else { return }
        popover.contentViewController = vc
    }
    
    func showDone() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "DonePage")) as? DoneViewController else { return }
        popover.contentViewController = vc
    }
    
    //the back button to go back to the first page
    func backToStartPage() {
        guard let popover = popover else { return }
        popover.contentViewController?.dismiss(nil)
        showConverterVC()
    }
    
    //the back button to go back to the second page
    func backToSetupPage() {
        guard let popover = popover else { return }
        popover.contentViewController?.dismiss(nil)
        showConverterVC()
    }
    
    //the edit button to go to the edit page
    func editPage() {
        guard let popover = popover else { return }
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "EditPage")) as? EditTimerViewController else { return }
        popover.contentViewController = vc
    }
    
    //popover object
    fileprivate func initPopover() {
        popover = NSPopover()
        // Specify the popover's behavior.
        //Currently exits when the user clicks outside of the box
        //use "applicationDefined" instead to make it so that it only quits when the app says so
        //https://developer.apple.com/documentation/appkit/nspopover/behavior
        //https://developer.apple.com/documentation/appkit/nspopover/1533539-behavior
        popover?.behavior = .transient
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        initStatusItem()
        initPopover()
    }
    
}
