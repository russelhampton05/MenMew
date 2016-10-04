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
    var table: Table?
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var customerContainer: UIView!
    @IBOutlet weak var orderContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNumLabel.text = "Table #" + String(table!.tableNum)
        ticketLabel.text = "Ticket " + table!.ticket
        statusLabel.text = table!.category
        
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
            
            custVC.customerList = table!.clientList
        }
        else if segue.identifier == "OrderTableSegue" {
            let orderVC = segue.destination as! OrderTableViewController
            
            orderVC.orderList = table!.orderList
        }
    }
}
