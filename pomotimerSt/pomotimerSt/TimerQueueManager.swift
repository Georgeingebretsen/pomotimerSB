//
//  TimerQueueManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Foundation

class TimerQueueManager{
    var currentTimeRemaining = 0
    var timerIsPaused = false
    var futureTaskDictionary = Dictionary<Int, TimerObject>()
    
    func createNewTask(duration: String, title: String){
        let durationInt = Int(duration) ?? 0
        //I use futureTaskDictionary.count to find what the next int should be, because my dictionary is zero indexed.
        //.count will give me the the next integer I need to use
        futureTaskDictionary[futureTaskDictionary.count] = TimerObject(lengthSec: durationInt, title: title)
    }
    
    func removeTimer(cellToRemove: Int) {

        // keep a reference to the current dictionary
        let prevTasks = futureTaskDictionary;
        let prevTaskCount = prevTasks.count;

        // create a new dictionary (this will become the defacto data store with the item removed)
        var newTasks = Dictionary<Int, TimerObject>()
                
        // iterate through the prevTasks and all items except the one to be removed
        var prevTaskIndex = 0
        var newTaskIndex = 0
        while (prevTaskIndex < prevTaskCount) {
            
            if (prevTaskIndex != cellToRemove) {
                let task = prevTasks[prevTaskIndex];
                newTasks[newTaskIndex] = TimerObject(lengthSec: task?.getLengthSec() ??  0, title: task?.getTitle() ?? "")
                newTaskIndex += 1
            }
            
            prevTaskIndex += 1
        }
        

        
        // update reference to use new dictionary
        futureTaskDictionary = newTasks;
    }
//
//    func removeTimer(cellToRemove: Int){
//        print("before remove timer:")
//        print(futureTaskDictionary)
//
//        var prevData = futureTaskDictionary;
//        prevData[cellToRemove] = nil
//
//
//        //change all of the cells orderNum tag to represent their new position
//        var newTaskDictionary = Dictionary<Int, TimerObject>()
//
//
//        let prevDataCount = prevData.count
//
//        var prevDataIndex = 0
//        var newTaskIndex = 0
//
//        while(prevDataIndex <= prevDataCount){
//
//
//            if(prevData[prevDataIndex] != nil){
//                newTaskDictionary[newTaskIndex] = prevData[prevDataIndex]
//                newTaskIndex += 1
//            }
//            prevDataIndex += 1
//        }
//        futureTaskDictionary = newTaskDictionary
//
//        print("after remove timer:")
//        print(futureTaskDictionary)
//    }
    
    func findFirstTimer() -> TimerObject{
        return futureTaskDictionary[0]!
    }
    
    func getTimeRemaining() -> Int{
        return currentTimeRemaining
    }
    
    func changeTimeRemaining(timeRemaining: Int){
        currentTimeRemaining = timeRemaining
    }
    
    func resetTasks(){
        futureTaskDictionary.removeAll(keepingCapacity: false)
    }
    
    func resetValues(){
        currentTimeRemaining = 0
        timerIsPaused = false
    }
 
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = TimerQueueManager()

    
}


