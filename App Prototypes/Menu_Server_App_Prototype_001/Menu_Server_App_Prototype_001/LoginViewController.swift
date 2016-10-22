//
//  LoginViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true
        self.navigationController?.isNavigationBarHidden = true
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.autocorrectionType = UITextAutocorrectionType.no
        
        //Entry point for notifications and messages from Firebase
        //Stub
        
        if let user = FIRAuth.auth()?.currentUser {
            logoutButton.isHidden = false
            registerButton.isHidden = true
            usernameField.text = user.email!
        }
        else {
            logoutButton.isHidden = true
            registerButton.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantListSegue" {
            let restaurantVC = segue.destination as! RestaurantTableViewController
            
        }
        else if segue.identifier == "RegisterSegue" {
            let regVC = segue.destination as! RegisterViewController
        }
    }

    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if self.usernameField.text! == "" || self.passwordField.text! == "" {
            showPopup(message: "Please enter an email and password.")
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.usernameField.text!, password: self.passwordField.text!, completion: {(user, error) in
                
                if error == nil {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    
                    self.performSegue(withIdentifier: "RestaurantListSegue", sender: self)
                }
                else {
                   self.showPopup(message: (error?.localizedDescription)!)
                }
            })
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    
    func showPopup(message: String) {
        let loginPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(loginPopup)
        self.view.addSubview(loginPopup.view)
        loginPopup.didMove(toParentViewController: self)
        loginPopup.addMessage(context: message)
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        
        self.usernameField.text = ""
        self.passwordField.text = ""
        logoutButton.isHidden = true
        registerButton.isHidden = false
        
    }
    
}
