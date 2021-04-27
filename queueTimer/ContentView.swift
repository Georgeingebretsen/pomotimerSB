//
//  ContentView.swift
//  queueTimer
//
//  Created by George Ingebretsen on 2/22/21.
//

import SwiftUI

struct ContentView: View {
    @State var isPopoverPresented = false
    @State var timerTitle = ""
    @State var timerDuration = ""
    @State var textToUpdate = "(Empty)"
    @State var timerIsActive = false;
    @State var startButtonText = "Start"
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var timer: Timer? = nil
    var mainQueueClass = TimerQueueManager()
    var body: some View {
        if(timerIsActive){
            Text("Active timer" + "\n" + textToUpdate)
        }
        Text("Current timer queue:" + "\n" + textToUpdate)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        Button("New Timer") {
            self.isPopoverPresented = true
        }
        Text("\(hours):\(minutes):\(seconds)")
        .popover(isPresented: $isPopoverPresented) {
            Text("New timer")
            .font(.largeTitle)
            .frame(width: 300, height: 300, alignment: .center)
            VStack{
                TextField(
                    "Title",
                    text: $timerTitle)
                TextField(
                    "Duration (min)",
                    text: $timerDuration)
            }
            Button("Done") {
                mainQueueClass.createNewTask(duration: timerDuration, title: timerTitle)
                self.textToUpdate = mainQueueClass.getCurrentTimers()
                timerTitle = ""
                timerDuration = ""
                self.isPopoverPresented = false
            }
        }
        if(mainQueueClass.getCurrentTimers() != ""){
            Button(startButtonText) {
                timerIsActive.toggle();
                if(timerIsActive){
                    startButtonText = "stop"
                    let newActiveTimer = mainQueueClass.setToActive(activeTimer: mainQueueClass.findFirstTimer())
                    let time = newActiveTimer.getLengthSec()
                    print(time)
                    self.seconds = time
                    print(seconds)
                    print("arrived at Start Timer")
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
                        self.seconds = self.seconds - 1
                        if(self.seconds == 0){
                            stopTimer()
                            startButtonText = "start"
                            timerIsActive.toggle();
                        }
                    }
                }else{
                    startButtonText = "start"
                    stopTimer()
                }
                
            }
            
        }
    }
    
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
