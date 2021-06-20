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
    private var title = ""
    
    //runs when the class is instantiated. sets up the class variables
    init(lengthSec: Int, title: String) {
        self.lengthSec = lengthSec
        self.title = title
    }
 
    //getters
    func getLengthSec() -> Int{
        return lengthSec
    }
    
    func getTitle() -> String{
        return title
    }
    
    // makes hashable and equatable
    static func == (lhs: TimerObject, rhs: TimerObject) -> Bool {
        return lhs.getTitle() == rhs.getTitle() && lhs.getLengthSec() == rhs.getLengthSec()
    }
    
}
