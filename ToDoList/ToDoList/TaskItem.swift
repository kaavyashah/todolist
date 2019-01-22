//
//  TaskItem.swift
//  ToDoList
//
//  Created by Kaavya Shah on 1/4/19.
//  Copyright © 2019 Kaavya Shah. All rights reserved.
//

import Foundation
import UserNotifications

class TaskItem: NSObject, Codable {
    
    //what the tas says to do
    var text = ""
    
    //if it has been done
    var checked = false
    
    var dueDate = Date()
    
    //true if there should be a reminder/notification
    var reminder = false
    
    var taskID: Int
    
    
    //if the task is checked and then touched we want it to be unchecked, vice versa
    func toggleCheck() {
        checked = !checked
    }
    
    override init() {
        let userDefaults = UserDefaults.standard
        let taskID = userDefaults.integer(forKey: "TaskItemID")
        userDefaults.set(taskID + 1, forKey: "TaskItemID")
        userDefaults.synchronize()
//        taskID = nextTaskItemID()
        self.taskID = taskID
        super.init()
    }
    
    func nextTaskItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let taskID = userDefaults.integer(forKey: "TaskItemID")
        userDefaults.set(taskID + 1, forKey: "TaskItemID")
        userDefaults.synchronize()
        return taskID
    }
    
    func scheduleNotification() {
        if reminder && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(taskID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("scheduled: \(request) for taskID: \(taskID)")
        
        }
    }
    
}
