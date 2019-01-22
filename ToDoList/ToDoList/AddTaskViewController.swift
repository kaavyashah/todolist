//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Kaavya Shah on 1/4/19.
//  Copyright © 2019 Kaavya Shah. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddTaskViewControllerDelegate: class {
    func addTaskViewControllerDidCancel(_ controller: AddTaskViewController)
    func addTaskViewController(_ controller: AddTaskViewController, didFinishAdding task: TaskItem)
    func addTaskViewController(_ controller: AddTaskViewController, didFinishEditing task: TaskItem)
}

class AddTaskViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dueDate = Date()
    var dateChoiceShown = false
    weak var delegate: AddTaskViewControllerDelegate?
    var taskToEdit: TaskItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = taskToEdit {
            title = "Edit Task"
            taskField.text = item.text
            doneBarButton.isEnabled = true
            reminderSwitch.isOn = item.reminder
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    @IBAction func cancel() {
        delegate?.addTaskViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let taskToEdit = taskToEdit {
            taskToEdit.text = taskField.text!
            
            taskToEdit.reminder = reminderSwitch.isOn
            taskToEdit.dueDate = dueDate
            
            taskToEdit.scheduleNotification()
            delegate?.addTaskViewController(self, didFinishEditing: taskToEdit)
        } else {
        let task = TaskItem()
        task.text = taskField.text!
        task.checked = false
            
        task.reminder = reminderSwitch.isOn
        task.dueDate = dueDate
        
        task.scheduleNotification()
        delegate?.addTaskViewController(self, didFinishAdding: task)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //add if to work kwith keyboard, if keyboard isn't there just return nil
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    //opens keyboard immediately when app is run
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskField.becomeFirstResponder()
    }
    
    //gets rid of the Done button if you type and then erase
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }

    func showDateChoice() {
        dateChoiceShown = true
        
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    //add to show keyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
    }
    
    //also for keyboard
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && dateChoiceShown {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    //additionally for keyboard
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            showDateChoice()
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    @IBAction func changeDate(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemainToggled(_ switchControl: UISwitch) {
        taskField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
            }
            
        }
    }

}
