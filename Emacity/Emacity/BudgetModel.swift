//
//  BudgetModel.swift
//  Emacity
//
//  Created by Davis Barber on 21/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import Foundation
import CoreData

class BudgetModel {
    
    var currentPayCheck: PayCheck?
    var endDate: Date?
    var budgetChanged = false
    var payCheckIsCurrent = false
    
    func isPayCheckCurrent() -> Bool{
        let date = Date()
        // Fetch most recent pay check
        let fetchRequest: NSFetchRequest<PayCheck> = PayCheck.fetchRequest()
        // Sort by date and only fetch most recent paycheck
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            // If there is no paycheck
            if searchResults.count == 0 {
                payCheckIsCurrent = false
            } else {
                currentPayCheck = searchResults[0]
                // Check if paycheck is current
                getEndDate()
                if date > endDate! {
                    // Paycheck isn't current so show addPaycheckButton
                    payCheckIsCurrent = false
                    
                }
                // Paycheck is valid so hide addPaycheckButton
                payCheckIsCurrent = true
                
            }
            
        } catch  {
            print("Error: \(error)")
        }
        
        return payCheckIsCurrent
    }
    
    
    
    // Creates a time interval based on chosen payPeriod in settings
    func getPayInterval() -> TimeInterval {
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
    
    func getEndDate() {
        if let startDate = currentPayCheck?.date as Date? {
            endDate = Date(timeInterval: getPayInterval(), since: startDate)
        } else {
            endDate = nil
        }
    }

    
}
