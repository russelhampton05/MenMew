//
//  ProfilePopupViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/21/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class ProfilePopupViewController: UIViewController, UITextFieldDelegate {
    
    //IBOutlets
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var updateField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLine: UIView!
    
    var dataItem: String?
    var condition: String?
    var userEntry: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        confirmButton.isEnabled = false
        updateField.delegate = self
        updateField.autocorrectionType = UITextAutocorrectionType.no
        
        if condition == "Email" {
            updateField.keyboardType = UIKeyboardType.emailAddress
        }
        else if condition == "Password" {
            updateField.isSecureTextEntry = true
        }
        
        itemLabel.text = dataItem
        
        loadTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.removeAnimate()
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        condition = "CancelAction"
        self.removeAnimate()
    }
    
    //Check if text field is populated
    func textFieldDidEndEditing(_ textField: UITextField) {
        if updateField.hasText {
            userEntry = updateField.text
            confirmButton.isEnabled = true
        }
    }
    
    //Tabbing
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
    
    //Check for segue conditions
    func checkSegueCondition() {
        if self.condition == "CancelAction" {
            //Do nothing
        }
        else {
            updateUserDetails(input: dataItem!)
            
            if let parentVC = self.parent as? ProfileViewController {
                parentVC.loadUser()
            }
        }
    }
    
    func updateUserDetails(input: String) {
        if let user = FIRAuth.auth()?.currentUser {
            
            if input == "Email" {
                user.updateEmail(userEntry!) { error in
                    if let error = error {
                        //Error
                    }
                    else {
                        
                    }
                }
            }
            else if input == "Password" {
                user.updatePassword(userEntry!) { error in
                    if let error = error {
                        //Error
                    }
                    else {
                        
                    }
                }
            }
            else if input == "Name" {
                currentUser!.name = userEntry!
                UserManager.UpdateUserName(user: currentUser!, name: userEntry!)
            }
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.highlight!
        
        //Labels
        changeLabel.textColor = currentTheme!.highlight!
        itemLabel.textColor = currentTheme!.highlight!
        infoLine.backgroundColor = currentTheme!.highlight!
        infoLabel.textColor = currentTheme!.highlight!
        
        //Buttons
        confirmButton.backgroundColor = currentTheme!.highlight!
        confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
        cancelButton.backgroundColor = currentTheme!.highlight!
        cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
    }
}
