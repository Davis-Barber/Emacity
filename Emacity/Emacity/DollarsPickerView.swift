//
//  DollarsPickerView.swift
//  Emacity
//
//  Created by Davis Barber on 20/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit

class DollarsPickerView: UIPickerView {
    
}

extension DollarsPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 1000
        } else {
            return 20
        }
    }
}

extension DollarsPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row < 1 && component == 1{
            return NSAttributedString(string: "0\(row*5)", attributes: [NSForegroundColorAttributeName : UIColor.white])

        } else if component == 1{
            return NSAttributedString(string: String(row*5), attributes: [NSForegroundColorAttributeName : UIColor.white])
        } else {
            return NSAttributedString(string: String(row), attributes: [NSForegroundColorAttributeName : UIColor.white])

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    
}
