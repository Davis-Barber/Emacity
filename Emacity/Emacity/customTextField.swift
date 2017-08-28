//
//  customTextField.swift
//  Emacity
//
//  Created by Davis Barber on 22/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit

class customTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        backgroundColor = UIColor.darkGray
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        return super.resignFirstResponder()
    }

}
