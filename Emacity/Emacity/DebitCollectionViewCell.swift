//
//  DebitCollectionViewCell.swift
//  Emacity
//
//  Created by Davis Barber on 18/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit

class DebitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    
    func update(with label: String) {
        categoryLabel.text = label
    }
}
