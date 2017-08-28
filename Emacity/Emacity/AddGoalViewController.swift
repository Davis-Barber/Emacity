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
    @IBOutlet var costPerDayLabel: UILabel!
    
    var priority: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        priority = 0
        costPerDayLabel.text = ""
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
            goal.amountRaised = 0
            goal.completionDate = completionDatePicker.date as NSDate
            goal.priority = priority
            Database.saveContext()
        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func priorityStepper(_ sender: UIStepper) {
        priority = sender.value
        switch priority {
        case 0:
            priorityLabel.text = "Low"
        case 1:
            priorityLabel.text = "Med"
        case 2:
            priorityLabel.text = "High"
        default:
            break
        }
        
    }
    @IBAction func finishedEditingCost(_ sender: customTextField) {
        updateCostPerDay()
    }

    @IBAction func dateChanged(_ sender: Any) {
        updateCostPerDay()
    }
    
    private func updateCostPerDay() {
        // Get Duration of Goal
        let startDate = Date()
        let endDate = completionDatePicker.date
        var dateInterval: DateInterval!
        if startDate < endDate {
            dateInterval = DateInterval(start: startDate, end: endDate)
        } else {
            return
        }
        
        let numberOfDays = Double(dateInterval.duration / (60*60*24))
        
        print(numberOfDays)
        
        // Get Cost of Goal
        let cost = Double(costTextField.text!) ?? 0

        let costPerDay = numberFormatter.string(from: cost/numberOfDays as NSNumber)
        
        
        costPerDayLabel.text = "$\(costPerDay ?? "0") per Day"
        
        
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
    //formats number to allow decimal and only one decimal place
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
}


