//
//  LoginViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

//Global Variables
var currentUser: User?
var currentRestaurant: String?

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //IBOutlets
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
        
        //Check for existing logged in user
        if let fbUser = FIRAuth.auth()?.currentUser {
            //Check if logged in user exists in Firebase
            UserManager.GetUser(id: fbUser.uid) {
                user in
                
                if user.ID != nil {
                    self.logoutButton.isHidden = false
                    self.registerButton.isHidden = true
                    self.usernameField.text = fbUser.email!
                    
                    currentUser = user
                }
            }
            
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
        if segue.identifier == "QRScanSegue" {
            let scanVC = segue.destination as! QRViewController
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
                    
                    UserManager.GetUser(id: user!.uid) {
                        user in
                        
                        if user.ID != nil {
                            
                            currentUser = user
                            
                            self.performSegue(withIdentifier: "QRScanSegue", sender: self)
                        }
                    }
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
        loginPopup.view.frame = self.view.frame
        self.view.addSubview(loginPopup.view)
        loginPopup.didMove(toParentViewController: self)
        loginPopup.addMessage(context: message)
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        currentUser = nil
        
        self.usernameField.text = ""
        self.passwordField.text = ""
        logoutButton.isHidden = true
        registerButton.isHidden = false
        
    }
}
