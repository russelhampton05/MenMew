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
    
    var menuItem = String()
    var customMessage = String()
    var cancelOrder : Bool = false
    
    //Initial view load, check if the instigator is a cancel prompt
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.showAnimate()
        if cancelOrder {
            cancelButton.hidden = false
        }
    }
    
    
    //Confirm button
    @IBAction func confirmAction(sender: AnyObject) {
        cancelOrder = false
        
        self.removeAnimate()
    }
    
    //Cancel button
    @IBAction func cancelAction(sender: AnyObject) {
        self.removeAnimate()
    }
    
    //Popup view animation
    func showAnimate() {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    //Popup remove animation
    func removeAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0
            }, completion:{(finished : Bool) in
                if (finished)
                {
                    self.view.removeFromSuperview()
                    let parent = self.parentViewController as! UITableViewController
                    parent.tableView.scrollEnabled = true
                }
        })
    }
    
    //Add to order message
    func orderAddMessage() {
        addedLabel.text = menuItem + " has been added to the order."
    }
    
    //Cancel ask message
    func orderCancelMessage() {
        addedLabel.text = "Are you sure you want to cancel the order/s?"
    }
    
    //Segue back to main menu
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReturnMenu" {
            let menuTable: TableViewController = segue.destinationViewController as! TableViewController
            menuTable.orderArray = []
        }
    }
    
}
