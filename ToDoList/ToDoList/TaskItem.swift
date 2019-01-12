//
//  TaskItem.swift
//  ToDoList
//
//  Created by Kaavya Shah on 1/4/19.
//  Copyright © 2019 Kaavya Shah. All rights reserved.
//

import Foundation

class TaskItem: NSObject, Codable {
    
    //what the tas says to do
    var text = ""
    
    //if it has been done
    var checked = false
    
    //if the task is checked and then touched we want it to be unchecked, vice versa
    func toggleCheck() {
        checked = !checked
    }
}
