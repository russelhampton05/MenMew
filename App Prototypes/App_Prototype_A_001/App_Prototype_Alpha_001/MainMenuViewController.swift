//
//  MainMenuViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/17/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Foundation


class MainMenuViewController: UITableViewController{
    var segueIndex: Int?
    var test: String = ""
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var ordersButton: UIBarButtonItem!
    
    var orderArray: [(title: String, price: Double)] = []
    let transition = CircleTransition()
    var menuArray = [[MenuItem]]()
    var categoryArray = [(name: String, desc: String)]()
    var restaurant: String?
    
    @IBOutlet weak var restaurantLabel: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantLabel.title = restaurant
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if orderArray.count > 0 {
            ordersButton.isEnabled = true
        }
        else {
            ordersButton.isEnabled = false
        }
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("MenuCell")) as UITableViewCell!
        
        cell?.textLabel!.text = categoryArray[(indexPath as NSIndexPath).row].name
        cell?.detailTextLabel!.text = categoryArray[(indexPath as NSIndexPath).row].desc
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = bgView
        cell?.textLabel?.highlightedTextColor = self.view.backgroundColor
        cell?.detailTextLabel?.highlightedTextColor = self.view.backgroundColor
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = (indexPath as NSIndexPath).row
        self.performSegue(withIdentifier: "CategoryDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetailSegue" {
            let menuVC = segue.destination as! MenuDetailsViewController
            
            menuVC.categoryTitle = categoryArray[segueIndex!].name
            menuVC.menuArray = menuArray[segueIndex!]
            menuVC.orderArray = orderArray
            menuVC.categoryArray = categoryArray
            menuVC.fullMenu = menuArray
            menuVC.restaurantName = restaurant!
        }
        else if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController
            
            settingsVC.orderArray = orderArray
        }
        else if segue.identifier == "OrderSummarySegue" {
            let orderVC = segue.destination as! SummaryViewController
            
            orderVC.orderArray = orderArray
        }
    }
    
    func reloadDetails(){
        if let settingsVCX = self.revealViewController() {
            print("test")
        }
    }
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? MenuDetailsViewController {
            orderArray = sourceVC.orderArray!
        }
    }

    @IBAction func ordersButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "OrderSummarySegue", sender: self)
    }
}
