//
//  SubCategoryPickerView.swift
//  Emacity
//
//  Created by Davis Barber on 20/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class SubCategoryPickerView: UIPickerView {

    var subCategories = [SubCategory]()

}

extension SubCategoryPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subCategories.count
    }
}

extension SubCategoryPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: subCategories[row].name!, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
}
