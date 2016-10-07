//
//  MenuDetailPopupViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/7/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class MenuDetailPopupViewController: UIViewController {
    
    //Variables
    var sidesList: [String] = []
    var cookList: [String] = []
    var menuItem: String?
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        titleLabel.text = "Select your preferences: "
        self.showAnimate()
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
                    
                    if let parent = self.parent as? MenuDetailsViewController {
                        
                        parent.tableView.isScrollEnabled = true
                        parent.addOrder(parent)
                    }
                }
        })
    }
    
    //Show menu details (side dishes, cooking types, etc)
    func showMenuDetails(details: Details) {
        

        sidesList = details.sides
        cookList = details.cookType
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SidesSegue" {
            let sidesVC = segue.destination as! SidesPickerViewController
            sidesVC.choiceArray = sidesList
        }
        
        if segue.identifier == "CookTypeSegue" {
            let cookVC = segue.destination as! CookTypePickerViewController
            cookVC.choiceArray = cookList
        }
    }


}
