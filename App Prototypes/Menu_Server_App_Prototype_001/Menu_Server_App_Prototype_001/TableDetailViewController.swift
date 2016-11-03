//
//  TableDetailViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class TableDetailViewController: UITableViewController {

    
    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var fulfillButton: UIButton!
    @IBOutlet var customerLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNumLabel.text = "TABLE #" + ticket!.tableNum!
        ticketLabel.text = "Ticket " + ticket!.desc!
        
        //Format date to more human-readable result
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = formatter.date(from: ticket!.timestamp!)
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dateLabel.text = formatter.string(from: currentDate!)
        

        getCustomer()
        
        if ticket!.paid! {
            statusLabel.text = "FULFILLED"
            fulfillButton.isHidden = true
        }
        else if !(ticket!.paid!) {
            statusLabel.text = "Open, " + ticket!.status!
            fulfillButton.isHidden = false
            fulfillButton.setTitle("Fulfill Order", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ticket!.itemsOrdered != nil {
            if ticket!.itemsOrdered!.count > 0 {
                
                    return ticket!.itemsOrdered!.count
            
            }
            else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        
        if ticket!.itemsOrdered != nil && ticket!.itemsOrdered!.count > 0 {
            cell.textLabel!.text = ticket!.itemsOrdered![indexPath.row].title
            
            let price = ticket!.itemsOrdered![indexPath.row].price!
            cell.detailTextLabel!.text = "$" + String(format: "%.2f", price)
        }
        else {
            cell.textLabel!.text = "No items ordered."
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
    
    
    @IBAction func fulfillButtonPressed(_ sender: AnyObject) {
        
        let fulfillPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(fulfillPopup)
        self.view.addSubview(fulfillPopup.view)
        fulfillPopup.didMove(toParentViewController: self)
        fulfillPopup.ticket = ticket!.desc
        fulfillPopup.addMessage(context: "FulfillOrder")
    }
    
    func getCustomer() {
        UserManager.GetUser(id: ticket!.user_ID!) {
            user in
            
            self.customerLabel.text = user.name!
        }
    }
}
