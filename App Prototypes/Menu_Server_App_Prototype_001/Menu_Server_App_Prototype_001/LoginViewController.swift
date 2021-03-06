//
//  LoginViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

//Globals
var currentServer: Server?
var currentTheme: Theme?

class LoginViewController: UIViewController, UITextFieldDelegate {

    //IBOutlets
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!

 
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        passwordField.delegate = self
        
        usernameField.keyboardType = UIKeyboardType.emailAddress
        passwordField.isSecureTextEntry = true
        self.navigationController?.isNavigationBarHidden = true
        
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.autocorrectionType = UITextAutocorrectionType.no

        checkLogin()
    }
    
    func checkLogin() {
        //Check for existing logged in user
        if let fbUser = FIRAuth.auth()?.currentUser {
            //Check if logged in user exists in Firebase
            ServerManager.GetServer(id: fbUser.uid) {
                server in
                
                if server.ID != "" {
                    self.logoutButton.isHidden = false
                    self.usernameField.text = fbUser.email!
                    
                    currentServer = server
                    self.loadTheme()
                }
            }
            
        }
        else {
            logoutButton.isHidden = true
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
            _ = segue.destination as! RestaurantTableViewController
            
        }
    }

    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if (!usernameField.hasText || !passwordField.hasText) || (usernameField.text! == "" || passwordField.text! == "") {
            showPopup(message: "Please enter an email and password.")
        }
        else {
            FIRAuth.auth()?.signIn(withEmail: self.usernameField.text!, password: self.passwordField.text!, completion: {(user, error) in
                
                if error == nil {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    
                    ServerManager.GetServer(id: user!.uid) {
                        server in
                        
                        if server.ID != "" {
                            
                            currentServer = server
                            
                            self.loadTheme()
                            
                            self.performSegue(withIdentifier: "RestaurantListSegue", sender: self)
                            
                        }
                    }
                    
                }
                else {
                    self.showPopup(message: (error?.localizedDescription)!)
                }
            })
        }
    }
    

    
    func showPopup(message: String) {
        let loginPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(loginPopup)
        self.view.addSubview(loginPopup.view)
        loginPopup.didMove(toParentViewController: self)
        loginPopup.addMessage(context: message)
        
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = true
        logoutButtonPressed(self)
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        
        self.usernameField.text = ""
        self.passwordField.text = ""
        logoutButton.isHidden = true
        
        currentServer = nil
        resetTheme()
    }
    
    func loadTheme() {
        if currentServer != nil {
            currentTheme = Theme.init(type: currentServer!.theme!)
        }
        
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            //Background and Tint
            self.view.backgroundColor = currentTheme!.primary!
            self.view.tintColor = currentTheme!.highlight!
            
            self.setNeedsStatusBarAppearanceUpdate()
            if currentTheme!.name! == "Midnight" || currentTheme!.name! == "Slate" {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else {
                UIApplication.shared.statusBarStyle = .default
            }
            
            
            //Labels
            self.loginTitle.textColor = currentTheme!.highlight!
            self.emailLine.backgroundColor = currentTheme!.highlight!
            self.passwordLine.backgroundColor = currentTheme!.highlight!
            self.emailLabel.textColor = currentTheme!.highlight!
            self.passwordLabel.textColor = currentTheme!.highlight!
            
            //Fields
            self.usernameField.textColor = currentTheme!.highlight!
            self.usernameField.tintColor = currentTheme!.highlight!
            self.passwordField.textColor = currentTheme!.highlight!
            self.passwordField.tintColor = currentTheme!.highlight!
            
            
            //Buttons
            self.doneButton.backgroundColor = currentTheme!.highlight!
            self.doneButton.setTitleColor(currentTheme!.primary!, for: .normal)
            self.logoutButton.backgroundColor = currentTheme!.highlight!
            self.logoutButton.setTitleColor(currentTheme!.primary!, for: .normal)
        })
    }
    
    func resetTheme() {
        currentTheme = Theme.init(type: "Salmon")
        loadTheme()
    }
}
