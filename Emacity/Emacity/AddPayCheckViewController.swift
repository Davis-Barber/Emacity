//
//  AddPayCheckViewController.swift
//  Emacity
//
//  Created by Davis Barber on 31/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class AddPayCheckViewController: UIViewController {
    
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
        if var payCheckAmount = Double(payCheckTextField.text!) {
            
            // adds your target savings for pay period to goals
            if !firstPayCheck {
                addSavingsToGoals()
            }
            
            // If added extra savings to goals
            if let addToGoals = UserDefaults.standard.value(forKey: "addedSavingsToGoals") as? Bool{
                if addToGoals {
                    addExtraSavingsToGoals()
                    UserDefaults.standard.setValue(false, forKey: "addedSavingsToGoals")
                }
            }
            
            // If added extra savings to next pay
            if let addToNextPay = UserDefaults.standard.value(forKey: "addedToNextPay") as? Bool {
                if addToNextPay {
                    let (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
                    payCheckAmount += extraSavings
                    UserDefaults.standard.setValue(false, forKey: "addedToNextPay")
                }
            }
            
            // Create new PayCheck
            let payCheck: PayCheck = NSEntityDescription.insertNewObject(forEntityName: "PayCheck", into: Database.getContext()) as! PayCheck
            payCheck.amount = payCheckAmount
            payCheck.date = startDate! as NSDate
            payCheck.endDate = endDate! as NSDate
            Database.saveContext()
            UserDefaults.standard.setValue(true, forKey: "NewUpdate")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func addExtraSavingsToGoals() {
        let selectedGoalIndexes = UserDefaults.standard.value(forKey: "selectedGoalIndexes") as? [Int]
        let selectedGoalsCount = (selectedGoalIndexes?.count)!
        let (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
        let amountPerGoal = extraSavings / Double(selectedGoalsCount)
        let goals = budgetModel?.goals
        for index in selectedGoalIndexes! {
            let goal = goals?[index]
            goal?.amountRemaining -= amountPerGoal
        }
        UserDefaults.standard.setValue(true, forKey: "GoalUpdate")
    }
    
    // Need to add conditions for not saving enough and goal priorities
    private func addSavingsToGoals() {
        for goal in (budgetModel?.goals)! {
            let cost = budgetModel?.getGoalCostForPayPeriod(for: goal)
            goal.amountRemaining -= cost!
            if goal.amountRemaining == 0 {
                goal.isCompleted = true
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }

}
