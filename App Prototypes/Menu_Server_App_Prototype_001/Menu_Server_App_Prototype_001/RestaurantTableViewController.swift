//
//  RestaurantTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //Dummy Data
    var restaurantArray: [(name: String, location: String)] = [(name: "RJ's Steakhouse", location: "Spring, TX"), (name: "P.F. Chang's", location: "Houston, TX"), (name: "Cafe 101", location: "University of Houston, TX")]
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

        cell.textLabel!.text = restaurantArray[(indexPath as NSIndexPath).row].name
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
            
            tableVC.restaurant = restaurantArray[segueIndex!].name
            tableVC.location = restaurantArray[segueIndex!].location
        }
    }
}
