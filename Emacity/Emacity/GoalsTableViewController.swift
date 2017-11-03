//
//  GoalsTableViewController.swift
//  Emacity
//
//  Created by Davis Barber on 9/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class GoalsTableViewController: UITableViewController {
    
    var goals: [Goal]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.separatorColor = UIColor(white: 1, alpha: 0.5)
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = false
        
        navigationController?.navigationBar.tintColor =  UIColor(red: 127/255, green: 186/255, blue: 243/255, alpha: 1)

        
        updateGoals()
        self.tableView.reloadData()
        UserDefaults.standard.set(false, forKey: "GoalUpdate")

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let goalUpdate = UserDefaults.standard.value(forKey: "GoalUpdate") as? Bool {
            if goalUpdate {
                //Updating
                print("Updating View")
                updateGoals()
                self.tableView.reloadData()
                UserDefaults.standard.setValue(false, forKey: "GoalUpdate")

            }
        }
        
        if let payCheckIsCurrent = UserDefaults.standard.value(forKey: "isPayCheckCurrent") as? Bool {
            if payCheckIsCurrent {
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGoals() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "completionDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            goals = searchResults
        } catch  {
            print("Error: \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (goals?.count) ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as! GoalTableViewCell
        
        let goal: Goal = goals![indexPath.row]
        
        cell.updateCell(with: goal.name!,
                        totalAmount: goal.totalAmount,
                        amountRaised: goal.totalAmount - goal.amountRemaining,
                        completionDate: goal.completionDate! as Date,
                        priority: goal.priority)

        // Configure the cell...

        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the tableView is asking to commit a delete command
        if editingStyle == .delete {
            let goal = (goals?[indexPath.row])!
            
            let title = "Delete goal: '\(String(describing: goal.name))'?"
            let message = "Are you sure you want to delete this goal?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                // remove the goal
                Database.getContext().delete(goal)
                Database.saveContext()
                self.updateGoals()
                // Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "AddGoal"?:
            let addGoalViewController = segue.destination as! AddGoalViewController
            addGoalViewController.navigationController?.title = "Add Goal"
            
        case "EditGoal"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let goal = goals?[row]
                let editGoalVC = segue.destination as! AddGoalViewController
                editGoalVC.editGoal = goal
                editGoalVC.navigationController?.title = "Edit Goal"
             
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    

    

}
