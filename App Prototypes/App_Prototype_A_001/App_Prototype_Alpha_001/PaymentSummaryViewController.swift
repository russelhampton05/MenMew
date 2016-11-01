//
//  PaymentSummaryViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/1/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PaymentSummaryViewController: UIViewController {
    
    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketLabel.text = ticket!.desc!
        priceLabel.text = "$" + String(format: "%.2f", ticket!.total! + ticket!.tip!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToMainSegue", sender: self)
    }


}
