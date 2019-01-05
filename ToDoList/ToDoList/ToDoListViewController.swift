//
//  ViewController.swift
//  ToDoList
//
//  Created by Kaavya Shah on 1/4/19.
//  Copyright © 2019 Kaavya Shah. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var tasks: [TaskItem]
    
    required init?(coder aDecoder: NSCoder) {
        tasks = [TaskItem]()
        
        let row0task = TaskItem()
        row0task.text = "walk the dog"
        row0task.checked = false
        tasks.append(row0task)
        
        let row1task = TaskItem()
        row1task.text = "cook dinner"
        row1task.checked = true
        tasks.append(row1task)
        
        let row2task = TaskItem()
        row2task.text = "go to class"
        row2task.checked = true
        tasks.append(row2task)
        
        let row3task = TaskItem()
        row3task.text = "learn to code"
        row3task.checked = false
        tasks.append(row3task)
        
        let row4task = TaskItem()
        row4task.text = "apply to stuff"
        row4task.checked = false
        tasks.append(row4task)
        
        let row5task = TaskItem()
        row5task.text = "take a nap"
        row5task.checked = false
        tasks.append(row5task)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //gives the number of items in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //shows the correct cell when called and returns the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieves a tableview cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItem", for: indexPath)
        
        //retrieves the task
        let task = tasks[indexPath.row]
        
        configureText(for: cell, with: task)
        configureCheckmark(for: cell, with: task)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let task = tasks[indexPath.row]
            task.toggleCheck()
            
            configureCheckmark(for: cell, with: task)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        
        //put it in a list because the deleteRows function needs an array
        let indexPaths = [indexPath]
        
        //delete the selected rows
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    //makes the text for the cell visible
    func configureText(for cell: UITableViewCell, with task: TaskItem) {
        let label = cell.viewWithTag(11) as! UILabel
        label.text = task.text
    }
    
    //either shows or does not show the checkmark
    func configureCheckmark(for cell: UITableViewCell, with task: TaskItem) {
        if task.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

