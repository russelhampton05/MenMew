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
    @IBOutlet var registerLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var reenterLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmRegisterButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var nameLine: UIView!
    @IBOutlet var emailLine: UIView!
    @IBOutlet var passwordLine: UIView!
    @IBOutlet var reenterLine: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        confirmRegisterButton.isEnabled = false
        
        emailField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        emailField.autocorrectionType = UITextAutocorrectionType.no
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
        if !self.emailField.hasText || !self.usernameField.hasText || !self.passwordField.hasText {
            showPopup(message: "Please enter your name, email and password.", isRegister: false)
        }
        else if self.passwordField.text != self.confirmPasswordField.text {
            showPopup(message: "Password entries do not match.", isRegister: false)
            self.passwordField.text = ""
            self.confirmPasswordField.text = ""
        }
        else {
            FIRAuth.auth()?.createUser(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
                
                if error == nil {
                    //Create associated entry on Firebase
                    let newUser = User(id: (user?.uid)!, email: (user?.email)!, name: self.usernameField.text!, ticket: nil, image: nil, theme: nil)
                    
                    UserManager.UpdateUser(user: newUser)
                    
                    currentUser = newUser
                    
                    self.emailField.text = ""
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
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindToLoginSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRScanSegue" {
            let scanVC = segue.destination as! QRViewController
        }
    }
    
    func showPopup(message: String, isRegister: Bool) {
        let loginPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        if isRegister {
            loginPopup.register = true
        }
        
        self.addChildViewController(loginPopup)
        loginPopup.view.frame = self.view.frame
        self.view.addSubview(loginPopup.view)
        loginPopup.didMove(toParentViewController: self)
        loginPopup.addMessage(context: message)
        
    }
    
    func loadTheme() {
        currentTheme = Theme.init(type: "Salmon")
        
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            
            //Background and Tint
            self.view.backgroundColor = currentTheme!.primary!
            self.view.tintColor = currentTheme!.highlight!
            
            
            //Labels
            self.registerLabel.textColor = currentTheme!.highlight!
            self.emailLine.backgroundColor = currentTheme!.highlight!
            self.passwordLine.backgroundColor = currentTheme!.highlight!
            self.nameLine.backgroundColor = currentTheme!.highlight!
            self.reenterLine.backgroundColor = currentTheme!.highlight!
            self.nameLabel.textColor = currentTheme!.highlight!
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
            self.cancelButton.backgroundColor = currentTheme!.highlight!
            self.cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
        })
    }
}
