//
//  OrderConfirmationViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/20/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    //Variables
    var ticket: Ticket?
    
    //IBOutlets
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        ticketLabel.text = ticket!.desc!
        dateLabel.text = ticket!.timestamp!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.navigationController?.isNavigationBarHidden = false
        performSegue(withIdentifier: "UnwindToMainSegue", sender: self)
    }
    
}
