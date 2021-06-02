//
//  TimerQueueManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Foundation

class TimerQueueManager{
    var numAdded = 0
    private var currentTimeRemaining = 0
    var futureTaskDictionary = Dictionary<String, TimerObject>()
    var completedTaskDictionary = Dictionary<String, TimerObject>()
    
    func createNewTask(duration: String, title: String){
        let durationInt = Int(duration)!
        futureTaskDictionary[title] = TimerObject(lengthSec: durationInt, title: title, orderNum: numAdded, active: false)
        numAdded += 1
    }
    
    //returns string with all the names of the timers in the Dictionary
    //"no timers created" if empty
    func getCurrentTimers() -> String{
        var timers = ""
        var timersAdded = 0
        while(timersAdded < futureTaskDictionary.count){
            for (_, task) in futureTaskDictionary {
                if(task.getOrderNum() == timersAdded){
                    if(task.getTitle() != findFirstTimer().getTitle()){
                        timers += task.getTitle() + "       "
                        timers += String(task.getLengthSec()) + "\n"
                        timersAdded += 1;
                    }else{
                        timersAdded += 1;
                    }
                }
            }
        }
        if (timers == ""){
            return "No timers"
        }
        return timers
    }
    
    func findFirstTimer() -> TimerObject{
        var returnedTimer = TimerObject(lengthSec: 100, title: "void", orderNum: 0, active: false)
        for (_, task) in futureTaskDictionary {
            if (task.getOrderNum() == 0){
                returnedTimer = task
            }
        }
        return returnedTimer
    }
    
    func removeFirstTimer(){
        var firstTask = ""
        for (name, task) in futureTaskDictionary {
            if (task.getOrderNum() == 0){
                completedTaskDictionary [name] = task
                firstTask = name
            }
        }
        futureTaskDictionary[firstTask] = nil
        for (name, task) in futureTaskDictionary {
            futureTaskDictionary[name] = TimerObject(lengthSec: task.getLengthSec(), title: task.getTitle(), orderNum: task.getOrderNum()-1, active: false)
        }
    }
    
    func removeTimer(cellIdentifier: Int){
        //find the name of the cell we're removing
        var removeTaskName = ""
        for (name, task) in futureTaskDictionary {
            if (task.getOrderNum() == cellIdentifier){
                completedTaskDictionary [name] = task
                removeTaskName = name
            }
        }
        //change all of the other cells orderNum tag to represent their new position
        for (name, task) in futureTaskDictionary {
            if(task.getOrderNum() > futureTaskDictionary[removeTaskName]!.getOrderNum()){
                futureTaskDictionary[name] = TimerObject(lengthSec: task.getLengthSec(), title: task.getTitle(), orderNum: task.getOrderNum()-1, active: false)
            }
        }
        //finally remove the cell from the dictionary
        futureTaskDictionary[removeTaskName] = nil
    }
    
    func setToActive(activeTimer: TimerObject) -> TimerObject{
        return TimerObject(lengthSec: activeTimer.getLengthSec(), title: activeTimer.getTitle(), orderNum: 0, active: true)
    }
    
    func reset(){
        numAdded = 0
        futureTaskDictionary.removeAll(keepingCapacity: true)
        completedTaskDictionary.removeAll(keepingCapacity: true)
    }
    
    func changeTimeRemaining(timeRemaining: Int){
        currentTimeRemaining = timeRemaining
    }
    
    func getTimeRemaining() -> Int{
        return currentTimeRemaining
    }
 
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = TimerQueueManager()

    
}


