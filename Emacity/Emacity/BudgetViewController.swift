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
        super.viewDidLoad()
        
        budgetModel = BudgetModel()
        
        getPayCheckStatus()
        updateView()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        getPayCheckStatus()
        updateView()
    }
   
    private func getPayCheckStatus() {
        if (budgetModel?.isPayCheckCurrent())! {
            addPayCheckButton.isHidden = true
        } else {
            addPayCheckButton.isHidden = false
        }
    }
    
    // Updates all the labels and progress bar on the view
    private func updateView() {
        updateMoneyRemainingAndProgress()
        updateTimeRemaining()
    }
    
    private func updateMoneyRemainingAndProgress() {
        if let (valueRemaining, progressPercentage) = budgetModel?.getRemainingBudgetAndProgress() {
            let moneyText = currencyFormatter.string(from: valueRemaining as NSNumber)!
            let percentText = numberFormatter.string(from: progressPercentage*100 as NSNumber)! + "% spent"
            
            moneyRemaining.text = moneyText
            budgetProgressBar.progress = Float(progressPercentage)
            percentOfBudgetUsed.text = percentText
        } else {
            moneyRemaining.text = currencyFormatter.string(from: 0)
            budgetProgressBar.progress = 1
            percentOfBudgetUsed.text = " "
        }
    }
    
    private func updateTimeRemaining() {
        if let dateComponents = budgetModel?.getTimeRemaining() {
            let days = String(dateComponents.day!)
            let hours = String(dateComponents.hour!)
            let minutes = String(dateComponents.minute!)
            
            var timeRemaining: String
            if days != "0" {
                timeRemaining = days + " days, " + hours + " hours til Pay Day!"
            } else {
                timeRemaining = hours + " hours, " + minutes + " minutes til Pay Day!"
            }
            
            
            timeTilNextPay.text = timeRemaining
        } else {
            timeTilNextPay.text = " "
        }
        
    }
    
    //formats number to allow decimal and only up to 2 decimal places
    let currencyFormatter: NumberFormatter = {
        let cf = NumberFormatter()
        cf.numberStyle = .currency
        cf.maximumSignificantDigits = 4
        cf.minimumFractionDigits = 2
        cf.maximumFractionDigits = 2
        
        return cf
    }()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
}
