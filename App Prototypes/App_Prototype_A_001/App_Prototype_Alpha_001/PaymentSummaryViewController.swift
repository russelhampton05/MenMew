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
    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var ticketTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var thankTitle: UILabel!
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ticketLabel.text = ticket!.desc!
        priceLabel.text = "$" + String(format: "%.2f", ticket!.total! + ticket!.tip!)
        
        UserManager.UpdateTicketStatus(user: currentUser!, ticket: ticket!.ticket_ID!, status: "Order Paid")
        
        loadTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToMainSegue", sender: self)
    }

    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.bgColor!
        self.view.tintColor = currentTheme!.hlColor!
        
        //Labels
        summaryTitle.textColor = currentTheme!.hlColor!
        ticketTitle.textColor = currentTheme!.hlColor!
        priceTitle.textColor = currentTheme!.hlColor!
        thankTitle.textColor = currentTheme!.hlColor!
        ticketLabel.textColor = currentTheme!.hlColor!
        priceLabel.textColor = currentTheme!.hlColor!
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.hlColor!
        confirmButton.setTitleColor(currentTheme!.textColor!, for: .normal)
    }
}
