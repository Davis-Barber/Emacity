//
//  AddGoalViewController.swift
//  Emacity
//
//  Created by Davis Barber on 22/8/17.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

class AddGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: customTextField!
    
    @IBOutlet var costTextField: customTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
