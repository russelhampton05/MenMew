//
//  TableDetailViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class TableDetailViewController: UIViewController {

    
    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var orderContainer: UIView!
    @IBOutlet weak var fulfillButton: UIButton!
    @IBOutlet var customerLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNumLabel.text = "Table #" + ticket!.tableNum!
        ticketLabel.text = "Ticket " + ticket!.desc!
        dateLabel.text = ticket!.timestamp!
        
        getCustomer()
        
        if ticket!.paid! {
            statusLabel.text = "Fulfilled"
            fulfillButton.isHidden = true
        }
        else if !(ticket!.paid!) {
            statusLabel.text = "Open"
            fulfillButton.isHidden = false
            fulfillButton.setTitle("Fulfill Order", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderTableSegue" {
            let orderVC = segue.destination as! OrderTableViewController
            
            orderVC.orderList = ticket!.itemsOrdered
        }
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
