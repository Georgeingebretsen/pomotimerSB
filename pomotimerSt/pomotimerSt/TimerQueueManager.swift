//
//  TimerQueueManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 3/29/21.
//

import Foundation

class TimerQueueManager{
    private var currentTimeRemaining = 0
    var futureTaskDictionary = Dictionary<Int, TimerObject>()
    
    func createNewTask(duration: String, title: String){
        let durationInt = Int(duration) ?? 0
        //I use futureTaskDictionary.count to find what the next int should be, because my dictionary is zero indexed.
        //.count will give me the the next integer I need to use
        futureTaskDictionary[futureTaskDictionary.count] = TimerObject(lengthSec: durationInt, title: title)
    }
    
    func findFirstTimer() -> TimerObject{
        return futureTaskDictionary[0]!
    }
    
    //strategy newDic
    func removeTimer(cellToRemove: Int){
        print("before remove timer:")
        print(futureTaskDictionary)
            
        futureTaskDictionary[cellToRemove] = nil
        //change all of the cells orderNum tag to represent their new position
        var newTaskDictionary = Dictionary<Int, TimerObject>()
        let dicCount = futureTaskDictionary.count
        var futureDicIndex = 0
        var newTaskIndex = 0
        while(futureDicIndex <= dicCount){
            if(futureTaskDictionary[futureDicIndex] != nil){
                newTaskDictionary[newTaskIndex] = futureTaskDictionary[futureDicIndex]
                newTaskIndex += 1
            }
            futureDicIndex += 1
        }
        futureTaskDictionary = newTaskDictionary
        
        print("after remove timer:")
        print(futureTaskDictionary)
    }
    
    func resetTasks(){
        futureTaskDictionary.removeAll(keepingCapacity: true)
    }
    
    func changeTimeRemaining(timeRemaining: Int){
        currentTimeRemaining = timeRemaining
    }
    
    func getTimeRemaining() -> Int{
        return currentTimeRemaining
    }
    
    func isEmptyValues() -> Bool{
        for(index,_) in futureTaskDictionary{
            if(String(index) == ""){
                return true
            }
        }
        return false
    }
 
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = TimerQueueManager()

    
}


