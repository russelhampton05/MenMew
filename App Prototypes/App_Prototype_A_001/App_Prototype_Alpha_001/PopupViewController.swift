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
    
    var menuItem: String?
    var customMessage = String()
    var cancelOrder: Bool = false
    var confirmCancel: Bool = false
    
    //Initial view load, check if the instigator is a cancel prompt
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        if cancelOrder {
            cancelButton.isHidden = false
        }
    }
    
    //if self.cancelOrder == true {
    //self.performSegueWithIdentifier("ReturnMenu", sender: self)
    //}
    //Confirm button
    @IBAction func confirmAction(_ sender: AnyObject) {
        confirmCancel = true
        self.removeAnimate()
    }
    
    //Cancel button
    @IBAction func cancelAction(_ sender: AnyObject) {
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
                    self.view.removeFromSuperview()
                    let parent = self.parent as! UITableViewController
                    parent.tableView.isScrollEnabled = true
                    
                    if self.confirmCancel {
                        if let summaryP = self.parent as? SummaryViewController {
                            summaryP.orderArray = []
                            summaryP.performSegue(withIdentifier: "UnwindMenu", sender: summaryP)
                        }
                    }
                }
        })
    }
    
    //Add to order message
    func orderAddMessage() {
        addedLabel.text = menuItem! + " has been added to the order."
    }
    
    //Cancel ask message
    func orderCancelMessage() {
        addedLabel.text = "Are you sure you want to cancel the order/s?"
    }
    
}
