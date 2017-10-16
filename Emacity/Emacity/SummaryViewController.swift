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
    
    var budgetModel: BudgetModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        let payCheck = (budgetModel?.currentPayCheck?.amount)!
        totalSavingsLabel.text = currencyFormatter.string(from: payCheck as NSNumber)
        let totalSavings = (budgetModel?.getTotalSavings())!
        totalSavingsLabel.text = currencyFormatter.string(from: totalSavings as NSNumber)
        
        let goalPercent = budgetModel?.getGoalPercentSaved()
        let goalPercentString = currencyFormatter.string(from: goalPercent! as NSNumber)
        percentOfGoalLabel.text = goalPercentString! + "% of Goal"
        
        addToGoalsButton.isHidden = true
        addToNextPayButton.isHidden = true
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
