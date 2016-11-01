//
//  PaymentDetailsViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/31/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PaymentDetailsViewController: UIViewController, UITextFieldDelegate {
    
    //Variables
    var ticket: Ticket?
    var currentTip: Double?
    
    //IBOutlets
    @IBOutlet var ticketLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var tipField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        
        ticketLabel.text = ticket!.desc!
        priceLabel.text = "$" + String(format: "%.2f", ticket!.total!)
        
        tipField.delegate = self
        tipField.keyboardType = .numbersAndPunctuation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTip = Double(textField.text!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentSummarySegue" {
            let paySumVC = segue.destination as! PaymentSummaryViewController
            
            TicketManager.UpdatePayTicket(ticket: ticket!, isPaid: true)
            
            paySumVC.ticket = ticket
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }

    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        
        self.addChildViewController(confirmPopup)
        self.view.addSubview(confirmPopup.view)
        confirmPopup.didMove(toParentViewController: self)
        
        if currentTip != nil {
            ticket!.tip! = currentTip!
            confirmPopup.doubleValue = ticket!.tip!
        }
        else {
            ticket!.tip! = 0.0
            confirmPopup.doubleValue = 0.0
        }
        
        confirmPopup.addMessage(context: "PayOrder")
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToSummarySegue", sender: self)
    }
}
