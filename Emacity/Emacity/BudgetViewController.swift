//
//  BudgetViewController.swift
//  Emacity
//
//  Created by Davis Barber on 9/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController {
    
    @IBOutlet var moneyRemaining: UILabel!
    @IBOutlet var timeTilNextPay: UILabel!
    @IBOutlet var percentOfBudgetUsed: UILabel!
    @IBOutlet var budgetProgressBar: UIProgressView!
    @IBOutlet var addPayCheckButton: UIButton!
    
    var currentPayCheck: PayCheck?
    
    override func viewDidLoad() {
        
        isPayCheckCurrent()
       
    }
    
    private func isPayCheckCurrent() {
        let payTimeInterval = getPayInterval()
        let date = Date()
        // Fetch most recent pay check
        let fetchRequest: NSFetchRequest<PayCheck> = PayCheck.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            if searchResults.count == 0 {
                addPayCheckButton.isHidden = false
            } else {
                currentPayCheck = searchResults[0]
                let endDate = Date(timeInterval: payTimeInterval, since: (currentPayCheck?.date)! as Date)
                if date > endDate {
                    addPayCheckButton.isHidden = false
                }
            }
            
        } catch  {
            print("Error: \(error)")
        }
    }
    
    private func getPayInterval() -> TimeInterval {
        let payPeriod = UserDefaults.standard.value(forKey: "payPeriod") as? String
        var payTimeInterval: TimeInterval?
        switch payPeriod {
        case "Weekly"?:
            payTimeInterval = TimeInterval(7*24*60*60)
        case "Bi-Monthly"?:
            payTimeInterval = TimeInterval(14*24*60*60)
        case "Monthly"?:
            payTimeInterval = TimeInterval(28*24*60*60)
        default:
            break
        }
        return payTimeInterval!
    }
}
