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
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var personaTab: UITableViewCell!
    @IBOutlet weak var profileTab: UITableViewCell!
    @IBOutlet weak var ordersTab: UITableViewCell!
    @IBOutlet weak var settingsTab: UITableViewCell!
    
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
            profilePhoto.getImage(urlString: currentUser!.image!, circle: false)
        }
        
        loadTheme()
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
            
            if sourceVC.newImageURL != nil {
                currentUser!.image = sourceVC.newImageURL!
                profilePhoto.image = nil
                profilePhoto.getImage(urlString: currentUser!.image!, circle: true)
            }
            tableView.reloadData()
            
            if let rightVC = self.revealViewController().rightViewController as? MainMenuViewController {
                rightVC.loadTheme()
            }
            
            loadTheme()
        }
        else if let sourceVC = sender.source as? OrderSummaryViewController {
            
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.invert!
        self.tableView.backgroundColor = currentTheme!.secondary!
        
        //Labels
        nameLabel.textColor = currentTheme!.invert!
        locationLabel.textColor = currentTheme!.invert!
        profileLabel.textColor = currentTheme!.invert!
        ordersLabel.textColor = currentTheme!.invert!
        settingsLabel.textColor = currentTheme!.invert!
        
        //Cells
        personaTab.backgroundColor = currentTheme!.secondary!
        profileTab.backgroundColor = currentTheme!.secondary!
        ordersTab.backgroundColor = currentTheme!.secondary!
        settingsTab.backgroundColor = currentTheme!.secondary!

    }
}
