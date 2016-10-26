//
//  TableDetailViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController {

    //Variables
    var ticket: Ticket?
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var customerContainer: UIView!
    @IBOutlet weak var orderContainer: UIView!
    @IBOutlet weak var fulfillButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNumLabel.text = "Table #" + ticket!.tableNum!
        ticketLabel.text = "Ticket " + ticket!.ticket_ID!
        
        if ticket!.paid! {
            statusLabel.text = "Fulfilled"
            fulfillButton.isHidden = true
        }
        else if !(ticket!.paid!) {
            statusLabel.text = "Open"
            fulfillButton.isHidden = false
            fulfillButton.setTitle("Fulfill Order", for: .normal)
        }

        //performSegue(withIdentifier: "CustomerTableSegue", sender: self)
        //performSegue(withIdentifier: "OrderTableSegue", sender: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerTableSegue" {
            let custVC = segue.destination as! CustomerTableViewController
            
            //custVC.customerList = ticket!.clientList
            
            //Call customers associated with ticket
            //Sample customer until ticket can hold values for users and items
            UserManager.GetUser(id: "S3Yyp2BRfSNCjgfW48hsS96B2Of1") {
                user in
                
                var userList: [String] = []
                userList.append(user.name!)
                custVC.customerList = userList
            }
        }
        else if segue.identifier == "OrderTableSegue" {
            let orderVC = segue.destination as! OrderTableViewController
            
            //orderVC.orderList = ticket!.orderList
            
            //Call items associated with ticket
            //Sample data
            var idList: [String] = []
            idList.append("ee3004f1cd774bba9afb9ab1c12dd567")
            MenuItemManager.GetMenuItem(ids: idList) {
                items in
                
                var orderList: [(name: String, price: Double)] = []
                for item in items {
                    orderList.append((name: item.desc!, price: item.price!))
                }
                
                orderVC.orderList = orderList
            }
        }
    }	
    @IBAction func fulfillButtonPressed(_ sender: AnyObject) {
        
        let fulfillPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(fulfillPopup)
        self.view.addSubview(fulfillPopup.view)
        fulfillPopup.didMove(toParentViewController: self)
        fulfillPopup.ticket = ticket!.desc
        fulfillPopup.addMessage(context: "FulfillOrder")
        

        //performSegue(withIdentifier: "UnwindToTableListSegue", sender: self)
    }
}
