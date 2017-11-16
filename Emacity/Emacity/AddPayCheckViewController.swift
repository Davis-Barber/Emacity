//
//  AddPayCheckViewController.swift
//  Emacity
//
//  Created by Davis Barber on 31/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class AddPayCheckViewController: UIViewController, AddPayCheckDelegate {

    
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    
    
    var firstPayCheck: Bool {
        if budgetModel == nil {
            return true
        } else {
            return false
        }
    }
    var budgetModel: BudgetModel?
    
    var startDate: Date? {
        didSet {
            startDateLabel.text = dateFormatter.string(from: startDate!)
        }
    }
    var endDate: Date? {
        didSet {
            endDateLabel.text = dateFormatter.string(from: endDate!)
        }
    }
    
    var nextPayExtra = 0.0
    
    @IBOutlet var payCheckTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let date = Date()
        if firstPayCheck {
            startDate = calendar.startOfDay(for: date)
            endDate = calendar.date(byAdding: .day, value: 7, to: startDate!)
        } else {
            startDate = budgetModel?.endDate
            //startDate = budgetModel?.currentPayCheck?.endDate as Date?
            let days = (budgetModel?.payPeriodDays)!
            endDate = calendar.date(byAdding: .day, value: Int(days), to: startDate!)
        }
    }
    
    @IBAction func addPayCheck(_ sender: UIBarButtonItem) {
        if let payCheckAmount = Double(payCheckTextField.text!) {
            
            // adds your target savings for pay period to goals
            if !firstPayCheck {
                addSavingsToGoals()
            }
            
            // If added extra savings to goals
            if let addToGoals = UserDefaults.standard.value(forKey: "addedSavingsToGoals") as? Bool{
                if addToGoals {
                    let (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
                    let selectedGoals = UserDefaults.standard.value(forKey: "selectedGoalIndexes") as? [Int]
                    addExtraSavingsToGoals(amount: extraSavings, for: selectedGoals!)
                    UserDefaults.standard.setValue(false, forKey: "addedSavingsToGoals")
                }
            }
            
            // If added extra savings to next pay
            if let addToNextPay = UserDefaults.standard.value(forKey: "addedToNextPay") as? Bool {
                if addToNextPay {
                    let (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
                    nextPayExtra += extraSavings
                    UserDefaults.standard.setValue(false, forKey: "addedToNextPay")
                }
            }
            
            // update payPeriodLength
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            let interval = calendar.dateComponents([.day], from: startDate!, to: endDate!)
            UserDefaults.standard.setValue(Double(interval.day!), forKey: "payPeriodLength")
            
            
            // Create new PayCheck
            let payCheck: PayCheck = NSEntityDescription.insertNewObject(forEntityName: "PayCheck", into: Database.getContext()) as! PayCheck
            payCheck.amount = payCheckAmount + nextPayExtra
            payCheck.date = startDate! as NSDate
            payCheck.endDate = endDate! as NSDate
            Database.saveContext()
            UserDefaults.standard.setValue(true, forKey: "NewUpdate")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // needs to be recursive
    private func addExtraSavingsToGoals(amount extraSavings: Double, for indexes: [Int]) {
        var selectedGoalIndexes = indexes
        let selectedGoalsCount = indexes.count
        
        let amountPerGoal = extraSavings / Double(selectedGoalsCount)
        let goals = budgetModel?.goals
        
        var excessMoney = 0.0
        
        for index in indexes {
            let goal = goals?[index]
            // if amount per goal will complete the goal
            let amountRemaining = (goal?.amountRemaining)!
            if amountRemaining <= amountPerGoal {
                // complete goal
                goal?.amountRemaining = 0.0
                goal?.isCompleted = true
                // keep track of excess money
                let extra = amountPerGoal - amountRemaining
                excessMoney += extra
                // remove goal from index list
                selectedGoalIndexes.remove(at: index)
            } else {
                goal?.amountRemaining -= amountPerGoal
            }
        }
        
        if excessMoney != 0.0 {
            if selectedGoalIndexes.count != 0 {
                // run function again until no excess money remaining
                addExtraSavingsToGoals(amount: excessMoney, for: selectedGoalIndexes)
            } else {
                // all goals are complete that were selected
                // so add to next pay instead
                nextPayExtra += excessMoney
            }
        }
        UserDefaults.standard.setValue(true, forKey: "GoalUpdate")
    }
    
    // Need to add conditions for not saving enough and goal priorities
    private func addSavingsToGoals() {
        let (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
        let totalSavings = (budgetModel?.getTotalSavings())!
        
        if extraSavings >= 0 {
            // Saved enough money for all goals
            for goal in (budgetModel?.goals)! {
                let cost = budgetModel?.getGoalCostForPayPeriod(for: goal)
                goal.amountRemaining -= cost!
                if goal.amountRemaining == 0 {
                    goal.isCompleted = true
                }
            }
        } else {
            // Didnt save total goal for pay period
            if totalSavings >= 0 {
                // Didnt save enough money but still saved some
                var remainingSavings = totalSavings
                
                for goal in (budgetModel?.goals)! {
                    if goal.isNearlyComplete {
                        let cost = budgetModel?.getGoalCostForPayPeriod(for: goal)
                        goal.amountRemaining -= cost!
                        remainingSavings -= cost!
                        if goal.amountRemaining == 0 {
                            goal.isCompleted = true
                        }
                    }
                }
                // Start adding to goals in order of priority
                var priority = 0
                while remainingSavings > 0  {
                    if let goal = budgetModel?.goals[priority] {
                        if !goal.isNearlyComplete {
                            let cost = budgetModel?.getGoalCostForPayPeriod(for: goal)
                            goal.amountRemaining -= cost!
                            remainingSavings -= cost!
                            priority += 1
                        }
                    }
                }
                if remainingSavings <= 0 {
                    nextPayExtra += remainingSavings
                }
                
            } else {
                // Spent all of paycheck and need to take money from next pay
                nextPayExtra += totalSavings
            }
        }
        
    
    }
    
    private func getPayDay() -> Date {
        let payDay = UserDefaults.standard.value(forKey: "payDay") as? String
        var weekday = 0
        switch payDay {
        case "Sunday"?:
            weekday = 1
        case "Monday"?:
            weekday = 2
        case "Tuesday"?:
            weekday = 3
        case "Wednesday"?:
            weekday = 4
        case "Thursday"?:
            weekday = 5
        case "Friday"?:
            weekday = 6
        case "Saturday"?:
            weekday = 7
        default:
            break
        }
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var date = Date()
        
        var currentWeekday = calendar.component(.weekday, from: date)
        var count = 0
        while currentWeekday != weekday {
            count += 1
            currentWeekday -= 1
            if currentWeekday == 0 {
                currentWeekday = 7
            }
        }
        // rewind date to most recent payDay
        date = calendar.date(byAdding: .weekday, value: -count, to: date)!
        date = calendar.startOfDay(for: date)
        
        return date
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func updateDates(with start: Date, and end: Date) {
        startDate = start
        endDate = end
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "editPayPeriod"?:
            let editPayPeriodVC = segue.destination as? EditPayPeriodViewController
            editPayPeriodVC?.isFirstPay = firstPayCheck
            editPayPeriodVC?.startDate = startDate
            editPayPeriodVC?.endDate = endDate
            editPayPeriodVC?.delegate = self
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }

}


