//
//  AddGoalViewController.swift
//  Emacity
//
//  Created by Davis Barber on 22/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class AddGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: customTextField!
    @IBOutlet var costTextField: customTextField!
    @IBOutlet var completionDatePicker: UIDatePicker!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var priorityStepper: UIStepper!
    @IBOutlet var costPerDayLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var addGoalButton: UIButton!
    
    var editGoal: Goal?
    
    var priority: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        
    }
    
    // ***** need to add condition for changing cost that would be below amount raised ******
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        if let name = nameTextField.text,
            let cost = Double(costTextField.text!) {
            editGoal?.name = name
            let previousCost = editGoal?.totalAmount
            let costChange = cost - previousCost!
            let amountRemaining = editGoal?.amountRemaining
            editGoal?.amountRemaining = amountRemaining! + costChange
            editGoal?.totalAmount = cost
            editGoal?.completionDate = completionDatePicker.date as NSDate
            editGoal?.priority = priority
            Database.saveContext()
            editGoal = nil
            UserDefaults.standard.setValue(true, forKey: "NewUpdate")
            UserDefaults.standard.setValue(true, forKey: "GoalUpdate")

            navigationController?.popToRootViewController(animated: true)
        }
    }
    private func setupView() {
        if let goal = editGoal {
            addGoalButton.isHidden = true
            addGoalButton.isEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 106/255, green: 227/255, blue: 104/255, alpha: 1)
            nameTextField.text = goal.name
            costTextField.text = String(describing: goal.totalAmount)
            priority = goal.priority
            
            completionDatePicker.date = (goal.completionDate as Date?)!
            
            updateCostPerDayLabel()
        } else {
            addGoalButton.isHidden = false
            addGoalButton.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            costPerDayLabel.text = ""
        }
        completionDatePicker.minimumDate = Date()
        completionDatePicker.setValue(UIColor.white, forKey: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addGoalButton(_ sender: UIButton) {
        if let name = nameTextField.text,
            let cost = Double(costTextField.text!) {
            let goal: Goal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: Database.getContext()) as! Goal
            goal.name = name
            goal.totalAmount = cost
            goal.amountRemaining = cost
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            let date = Date()
            goal.startDate = calendar.startOfDay(for: date) as NSDate
            goal.completionDate = completionDatePicker.date as NSDate
            goal.isCompleted = false
            goal.isNearlyComplete = false
            goal.priority = priority
            Database.saveContext()
            UserDefaults.standard.setValue(true, forKey: "NewUpdate")
            UserDefaults.standard.setValue(true, forKey: "GoalUpdate")

        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }


    
    
    @IBAction func finishedEditingCost(_ sender: customTextField) {
        updateCostPerDayLabel()
    }

    @IBAction func dateChanged(_ sender: Any) {
        updateCostPerDayLabel()
    }
    
    // *** Need to add condition for edit goal, needs to get cost from startDate or startdate of pay check and
    // use amount remaining not total amount
    private func updateCostPerDay() -> String {
        // Get Duration of Goal
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let date = Date()
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.startOfDay(for: completionDatePicker.date)
        var dateInterval: DateInterval!
        if startDate < endDate {
            dateInterval = DateInterval(start: startDate, end: endDate)
        } else {
            return "0"
        }
        
        let numberOfDays = Double(dateInterval.duration / (60*60*24))
        
        print(numberOfDays)
        
        // Get Cost of Goal
        let cost = Double(costTextField.text!) ?? 0

        let costPerDay = numberFormatter.string(from: cost/numberOfDays as NSNumber)
        
        return costPerDay!
    }
    
    private func updateCostPerDayLabel() {
        costPerDayLabel.text = "$\(updateCostPerDay()) per Day"
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //formats number to allow decimal and only up to 2 decimal places
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
}


