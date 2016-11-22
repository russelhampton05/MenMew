//
//  PopupViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/12/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var addedLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var menuItem: String?
    var ticket: String?
    var customMessage = String()
    var condition: String?
    
    //Initial view load, check if the instigator is a cancel prompt
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
                    self.view.removeFromSuperview()
                    
                    if let parent = self.parent as? UITableViewController {
                        parent.tableView.isScrollEnabled = true
                    }
                    
                    if self.condition == "FulfillOrder" {
                        if let parent = self.parent as? TableDetailViewController {
                            parent.performSegue(withIdentifier: "UnwindToTableListSegue", sender: parent)
                        }
                    }
                }
        })
    }
    
    func addMessage(context: String) {
        condition = context
        if context == "AddMenuItem" {
            addedLabel.text = menuItem! + " has been added to the order."
        }
        else if context == "CancelMenuItems" {
            addedLabel.text = "Are you sure you want to cancel the order/s?"
            cancelButton.isHidden = false
        }
        else if context == "FulfillOrder" {
            addedLabel.text = "The ticket has been fulfilled."
        }
        else {
            addedLabel.text = context
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        popupView.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
        
        //Labels
        addedLabel.textColor = currentTheme!.highlight!
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.highlight!
        confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
        cancelButton.backgroundColor = currentTheme!.highlight!
        cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
    }

}
