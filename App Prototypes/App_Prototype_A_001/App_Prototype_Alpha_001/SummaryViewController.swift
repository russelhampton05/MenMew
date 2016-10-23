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
    
  //  var orderArray: [(title: String, price: Double)] = []
    var total: Double = 0.0
    var ticket: Ticket? //if those blows up just do ticket = Ticket() in the did load
    var tax: Double = 0.0
    var runningTotal: Double = 0.0
    //tax rate really should be pulled from the DB! For now this is fine.
    let taxRate: Double = 0.12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeueLight", size: 12) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
        }
        
        delay(0.1){
            self.calculateTax()
            self.calculateRunningTotal()
        }
    }
    
    //Load summary details in table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = self.ticket?.itemsOrdered?[(indexPath as NSIndexPath).row].title
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let price = cell.viewWithTag(2) as! UILabel
        var priceHolder = self.ticket?.itemsOrdered?[(indexPath as NSIndexPath).row].price
        price.text = "\(priceHolder)"
        
       
        
        
        total += priceHolder!
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ticket?.itemsOrdered?.count)!    }
    
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
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindMenu", sender: self)
        //usermanager.submitTicket(user ID ticket ID)
    }
}
