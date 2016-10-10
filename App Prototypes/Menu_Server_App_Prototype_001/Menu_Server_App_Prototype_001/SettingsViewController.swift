//
//  SettingsViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/20/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var orderArray: [(title: String, price: Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileViewController
            
        }
        if segue.identifier == "OrderSegue" {
            //let orderVC = segue.destination as! SummaryViewController
            
            //orderVC.orderArray = orderArray
        }
    }
    
    //Unwind Segue
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? ProfileViewController {
    
        }
    }
   
}
