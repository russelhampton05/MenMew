//
//  SettingsViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/20/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    //IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    //Variables
    var restaurantName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = currentUser!.name
        
        MenuManager.GetMenu(id: currentUser!.ticket!.restaurant_ID!) {
            menu in
            
            self.locationLabel.text = "At " + menu.title!
            self.restaurantName = menu.title!
        }
        
        if currentUser!.image != nil {
            profilePhoto.getImage(urlString: currentUser!.image!, circle: true)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.restaurantName = self.restaurantName!
        }
        if segue.identifier == "SummarySegue" {
            
            let orderVC = segue.destination as! OrderSummaryViewController
            
            orderVC.ticket = currentUser!.ticket
            
        }
    }
    
    //Unwind Segue
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? ProfileViewController {
            currentUser!.image = sourceVC.newImageURL!

            if currentUser!.image != nil {
                profilePhoto.image = nil
                profilePhoto.getImage(urlString: currentUser!.image!, circle: true)
            }
            tableView.reloadData()
        }
        else if let sourceVC = sender.source as? OrderSummaryViewController {
            
        }
    }
}
