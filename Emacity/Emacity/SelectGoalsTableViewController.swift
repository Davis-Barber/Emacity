//
//  SelectGoalsTableViewController.swift
//  Emacity
//
//  Created by Davis Barber on 11/10/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class SelectGoalsTableViewController: UITableViewController {
    
    var goals: [Goal]?
    var extraSavings: Double?

    @IBOutlet var selectAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.separatorColor = UIColor(white: 1, alpha: 0.5)
        tableView.allowsMultipleSelection = true
        
        updateGoals()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGoals() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            goals = searchResults
        } catch  {
            print("Error: \(error)")
        }
    }
    
    
     @IBAction func selectAllButtonPressed(_ sender: UIButton) {

        if sender.currentTitle == "Select All" {
            for section in 0..<tableView.numberOfSections {
                for row in 0..<tableView.numberOfRows(inSection: section) {
                    tableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
                }
            }
            navigationItem.rightBarButtonItem?.isEnabled = true
            selectAllButton.setTitle("Deselect All", for: .normal)
        } else {
            for row in 0 ..< tableView.numberOfRows(inSection: 0) {
                let goalIndexPath = IndexPath(row: row, section: 0)
                self.tableView.deselectRow(at: goalIndexPath, animated: true)
            }
            navigationItem.rightBarButtonItem?.isEnabled = false
            sender.setTitle("Select All", for: .normal)
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    @IBAction func addSavingsToSelectedGoals(_ sender: UIBarButtonItem) {
        let selectedGoalsIndexes = tableView.indexPathsForSelectedRows
       // var selectedGoals = [Goal]()
        var goalIndexes = [Int]()
        for index in selectedGoalsIndexes! {
            goalIndexes.append(index.row)
        }
        
        UserDefaults.standard.setValue(true, forKey: "addedSavingsToGoals")
        UserDefaults.standard.setValue(true, forKey: "GoalUpdate")
        UserDefaults.standard.setValue(goalIndexes, forKey: "selectedGoalIndexes")
        
        navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goals?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as! GoalTableViewCell
        
        let goal: Goal = goals![indexPath.row]
        
        cell.updateCell(with: goal.name!,
                        totalAmount: goal.totalAmount,
                        amountRaised: goal.totalAmount - goal.amountRemaining,
                        completionDate: goal.completionDate! as Date,
                        priority: goal.priority)
        
        
        if goal.isNearlyComplete {
            cell.dateLabel.text = "Completed"
            cell.isUserInteractionEnabled = false
        }
        // Configure the cell...
        cell.tintColor = UIColor(red: 127/255, green: 186/255, blue: 243/255, alpha: 1)
        
        return cell

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
