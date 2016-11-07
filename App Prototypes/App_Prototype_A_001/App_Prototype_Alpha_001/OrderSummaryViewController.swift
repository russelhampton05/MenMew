//
//  OrderSummaryViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/7/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var refillButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketLabel.text = ticket!.desc!
        
        if ticket!.total != nil || ticket!.total! > 0 {
            if ticket!.tip != nil {
                totalLabel.text = "$" + String(format: "%.2f", ticket!.total! + ticket!.tip!)
            }
            else {
                totalLabel.text = "$" + String(format: "%.2f", ticket!.total!)
            }
        }
        else {
            totalLabel.text = "$0.00"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindToSettingsSegue", sender: self)
    }
    
    @IBAction func refillButtonPressed(_ sender: Any) {
        //Initiate message to server
        MessageManager.WriteServerMessage(id: currentUser!.ticket!.message_ID!, message: "Requesting refill at Table \(currentUser!.ticket!.tableNum!), Ticket #\(currentUser!.ticket!.desc!)")
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        //Initiate message to server
        MessageManager.WriteServerMessage(id: currentUser!.ticket!.message_ID!, message: "Requesting assistance at Table \(currentUser!.ticket!.tableNum!)")
    }
    
    
}
