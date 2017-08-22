//
//  AddDebitViewController.swift
//  Emacity
//
//  Created by Davis Barber on 9/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class AddDebitViewController: UIViewController {
    
    @IBOutlet var subCategoryPickerView: UIPickerView!
    @IBOutlet var amountPickerView: UIPickerView!
    @IBOutlet var backgorundImageView: UIImageView!
    
    var subCategoryPicker: SubCategoryPickerView!
    var dollarsPicker: DollarsPickerView!
    
    var categoryName: String? {
        didSet {
            navigationItem.title = categoryName
        }
    }
    var subCategories = [SubCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search database for subcategories connected to categoryName category,
        // populate subCategoryPickerView with subCategories
        fetchSubCategories()
        // Setup subCategoryPickerView and amountPickerView
        subCategoryPicker = SubCategoryPickerView()
        subCategoryPicker.subCategories = subCategories
        dollarsPicker = DollarsPickerView()
        
        subCategoryPickerView.dataSource = subCategoryPicker
        subCategoryPickerView.delegate = subCategoryPicker
        amountPickerView.dataSource = dollarsPicker
        amountPickerView.delegate = dollarsPicker
        
        backgorundImageView.image = UIImage(named: categoryName!)
    }
    
    @IBAction func addTransactionButton(_ sender: UIButton) {
        // Add transaction to database under subCategory and amount picked
        let dollars = amountPickerView.selectedRow(inComponent: 0)
        let cents = amountPickerView.selectedRow(inComponent: 1) * 5
        
        let transaction: Transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: Database.getContext()) as! Transaction
        transaction.amount = Double(dollars) + Double(cents)/100
        transaction.date = NSDate()
        let selectedRow = subCategoryPickerView.selectedRow(inComponent: 0)
        transaction.subCategory = subCategories[selectedRow]
        transaction.category = subCategories[selectedRow].category
        
        Database.saveContext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchSubCategories() {
        let fetchRequest: NSFetchRequest<SubCategory> = SubCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category.name == %@", categoryName!)
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            subCategories = searchResults
            
        } catch  {
            print("Error: \(error)")
        }
    }
    
    

    

    /*
    // MARK: - Navigation
     
    // segue back to BudgetViewController once transaction is added and update budget
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
