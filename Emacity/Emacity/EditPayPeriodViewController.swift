//
//  EditPayPeriodViewController.swift
//  Emacity
//
//  Created by Davis Barber on 23/10/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

protocol AddPayCheckDelegate: NSObjectProtocol {
    func updateDates(with start: Date, and end: Date)
}

class EditPayPeriodViewController: UIViewController {
    
    weak var delegate: AddPayCheckDelegate?

    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDatePicker: UIDatePicker!
    
    var startDate: Date?
    var endDate: Date?
    
    var isFirstPay: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        endDatePicker.date = endDate!
        
        if isFirstPay! {
            startDateLabel.isHidden = true
            startDatePicker.date = startDate!
        } else {
            startDatePicker.isHidden = true
            startDateLabel.text = dateFormatter.string(from: startDate!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // save new dates
        if isFirstPay! {
            delegate?.updateDates(with: startDatePicker.date, and: endDatePicker.date)
        } else {
            delegate?.updateDates(with: startDate!, and: endDatePicker.date)
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
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }
}
