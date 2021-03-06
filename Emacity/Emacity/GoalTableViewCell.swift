//
//  GoalTableViewCell.swift
//  Emacity
//
//  Created by Davis Barber on 22/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet var goalLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var percentCompleteLabel: UILabel!
    
    var goal: Goal?
    
    func updateCell(with name: String, totalAmount: Double, amountRaised: Double, completionDate: Date, priority: Double) {
        goalLabel.text = name
        let goalAmount = numberFormatter.string(from: totalAmount as NSNumber)
        amountLabel.text = "$\(goalAmount!)"
        // Convert date to string
        dateLabel.text = dateFormatter.string(from: completionDate)
        let percent = amountRaised/totalAmount
        let percentString = numberFormatter.string(from: percent * 100.0 as NSNumber)
        percentCompleteLabel.text = percentString! + "%"
        priorityLabel.text = "\(Int(priority))"
        progressBar.progress = Float(amountRaised/totalAmount)
        
    }
    
    
    
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    //formats number to allow decimal and only one decimal place
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
}


