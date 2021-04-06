//
//  TimerQueueManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Foundation

class TimerQueueManager{
    var numAdded = 0
    var futureTaskDictionary = Dictionary<String, TimerObject>()
    private var completedTaskDictionary = Dictionary<String, TimerObject>()
    
    func createNewTask(duration: String, title: String){
        print("adding" + String(numAdded) + "item")
        let durationInt = Int(duration)!
        futureTaskDictionary[title] = TimerObject(lengthSec: durationInt, title: title, orderNum: numAdded, active: false)
        numAdded += 1
    }
    
    //returns string with all the names of the timers in the Dictionary
    //"no timers created" if empty
    func getCurrentTimers() -> String{
        var timers = ""
        for (_, task) in futureTaskDictionary {
            print("printing item")
            timers += task.getTitle() + "       "
            timers += String(task.getLengthSec()) + "\n"
        }
        print(timers)
        print("printed timers")
        if (timers == ""){
            return "No timers"
        }
        return timers
    }
    
    func findFirstTimer() -> TimerObject{
        var returnedTimer = TimerObject(lengthSec: 0, title: "void", orderNum: 100, active: false)
        for (_, task) in futureTaskDictionary {
            if (task.getOrderNum() == 0){
                returnedTimer = task
            }
        }
        return returnedTimer
    }

    
    func setToActive(activeTimer: TimerObject) -> TimerObject{
        return TimerObject(lengthSec: activeTimer.getLengthSec(), title: activeTimer.getTitle(), orderNum: 0, active: true)
    }
 
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = TimerQueueManager()

    
}


