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
    var selectedIndexPath : IndexPath?
    var ordered: Bool = false
    
    //Can load data directly from the parent menu (which loads from JSON)
    var menuArray: [MenuItem]?
    var fullMenu: [[MenuItem]]?
    var categoryArray = [(name: String, desc: String)]()
    var categoryTitle: String?
    var restaurantName: String?
    
    @IBOutlet var categoryLabel: UINavigationItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet var backButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeue", size: 12) {
           UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
        }	

        categoryLabel.title = categoryTitle!
        
        if orderArray!.count > 0 && ordered == false {
            doneButton.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return only one section (1 copy of table)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Populate table with cells and their data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MenuCell
        
        cell.foodTitle.text = menuArray![(indexPath as NSIndexPath).row].title
        cell.foodPrice.text = (NSString(format: "$%.2f", menuArray![(indexPath as NSIndexPath).row].price) as String)
        cell.foodDesc.text = menuArray![(indexPath as NSIndexPath).row].desc
        cell.foodImage.image = UIImage(named: menuArray![(indexPath as NSIndexPath).row].image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray!.count
    }

    //Check for selected items in the table via index paths
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        
        else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //Enable the cell to observe frame change
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MenuCell).watchFrameChanges()
    }
    
    //Disable the cell to observe frame change
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MenuCell).ignoreFrameChanges()
    }
    
    //Return the cell's height based on the selected index
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return MenuCell.expandedHeight
        }
        else {
            return MenuCell.normalHeight
        }
    }
    
    //Display the popup confirmation modal
    @IBAction func addOrder(_ sender: AnyObject) {
        
        if doneButton.isEnabled == false {
            doneButton.isEnabled = true
        }
        
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        addToOrder(menuArray![(selectedIndexPath! as NSIndexPath).row].title, foodPrice: String(menuArray![(selectedIndexPath! as NSIndexPath).row].price))
        
        confirmPopup.menuItem = menuArray![(selectedIndexPath! as NSIndexPath).row].title
        self.addChildViewController(confirmPopup)
        confirmPopup.view.frame = self.view.frame
        confirmPopup.view.frame.origin.y = tableView.contentOffset.y
        self.view.addSubview(confirmPopup.view)
        confirmPopup.didMove(toParentViewController: self)
        confirmPopup.orderAddMessage()
        
        tableView.isScrollEnabled = false
    }
    
    //Add the order to a summary array
    func addToOrder(_ foodTitle: String, foodPrice: String) {
        orderArray! += [(title: foodTitle, price: foodPrice)]
    }
    
    //Segues for Back and Done Button Presses
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmOrder" {
            let summaryTable = segue.destination as! SummaryViewController
            
            summaryTable.orderArray = orderArray!
        }
        else if segue.identifier == "ReturnMainSegue" {
            let mainVC = segue.destination as! MainMenuViewController
            mainVC.menuArray = fullMenu!
            mainVC.orderArray = orderArray!
            mainVC.categoryArray = categoryArray
            mainVC.restaurant = restaurantName!
            //mainVC.reloadDetails(orderArray!, sourceMenuArray: fullMenu!, sourceRestaurant: restaurantName!)
        }
    }

    //Back Button for Unwind Segue to Main Menu
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        for i in 0...menuArray!.count-1 {
            let cell = tableView.visibleCells[i] as! MenuCell
            cell.ignoreFrameChanges()
        }   
        
        self.performSegue(withIdentifier: "ReturnMainSegue", sender: self)
    }
    
    //Unwind Segue for Order Summary
    @IBAction func unwindToMenuDetails(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? OrderConfirmationViewController {
            orderArray = sourceVC.orderArray!
            doneButton.isEnabled = false
        }
        else if let sourceVC = sender.source as? SummaryViewController {
            orderArray = sourceVC.orderArray
            doneButton.isEnabled = false
        }
    }
    
}


