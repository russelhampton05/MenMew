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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var itemLabel: UILabel!
    
  //  var orderArray: [(title: String, price: Double)] = []
    var total: Double = 0.0
    var ticket: Ticket? //if those blows up just do ticket = Ticket() in the did load
    var tax: Double = 0.0
    var runningTotal: Double = 0.0
    var ticketsToRemove: [String] = []
    //tax rate really should be pulled from the DB! For now this is fine.
    let taxRate: Double = 0.12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeueLight", size: 12) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
        }
        
        self.confirmButton.isHidden = false
        self.cancelButton.isHidden = false
        
        delay(0.1){
            self.calculateTax()
            self.calculateRunningTotal()
        }
    }
    
    //Load summary details in table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
        
        if (ticket?.itemsOrdered?.count)! > 0 {
            let title = cell.viewWithTag(1) as! UILabel
            title.text = self.ticket?.itemsOrdered?[(indexPath as NSIndexPath).row].title
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let price = cell.viewWithTag(2) as! UILabel
            let priceHolder = self.ticket!.itemsOrdered![(indexPath as NSIndexPath).row].price!
            price.text = formatter.string(from: priceHolder as NSNumber)
            
            total += priceHolder
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ticket?.itemsOrdered?.count)! > 0 {
            return (ticket?.itemsOrdered?.count)!
        }
        else {
            return 0
        }
    }
    
    //Calculate added tax
    func calculateTax() {
        tax = total*taxRate
        
        taxValue.text = "$" + String(tax)
    }
    
    //Calculate running total of all orders
    func calculateRunningTotal() {
        runningTotal = total + tax
        
        totalValue.text = "$" + String(format: "%.2f", runningTotal)
    }
    
    //Update running total on item deletion
    func updateTotal(value: Double) {
        total -= value
        
        calculateTax()
        
        calculateRunningTotal()
        
        if runningTotal == 0 {
            self.confirmButton.isHidden = true
            self.cancelButton.isHidden = true
            
            itemLabel.text = "No items here. Order something!"
        }
    }
    
    //Edit functions
    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete the menu item in the ticket
            ticketsToRemove.append((ticket!.itemsOrdered?[indexPath.row].item_ID!)!)
            updateTotal(value: (ticket!.itemsOrdered?[indexPath.row].price)!)
            self.ticket!.itemsOrdered?.remove(at: indexPath.row)
            
            
            //Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    //Cancel all orders
    @IBAction func cancelOrders(_ sender: AnyObject) {
        let cancelPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(cancelPopup)
        cancelPopup.view.frame = self.view.frame
        cancelPopup.view.frame.origin.y = tableView.contentOffset.y
        self.view.addSubview(cancelPopup.view)
        cancelPopup.didMove(toParentViewController: self)
        cancelPopup.addMessage(context: "CancelMenuItems")
        ticket?.itemsOrdered?.removeAll()
        tableView.isScrollEnabled = false
    }
    
    func delay(_ time: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmOrderSegue" {
            let orderConfirmVC = segue.destination as! OrderConfirmationViewController
            
            orderConfirmVC.ticket = ticket
        }
        
    }
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        let n: Int! = self.navigationController?.viewControllers.count
        if self.navigationController!.viewControllers[n-2] is MenuDetailsViewController {
            performSegue(withIdentifier: "UnwindMenu", sender: self)
        }
        else if self.navigationController!.viewControllers[n-2] is MainMenuViewController {
            performSegue(withIdentifier: "UnwindMainMenu", sender: self)
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        
        //Submit the ticket
        UserManager.SetTicket(user: currentUser!, ticket: ticket!, toRemove: ticketsToRemove) {
            completed in

            if completed {
                self.performSegue(withIdentifier: "ConfirmOrderSegue", sender: self)
            }
            
        }
        
    }
}
