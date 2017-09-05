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
    
    var budgetModel: BudgetModel?
    
    override func viewDidLoad() {
        budgetModel = BudgetModel()
        
        getPayCheckStatus()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getPayCheckStatus()
    }
   
    private func getPayCheckStatus() {
        if (budgetModel?.isPayCheckCurrent())! {
            addPayCheckButton.isHidden = true
        } else {
            addPayCheckButton.isHidden = false
        }
    }
    
    
}
