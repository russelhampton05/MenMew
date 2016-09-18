//
//  MainMenuViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/17/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit


class MainMenuViewController: UITableViewController {

    
    @IBOutlet var openButton: UIBarButtonItem!
    
    
    
    var categoryArray: [(name: String, desc: String)] = [(name: "Breakfast", desc: "The best way to start your day."), (name: "Lunch", desc: "Dine in with our delectable entrees."), (name: "Specials", desc: "Our signature dishes."), (name: "Drinks", desc: "Refresh youself.")]
    var restaurant: String?
    @IBOutlet weak var restaurantLabel: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantLabel.title = restaurant
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(("MenuCell")) as UITableViewCell!
        
        cell.textLabel!.text = categoryArray[indexPath.row].name
        cell.detailTextLabel!.text = categoryArray[indexPath.row].desc
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func  numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
