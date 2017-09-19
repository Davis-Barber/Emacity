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
    @IBOutlet var payCheckTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPayCheck(_ sender: UIButton) {
        if let payCheckAmount = payCheckTextField.text {
            let payCheck: PayCheck = NSEntityDescription.insertNewObject(forEntityName: "PayCheck", into: Database.getContext()) as! PayCheck
            payCheck.amount = Double(payCheckAmount)!
            payCheck.date = getPayDay() as NSDate
            Database.saveContext()
            UserDefaults.standard.setValue(true, forKey: "NewUpdate")
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

}
