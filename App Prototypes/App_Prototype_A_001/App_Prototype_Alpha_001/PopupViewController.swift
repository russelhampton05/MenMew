//
//  PopupViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/12/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    var menuItem: String?
    var ticketString: String?
    var customMessage = String()
    var condition: String?
    var register = false
    var doubleValue: Double?
    var ticket: Ticket?

    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        loadTheme()
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    //Popup view animation
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //Popup remove animation
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
            }, completion:{(finished : Bool) in
                if (finished)
                {
                    self.checkSegueCondition()
                    self.view.removeFromSuperview()
                }
        })
    }
    
    //Check for which controller the popup must segue into
    func checkSegueCondition() {
        if self.condition == "FulfillOrder" {
            //if let parent = self.parent as? TableDetailViewController {
                //parent.performSegue(withIdentifier: "UnwindToTableListSegue", sender: parent)
            //}
        }
        else if self.condition == "AddOrderDetails" {
            if let parent = self.parent as? MenuDetailsViewController {
                
                parent.tableView.isScrollEnabled = true
                parent.addOrder(parent)
            }
        }
        else if self.condition == "CancelMenuItems" {
            if let summaryP = self.parent as? SummaryViewController {
               
                var toRemove: [String] = []
                
                for item in ticket!.itemsOrdered! {
                    toRemove.append(item.item_ID!)
                }
                
                ticket!.itemsOrdered = []
                
                UserManager.SetTicket(user: currentUser!, ticket: ticket!, toRemove: toRemove) {
                    completed in
                    
                    if completed {
                        UserManager.UpdateTicketStatus(user: currentUser!, ticket: self.ticket!.ticket_ID!, status: "Order Cancelled")
                    }
                }
                summaryP.performSegue(withIdentifier: "UnwindMainMenu", sender: summaryP)
            }
        }
        else if self.register {
            if let registerVC = self.parent as? RegisterViewController {
                registerVC.performSegue(withIdentifier: "QRScanSegue", sender: registerVC)
            }
        }
        else if self.condition == "QRError" {
            if let restoVC = self.parent as? RestaurantViewController {
                restoVC.performSegue(withIdentifier: "QRReturnSegue", sender: restoVC)
            }		
        }
        else if self.condition == "PayOrder" {
            if let payVC = self.parent as? PaymentDetailsViewController {
                payVC.performSegue(withIdentifier: "PaymentSummarySegue", sender: payVC)
            }
        }
    }
    
    //Custom message display
    func addMessage(context: String) {
        condition = context
        if context == "AddMenuItem" {
            addedLabel.text = menuItem! + " has been added to the order."
        }
        else if context == "CancelMenuItems" {
            addedLabel.text = "Are you sure you want to clear all orders?"
            cancelButton.isHidden = false
        }
        else if context == "FulfillOrder" {
            addedLabel.text = "The ticket has been fulfilled."
        }
        else if context == "QRError" {
            addedLabel.text = "Error in retrieving QR code data. Please scan again."
        }
        else if context == "PayOrder" {
            addedLabel.text = "Confirm paying for this ticket?"
        }
        else {
            addedLabel.text = context
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        popupView.backgroundColor = currentTheme!.bgColor!
        self.view.tintColor = currentTheme!.hlColor!
        
        //Labels
        addedLabel.textColor = currentTheme!.hlColor!
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.hlColor!
        confirmButton.setTitleColor(currentTheme!.bgColor!, for: .normal)
        cancelButton.backgroundColor = currentTheme!.hlColor!
        cancelButton.setTitleColor(currentTheme!.bgColor!, for: .normal)
    }
}


