//
//  TimerObject.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Foundation

struct TimerObject: Equatable, Hashable{
    //timer object variables
    private var lengthSec = 0
    private var timeRemainingSec = 0
    private var title = ""
    private var orderNum = 0
    private var active = false
    
    //runs when the class is instantiated. sets up the class variables
    init(lengthSec: Int, title: String, orderNum: Int, active: Bool) {
        self.lengthSec = lengthSec
        self.timeRemainingSec = lengthSec
        self.title = title
        self.orderNum = orderNum
        self.active = active
    }
 
    //getters
    func getLengthSec() -> Int{
        return lengthSec
    }
    
    func getTimeRemainingSec() -> Int{
        return timeRemainingSec
    }
    
    func getTitle() -> String{
        return title
    }
    
    func getOrderNum() -> Int{
        return orderNum
    }
    
    // makes hashable and equatable
    static func == (lhs: TimerObject, rhs: TimerObject) -> Bool {
        return lhs.getTitle() == rhs.getTitle() && lhs.getLengthSec() == rhs.getLengthSec()
    }
    
}
