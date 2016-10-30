//
//  RestaurantTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
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
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //Load the assigned restaurants
        loadRestaurants()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgView
        cell.textLabel?.highlightedTextColor = self.view.backgroundColor
        cell.detailTextLabel?.highlightedTextColor = self.view.backgroundColor

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
}
