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
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableLine: UIView!
    @IBOutlet var customerTitle: UILabel!
    @IBOutlet var dateTitle: UILabel!
    @IBOutlet var menuItemsTitle: UILabel!

    
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
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
        
        //Labels
        statusLabel.textColor = currentTheme!.highlight!
        tableNumLabel.textColor = currentTheme!.highlight!
        ticketLabel.textColor = currentTheme!.highlight!
        customerLabel.textColor = currentTheme!.highlight!
        dateLabel.textColor = currentTheme!.highlight!
        tableLine.backgroundColor = currentTheme!.highlight!
        customerTitle.textColor = currentTheme!.highlight!
        dateTitle.textColor = currentTheme!.highlight!
        menuItemsTitle.textColor = currentTheme!.highlight!
        
        //Buttons
        fulfillButton.backgroundColor = currentTheme!.highlight!
        fulfillButton.setTitleColor(currentTheme!.primary, for: .normal)
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
            
            cell.backgroundColor = currentTheme!.primary!
            cell.tintColor = currentTheme!.highlight!
            
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

        //Initiate popup
        let messagePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagePopup") as! MessagePopupViewController
        
        self.addChildViewController(messagePopup)
        self.view.addSubview(messagePopup.view)
        messagePopup.didMove(toParentViewController: self)
    }
    
    func getCustomer() {
        UserManager.GetUser(id: ticket!.user_ID!) {
            user in
            
            self.customerLabel.text = user.name!
        }
    }
    
    func sendMessage(message: String) {
        
        //Write the message
        MessageManager.WriteServerMessage(id: currentTicket!.message_ID!, message: message)
        
        //Hide the button to avoid spam
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.fulfillButton.isHidden = true
            self.messageLabel.isHidden = false
            
        })
        
        //Reinstate the help button after 10 seconds
        let delay = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: delay) {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.fulfillButton.isHidden = false
                self.messageLabel.isHidden = true
                
            })
            
        }
    }

}
