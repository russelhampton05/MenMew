//
//  SummaryViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/13/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class SummaryViewController : UITableViewController {
    
    @IBOutlet weak var taxValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    var orderArray: [(title: String, price: String)] = []
    var total: Double = 0.0
    var tax: Double = 0.0
    var runningTotal: Double = 0.0
    let taxRate: Double = 0.12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeueLight", size: 12) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
    }
    
    //Load summary details in table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell") as! SummaryCell
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = orderArray[indexPath.row].title
        
        let price = cell.viewWithTag(2) as! UILabel
        price.text = "$" + orderArray[indexPath.row].price
        
        if let currPrice = Double(orderArray[indexPath.row].price) {
            total += currPrice
        }
        
        calculateTax()
        calculateRunningTotal()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
        
    }
    
    //Calculate added tax
    func calculateTax() {
        tax = total*taxRate
        
        taxValue.text = "$" + String(tax)
    }
    
    //Calculate running total of all orders
    func calculateRunningTotal() {
        runningTotal = total + tax
        
        totalValue.text = "$" + String(runningTotal)
    }
    
    //Cancel all orders
    @IBAction func cancelOrders(sender: AnyObject) {
        let cancelPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("orderCancelID") as! PopupViewController
        
        //Enable the cancel button on popup
        cancelPopup.cancelOrder = true
        
        self.addChildViewController(cancelPopup)
        cancelPopup.view.frame = self.view.frame
        cancelPopup.view.frame.origin.y = tableView.contentOffset.y
        self.view.addSubview(cancelPopup.view)
        cancelPopup.didMoveToParentViewController(self)
        cancelPopup.orderCancelMessage()
        
        
        tableView.scrollEnabled = false
    }
}
