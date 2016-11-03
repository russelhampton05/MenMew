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
    
    var menu: Menu?
    var ticket: Ticket?
    var segueIndex: Int?
    

    //IBOutlets
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var ordersButton: UIBarButtonItem!
    @IBOutlet weak var restaurantLabel: UINavigationItem!
    
    //Variables
    var orderArray: [(title: String, price: Double)] = []
    let transition = CircleTransition()
    var currentTable: String?

    
    //@IBOutlet weak var restaurantLabel: UINavigationItem!

    var menuArray = [[MenuItem]]()
    var categoryArray = [(name: String, desc: String)]()
    var restaurant: String?
    //var segueIndex: Int?
    var test: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        restaurantLabel.title = menu?.title
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Check for existing orders
        if ticket != nil && ticket!.itemsOrdered!.count > 0 {
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
        
        cell?.textLabel!.text = menu?.menu_groups?[(indexPath as NSIndexPath).row].title
        cell?.detailTextLabel!.text = menu?.menu_groups?[(indexPath as NSIndexPath).row].desc

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
        //return categoryArray.count
        if menu?.menu_groups != nil {
            return (menu?.menu_groups?.count)!
        }
        else {
            return 0
        }
    }
    
    override func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetailSegue" {
            let menuVC = segue.destination as! MenuDetailsViewController
            menuVC.menu = menu!
            menuVC.menu_group = menu?.menu_groups![segueIndex!]
            menuVC.ticket = self.ticket
            menuVC.restaurantName = menu?.title
            menuVC.currentTable = self.currentTable!
        }
        else if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController
            
            settingsVC.ticket = ticket
        }
        else if segue.identifier == "OrderSummarySegue" {
            let orderVC = segue.destination as! SummaryViewController
            
            orderVC.ticket = ticket!
        }
    }
    
 
    //Unwind Segues
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = false
        
        if let sourceVC = sender.source as? MenuDetailsViewController {
            ticket = sourceVC.ticket
            
            if (ticket?.itemsOrdered?.count)! > 0 {
                ordersButton.isEnabled = true
            }
        }
        else if let sourceVC = sender.source as? OrderConfirmationViewController {
            ticket = sourceVC.ticket
            
            if (ticket?.itemsOrdered?.count)! > 0 {
                ordersButton.isEnabled = true
            }
        }
        else if let sourceVC = sender.source as? SummaryViewController {
            ticket = sourceVC.ticket
            
            ordersButton.isEnabled = false
        }
        else if let sourceVC = sender.source as? PaymentSummaryViewController {
            ticket = sourceVC.ticket
            
            if ticket!.paid! {
                ordersButton.isEnabled = false
                
                ticket = nil
            }
        }
    }

    @IBAction func ordersButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "OrderSummarySegue", sender: self)
    }
}
