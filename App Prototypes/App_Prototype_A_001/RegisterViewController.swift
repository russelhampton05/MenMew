//
//  RegisterViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    //IBOutlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmRegisterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        confirmRegisterButton.isEnabled = false
        
        usernameField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.autocorrectionType = UITextAutocorrectionType.no
        confirmPasswordField.autocorrectionType = UITextAutocorrectionType.no
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.usernameField.text != "" && self.passwordField.text != "" && self.confirmPasswordField.text != "" {
            confirmRegisterButton.isEnabled = true
        }
    }
    
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        if self.usernameField.text! == "" || self.passwordField.text! == "" {
            showPopup(message: "Please enter an email and password.", isRegister: false)
        }
        else if self.passwordField.text != self.confirmPasswordField.text {
            showPopup(message: "Password entries do not match.", isRegister: false)
            self.passwordField.text = ""
            self.confirmPasswordField.text = ""
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: self.usernameField.text!, password: self.passwordField.text!, completion: {(user, error) in
                
                if error == nil {
                    self.passwordField.text = ""
                    self.confirmPasswordField.text = ""
                    
                    self.showPopup(message: "Thank you for registering, " + self.usernameField.text! + "!", isRegister: true)
                    
                    self.usernameField.text = ""
                }
                else {
                    self.showPopup(message: (error?.localizedDescription)!, isRegister: false)
                }
            })
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRScanSegue" {
            let scanVC = segue.destination as! QRViewController
        }
    }
    
    func showPopup(message: String, isRegister: Bool) {
        let loginPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        if isRegister {
            loginPopup.condition = "RegisterUser"
        }
        
        self.addChildViewController(loginPopup)
        loginPopup.view.frame = self.view.frame
        self.view.addSubview(loginPopup.view)
        loginPopup.didMove(toParentViewController: self)
        loginPopup.addMessage(context: message)
        
    }
}
