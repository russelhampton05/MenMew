//
//  RestaurantTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

var currentTicket: Ticket?

class RestaurantTableViewController: UITableViewController, SWRevealViewControllerDelegate {
    
    //IBOutlets
    @IBOutlet weak var menuButton: UIBarButtonItem!

    //Variables
    var restaurantArray: [Restaurant] = []
    var segueIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false

        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.hidesBackButton = true
        
        menuButton.target = self.revealViewController()
        self.revealViewController().delegate = self
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //Load the assigned restaurants
        loadRestaurants()
        loadTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(_ animated: Bool) {

        loadTheme()
        tableView.reloadData()

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)

        cell.textLabel!.text = restaurantArray[(indexPath as NSIndexPath).row].title
        cell.detailTextLabel!.text = restaurantArray[(indexPath as NSIndexPath).row].location
        
        cell.backgroundColor = currentTheme!.primary!
        cell.textLabel!.textColor = currentTheme!.highlight!
        cell.detailTextLabel!.textColor = currentTheme!.highlight!
        
        //Interaction
        let bgView = UIView()
        bgView.backgroundColor = currentTheme!.highlight!
        cell.selectedBackgroundView = bgView
        cell.textLabel?.highlightedTextColor = currentTheme!.primary!
        cell.detailTextLabel?.highlightedTextColor = currentTheme!.primary!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = (indexPath as NSIndexPath).row
        performSegue(withIdentifier: "TableListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableListSegue" {
            let tableVC = segue.destination as! RTableTableViewController
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            tableVC.restaurant = restaurantArray[segueIndex!]
        }
    }

    func loadRestaurants() {
        //For now, load all restaurants
        var restaurantList: [String] = []
        for item in currentServer!.restaurants! {
            restaurantList.append(item)
        }
        
        RestaurantManager.GetRestaurant(ids: restaurantList) {
            restaurants in
            
            self.restaurantArray = restaurants
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTheme() {
        //Background and Tint
        self.view.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
        
        //Navigation
        UINavigationBar.appearance().backgroundColor = currentTheme!.primary!
        UINavigationBar.appearance().tintColor = currentTheme!.highlight!
        self.navigationController?.navigationBar.barTintColor = currentTheme!.primary!
        self.navigationController?.navigationBar.tintColor = currentTheme!.highlight!
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: currentTheme!.highlight!, NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)]
    }
}
