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
    override func viewDidLoad() {
        
        var transactions = [Transaction]()
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            transactions = searchResults
            for t in transactions {
                print("Category: \(t.category?.name ?? "No Category"), SubCategory: \(t.subCategory?.name ?? "No SubCategory"), Amount: \(t.amount) Date: \(t.date!)")
            }
            
        } catch  {
            print("Error: \(error)")
        }
    }
}
