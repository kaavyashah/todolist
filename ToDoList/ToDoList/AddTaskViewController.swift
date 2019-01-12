//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Kaavya Shah on 1/4/19.
//  Copyright © 2019 Kaavya Shah. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate: class {
    func addTaskViewControllerDidCancel(_ controller: AddTaskViewController)
    func addTaskViewController(_ controller: AddTaskViewController, didFinishAdding task: TaskItem)
    func addTaskViewController(_ controller: AddTaskViewController, didFinishEditing task: TaskItem)
}

class AddTaskViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: AddTaskViewControllerDelegate?
    var taskToEdit: TaskItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = taskToEdit {
            title = "Edit Task"
            taskField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    @IBAction func cancel() {
        delegate?.addTaskViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let taskToEdit = taskToEdit {
            taskToEdit.text = taskField.text!
            delegate?.addTaskViewController(self, didFinishEditing: taskToEdit)
        } else {
        let task = TaskItem()
        task.text = taskField.text!
        task.checked = false
        
        delegate?.addTaskViewController(self, didFinishAdding: task)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
