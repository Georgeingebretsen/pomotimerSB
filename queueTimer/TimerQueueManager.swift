//
//  timerQueue.swift
//  queueTimer
//
//  Created by George Ingebretsen on 2/28/21.
//

import Foundation

class TimerQueueManager{
    private var numAdded = 0
    private var futureTaskDictionary = Dictionary<String, TimerObject>()
    private var completedTaskDictionary = Dictionary<String, TimerObject>()
    //returns string with all the names of the timers in the set
    //"no timers created" if empty
    func createNewTask(duration: String, title: String){
        let durationInt = Int(duration)!
        let newTask = TimerObject(lengthSec: durationInt, title: title, orderNum: numAdded, active: false)
        futureTaskDictionary[title] = newTask
    }
    
    func getCurrentTimers() -> String{
        var timers = ""
        for (_, task) in futureTaskDictionary {
            timers = timers + "\n" + task.getTitle()
        }
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
    

}
