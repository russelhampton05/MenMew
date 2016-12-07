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
    @IBOutlet weak var personaTab: UITableViewCell!
    @IBOutlet weak var profileTab: UITableViewCell!
    @IBOutlet weak var ordersTab: UITableViewCell!
    @IBOutlet weak var settingsTab: UITableViewCell!
    @IBOutlet weak var logoutTab: UITableViewCell!
    
    //Variables
    var restaurantName: String?
    var didLogout: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if didLogout {
            loadPage()
            didLogout = false
        }
    }
    
    func loadPage()
    {
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
        loadCells()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.restaurantName = self.restaurantName!
        }
        if segue.identifier == "SummarySegue" {
            
            let orderVC = segue.destination as! OrderSummaryViewController
            
            orderVC.ticket = currentUser!.ticket
            
        }
        if segue.identifier == "UnwindToLoginSegue" {
            didLogout = true
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    //Unwind Segue
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? ProfileViewController {	
            
            if sourceVC.newImageURL != nil {
                currentUser!.image = sourceVC.newImageURL!
                profilePhoto.image = nil
                profilePhoto.getImage(urlString: currentUser!.image!, circle: false)
            }
        }
        else if sender.source is AppSettingsViewController {
            reloadTheme()
        }
    }
    
    func reloadTheme() {
        
        let delay = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.loadTheme()
                self.loadCells()
            })
            
        }
    }
    
    func loadCells() {
        let bgView = UIView()
        
        if currentTheme!.name! == "Salmon" {
            bgView.backgroundColor = currentTheme!.primary!
        }
        else {
            bgView.backgroundColor = currentTheme!.highlight!
        }
        
        ordersTab.selectedBackgroundView = bgView
        profileTab.selectedBackgroundView = bgView
        settingsTab.selectedBackgroundView = bgView
        
        if currentTheme!.name! == "Salmon" {
            ordersTab.textLabel?.highlightedTextColor = currentTheme!.highlight!
            profileTab.textLabel?.highlightedTextColor = currentTheme!.highlight!
            settingsTab.textLabel?.highlightedTextColor = currentTheme!.highlight!
            logoutTab.textLabel?.highlightedTextColor = currentTheme!.highlight!
        }
        else {
            ordersTab.textLabel?.highlightedTextColor = currentTheme!.primary!
            profileTab.textLabel?.highlightedTextColor = currentTheme!.primary!
            settingsTab.textLabel?.highlightedTextColor = currentTheme!.primary!
            logoutTab.textLabel?.highlightedTextColor = currentTheme!.primary!
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.invert!
        self.tableView.backgroundColor = currentTheme!.secondary!
        
        if currentTheme!.name! == "Midnight" || currentTheme!.name! == "Slate" {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        else {
            UIApplication.shared.statusBarStyle = .default
        }
        
        
        //Labels
        nameLabel.textColor = currentTheme!.invert!
        locationLabel.textColor = currentTheme!.invert!
        ordersTab.textLabel?.textColor = currentTheme!.invert!
        profileTab.textLabel?.textColor = currentTheme!.invert!
        settingsTab.textLabel?.textColor = currentTheme!.invert!
        logoutTab.textLabel?.textColor = currentTheme!.invert!
        
        //Cells
        personaTab.backgroundColor = currentTheme!.secondary!
        profileTab.backgroundColor = currentTheme!.secondary!
        ordersTab.backgroundColor = currentTheme!.secondary!
        settingsTab.backgroundColor = currentTheme!.secondary!
        logoutTab.backgroundColor = currentTheme!.secondary!
    }
}
