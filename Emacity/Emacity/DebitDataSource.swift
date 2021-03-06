//
//  DebitDataSource.swift
//  Emacity
//
//  Created by Davis Barber on 18/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import Foundation
import UIKit

class DebitDataSource: NSObject, UICollectionViewDataSource {
    
    var categories = [Category]()
    
    // MARK: UICollectionViewDataSource
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebitCollectionViewCell", for: indexPath) as! DebitCollectionViewCell
        
        // Configure the cell
        let categoryName = categories[indexPath.row].name
        if let image = UIImage(named: categoryName!) {
            cell.imageView.image = image
        } else {
            cell.imageView.image = nil
        }
        cell.categoryLabel.text = categoryName
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
}
