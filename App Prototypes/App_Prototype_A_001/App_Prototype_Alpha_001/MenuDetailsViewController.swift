//
//  MenuDetailsViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/11/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class MenuDetailsViewController: UITableViewController {
    
    var orderArray: [(title: String, price: String)]?
    var selectedIndexPath : NSIndexPath?
    var ordered: Bool = false
    
    //Can load data directly from the parent menu (which loads from JSON)
    var menuArray: [MenuItem]?
    var categoryTitle: String?
    var restaurantName: String?
    
    @IBOutlet var categoryLabel: UINavigationItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet var backButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeue", size: 12) {
           UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }	

        categoryLabel.title = categoryTitle!
        
        if orderArray!.count > 0 && ordered == false {
            doneButton.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return only one section (1 copy of table)
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    //Populate table with cells and their data
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MenuCell
        
        cell.foodTitle.text = menuArray![indexPath.row].title
        cell.foodPrice.text = "$" + menuArray![indexPath.row].price
        cell.foodDesc.text = menuArray![indexPath.row].desc
        cell.foodImage.image = UIImage(named: menuArray![indexPath.row].image)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray!.count
    }

    //Check for selected items in the table via index paths
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        
        else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //Enable the cell to observe frame change
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! MenuCell).watchFrameChanges()
    }
    
    //Disable the cell to observe frame change
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! MenuCell).ignoreFrameChanges()
    }
    
    //Return the cell's height based on the selected index
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return MenuCell.expandedHeight
        }
        else {
            return MenuCell.normalHeight
        }
    }
    
    //Display the popup confirmation modal
    @IBAction func addOrder(sender: AnyObject) {
        
        if doneButton.enabled == false {
            doneButton.enabled = true
        }
        
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Popup") as! PopupViewController
        
        addToOrder(menuArray![selectedIndexPath!.row].title, foodPrice: menuArray![selectedIndexPath!.row].price)
        
        confirmPopup.menuItem = menuArray![selectedIndexPath!.row].title
        self.addChildViewController(confirmPopup)
        confirmPopup.view.frame = self.view.frame
        confirmPopup.view.frame.origin.y = tableView.contentOffset.y
        self.view.addSubview(confirmPopup.view)
        confirmPopup.didMoveToParentViewController(self)
        confirmPopup.orderAddMessage()
        
        tableView.scrollEnabled = false
    }
    
    //Add the order to a summary array
    func addToOrder(foodTitle: String, foodPrice: String) {
        orderArray! += [(title: foodTitle, price: foodPrice)]
    }
    
    //Segue on Done button press
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmOrder" {
            let summaryTable = segue.destinationViewController as! SummaryViewController
            
            summaryTable.orderArray = orderArray!
        }
        else if segue.identifier == "ReturnMainSegue" {
            let mainVC = segue.destinationViewController as! MainMenuViewController
            
            mainVC.reloadDetails(orderArray!, sourceRestaurant: restaurantName!)
        }
    }

    //Back Button for Unwind Segue to Main Menu
    @IBAction func backButtonPressed(sender: AnyObject) {
        for i in 0...menuArray!.count-1 {
            let cell = tableView.visibleCells[i] as! MenuCell
            cell.ignoreFrameChanges()
        }   
        
        self.performSegueWithIdentifier("ReturnMainSegue", sender: self)
    }
    
    //Unwind Segue for Order Summary
    @IBAction func unwindToMenuDetails(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? OrderConfirmationViewController {
            orderArray = sourceVC.orderArray!
            doneButton.enabled = false
        }
        else if let sourceVC = sender.sourceViewController as? SummaryViewController {
            orderArray = sourceVC.orderArray
            doneButton.enabled = false
        }
    }
    
}


