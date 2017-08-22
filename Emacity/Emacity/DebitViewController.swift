//
//  DebitViewController.swift
//  Emacity
//
//  Created by Davis Barber on 9/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData


class DebitViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let debitDataSource = DebitDataSource()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = debitDataSource
        collectionView.delegate = self
        
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            debitDataSource.categories = searchResults
            self.collectionView.reloadSections(IndexSet(integer: 0))
            
        } catch  {
            print("Error: \(error)")
        }
    }
    
    
    //func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    //}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "addTransaction"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let categoryName = debitDataSource.categories[selectedIndexPath.row].name
                
                let destinationVC = segue.destination as! AddDebitViewController
                destinationVC.categoryName = categoryName
            }
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
    }
    

    

    // MARK: UICollectionViewDelegate

}

extension DebitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.size.width
        let itemWidth = collectionViewWidth / 3
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    
}
