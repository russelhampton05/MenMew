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
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var ticketTitle: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var orderLine: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        loadTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadInfo()
    }
    
    func loadInfo() {
        ticketLabel.text = ticket!.desc!
        
        if ticket!.total != nil && ticket!.total! > 0 {
            print(ticket!.total!)
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
        
        messageLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindToSettingsSegue", sender: self)
    }
    
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
        //Initiate popup
        let messagePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagePopup") as! MessagePopupViewController
        
        self.addChildViewController(messagePopup)
        self.view.addSubview(messagePopup.view)
        messagePopup.didMove(toParentViewController: self)
        
    }
    
    func sendMessage(message: String) {
        
        //Write the message
        MessageManager.WriteServerMessage(id: currentUser!.ticket!.message_ID!, message: message)
        
        //Hide the button to avoid spam
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
        self.helpButton.isHidden = true
        self.messageLabel.isHidden = false
        
        })
        
        //Reinstate the help button after 10 seconds
        let delay = DispatchTime.now() + 10
        DispatchQueue.main.asyncAfter(deadline: delay) {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.helpButton.isHidden = false
                self.messageLabel.isHidden = true
                
            })
            
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.invert!
        
        //Labels
        orderTitle.textColor = currentTheme!.invert!
        ticketTitle.textColor = currentTheme!.invert!
        totalTitle.textColor = currentTheme!.invert!
        ticketLabel.textColor = currentTheme!.invert!
        totalLabel.textColor = currentTheme!.invert!
        messageLabel.textColor = currentTheme!.invert!
        orderLine.backgroundColor = currentTheme!.invert!
        
        //Buttons
        if currentTheme!.name! == "Salmon" {
            doneButton.backgroundColor = currentTheme!.invert!
            doneButton.setTitleColor(currentTheme!.highlight!, for: .normal)
            helpButton.backgroundColor = currentTheme!.invert!
            helpButton.setTitleColor(currentTheme!.highlight!, for: .normal)
        }
        else {
            doneButton.backgroundColor = currentTheme!.invert!
            doneButton.setTitleColor(currentTheme!.primary!, for: .normal)
            helpButton.backgroundColor = currentTheme!.invert!
            helpButton.setTitleColor(currentTheme!.primary!, for: .normal)
        }
    }
}
