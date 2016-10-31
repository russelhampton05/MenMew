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
        
        //Format date to more human-readable result
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = formatter.date(from: ticket!.timestamp!)
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        
        ticketLabel.text = ticket!.desc!
        dateLabel.text = formatter.string(from: currentDate!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.navigationController?.isNavigationBarHidden = false
        performSegue(withIdentifier: "UnwindToMainSegue", sender: self)
    }
    
}
