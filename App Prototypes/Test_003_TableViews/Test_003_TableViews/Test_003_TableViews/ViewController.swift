//
//  ViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/11/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var selectedIndexPath : NSIndexPath?

    //Source Tutorial: https://www.youtube.com/watch?v=jmYheiKJ_Wc
    //Can load data directly from the parent menu (which loads from JSON)
    var titleArray = ["New York Strip", "Meatloaf", "Salmon Steak", "Roast Chicken"]
    var priceArray = ["21.95", "18.50", "19.25", "22.15"]
    var imageArray = ["01", "02", "03", "04"]
    var descArray = ["Our best strip steak yet.", "Homemade goodness.", "Fresh Alaskan catch.", "Oven roasted to perfection."]
    
    var orderArray: [(title: String, price: String)] = []
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeue", size: 12) {
           UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        
        let imageThumb = cell.viewWithTag(1) as! UIImageView
        imageThumb.image = UIImage(named: imageArray[indexPath.row])
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = titleArray[indexPath.row]
        
        let price = cell.viewWithTag(3) as! UILabel
        price.text = "$" + priceArray[indexPath.row]
        
        let desc = cell.viewWithTag(4) as! UILabel
        desc.text = descArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
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
        doneButton.enabled = true
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("menuAddID") as! PopupViewController
        
        addToOrder(titleArray[selectedIndexPath!.row], foodPrice: priceArray[selectedIndexPath!.row])
        
        confirmPopup.menuItem = titleArray[selectedIndexPath!.row]
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
        orderArray += [(title: foodTitle, price: foodPrice)]
    }
    
    //Segue on Done button press
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmOrder" {
            let summaryTable: SummaryViewController = segue.destinationViewController as! SummaryViewController
            
            summaryTable.orderArray = orderArray
        }
    }
}


