//
//  SettingsTableViewController.swift
//  Emacity
//
//  Created by Davis Barber on 29/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

 
    @IBOutlet var salaryTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet var salaryCell: UITableViewCell!
    @IBOutlet var payDayLabel: UILabel!
    @IBOutlet var payPeriodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    private func updateSettings() {
        if let salaryType = UserDefaults.standard.value(forKey: "salaryType") as? String {
            if salaryType == "Hourly" {
                salaryTypeSegmentedControl.selectedSegmentIndex = 1
                salaryCell.isUserInteractionEnabled = false
            } else {
                salaryTypeSegmentedControl.selectedSegmentIndex = 0
                salaryCell.isUserInteractionEnabled = true
                
            }
        }
        
        if let payDay = UserDefaults.standard.value(forKey: "payDay") as? String,
            let payPeriod = UserDefaults.standard.value(forKey: "payPeriod") as? String {
            payDayLabel.text = payDay
            payPeriodLabel.text = payPeriod
        }
    }
    @IBAction func salarySCChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.setValue("Fixed", forKey: "salaryType")
            salaryCell.isUserInteractionEnabled = true
        } else {
            UserDefaults.standard.setValue("Hourly", forKey: "salaryType")
            salaryCell.isUserInteractionEnabled = false
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "payDaySegue"?:
            let options = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
            
            let destinationVC = segue.destination as! ChooseSettingTableViewController
            destinationVC.settingTitle = "Pay Day"
            destinationVC.settingName = "payDay"
            destinationVC.options = options
            destinationVC.currentSetting = payDayLabel.text
        case "payPeriodSegue"?:
            let options = ["Weekly", "Bi-Monthly", "Monthly"]
            
            let destinationVC = segue.destination as! ChooseSettingTableViewController
            destinationVC.settingTitle = "Pay Period"
            destinationVC.settingName = "payPeriod"
            destinationVC.options = options
            destinationVC.currentSetting = payPeriodLabel.text
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
        
    }
    
    

}
