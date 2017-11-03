//
//  SummaryViewController.swift
//  Emacity
//
//  Created by Davis Barber on 11/10/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {

    @IBOutlet var totalSavingsLabel: UILabel!
    @IBOutlet var percentOfGoalLabel: UILabel!
    
    @IBOutlet var addToGoalsButton: UIButton!
    @IBOutlet var addToNextPayButton: UIButton!
    @IBOutlet var extraSavingsButton: UIButton!
    
    var extraSavings: Double = 0
    
    var budgetModel: BudgetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let addedGoals = UserDefaults.standard.value(forKey: "addedSavingsToGoals") as? Bool,
            let addedToNextPay = UserDefaults.standard.value(forKey: "addedToNextPay") as? Bool {
            if addedGoals || addedToNextPay {
                disableExtraSavingsButton()
            }
        }
    }
    

    private func setupView() {
        if let payCheck = (budgetModel?.currentPayCheck?.amount) {
            totalSavingsLabel.text = currencyFormatter.string(from: payCheck as NSNumber)
            let totalSavings = (budgetModel?.getTotalSavings())!
            totalSavingsLabel.text = currencyFormatter.string(from: totalSavings as NSNumber)
            
            let goalPercent = budgetModel?.getGoalPercentSaved()
            let goalPercentString = currencyFormatter.string(from: goalPercent! as NSNumber)
            percentOfGoalLabel.text = goalPercentString! + "% of Goal"
            if goalPercent! < 100.0 {
                percentOfGoalLabel.textColor = UIColor(red: 200/255, green: 42/255, blue: 44/255, alpha: 1)
                extraSavingsButton.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            
            (extraSavings, _) = (budgetModel?.getRemainingBudgetAndProgress())!
            let extraSavingsString = currencyFormatter.string(from: extraSavings as NSNumber)
            extraSavingsButton.setTitle("Extra Savings: " + extraSavingsString!, for: .normal)
            
            addToGoalsButton.isHidden = true
            addToNextPayButton.isHidden = true
        } 
        
    }
    
    private func disableExtraSavingsButton() {
        addToGoalsButton.isHidden = true
        addToNextPayButton.isHidden = true
        extraSavingsButton.isEnabled = false
        extraSavingsButton.alpha = CGFloat(0.5)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func extraSavingsButton(_ sender: UIButton) {
        if addToGoalsButton.isHidden && addToNextPayButton.isHidden {
            addToGoalsButton.isHidden = false
            addToNextPayButton.isHidden = false
        } else {
            addToGoalsButton.isHidden = true
            addToNextPayButton.isHidden = true
        }
    }
    
    @IBAction func addToNextPayButton(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "addedToNextPay")
        disableExtraSavingsButton()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "addToGoals"?:
            let selectGoalsVC = segue.destination as? SelectGoalsTableViewController
            selectGoalsVC?.extraSavings = extraSavings
        case "nextPayCheck"?:
            let addPayCheckVC = segue.destination as? AddPayCheckViewController
            addPayCheckVC?.budgetModel = budgetModel
        default:
            preconditionFailure("Unexpected Segue Identifier")
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
