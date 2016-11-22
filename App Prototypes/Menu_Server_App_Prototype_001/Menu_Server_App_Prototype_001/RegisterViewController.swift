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

    
    @IBOutlet weak var reenterLabel: UILabel!

 
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmRegisterButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
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
        
        loadTheme()
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
                    
                    //Add Server to Firebase
                    
                    
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
            //let scanVC = segue.destination as! QRViewController
        }
    }
    func loadTheme() {
        currentTheme = Theme.init(type: "Salmon")
        
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            
            //Background and Tint
            self.view.backgroundColor = currentTheme!.primary!
            self.view.tintColor = currentTheme!.highlight!
            
            
            //Labels
            self.registerLabel.textColor = currentTheme!.highlight!
            self.emailLabel.textColor = currentTheme!.highlight!
            self.passwordLabel.textColor = currentTheme!.highlight!
            self.reenterLabel.textColor = currentTheme!.highlight!
            
            //Fields
            self.usernameField.textColor = currentTheme!.highlight!
            self.usernameField.tintColor = currentTheme!.highlight!
            self.emailField.textColor = currentTheme!.highlight!
            self.emailField.tintColor = currentTheme!.highlight!
            self.passwordField.textColor = currentTheme!.highlight!
            self.passwordField.tintColor = currentTheme!.highlight!
            self.confirmPasswordField.textColor = currentTheme!.highlight!
            self.confirmPasswordField.tintColor = currentTheme!.highlight!
            
            //Buttons
            self.confirmRegisterButton.backgroundColor = currentTheme!.highlight!
            self.confirmRegisterButton.setTitleColor(currentTheme!.primary!, for: .normal)
//            self.cancelButton.backgroundColor = currentTheme!.highlight!
//            self.cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
        })
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
