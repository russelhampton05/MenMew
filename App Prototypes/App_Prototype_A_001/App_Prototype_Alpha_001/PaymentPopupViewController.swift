//
//  PaymentPopupViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/13/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import LocalAuthentication

class PaymentPopupViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var payTitle: UILabel!
    @IBOutlet var payConfirmLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var printImage: UIImageView!
    @IBOutlet var printStackView: UIStackView!
    @IBOutlet var popupView: UIView!
    
    //Variables
    var didCancel: Bool = false
    let authContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        loadTheme()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentUser!.touchEnabled {
            payConfirmLabel.text = "Please authenticate with TouchID."
            printStackView.isHidden = false
            confirmButton.isHidden = true
            
            let delay = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.ConfirmWithTouchID(laContext: self.authContext)
            }
            
        }
        else {
            confirmButton.isHidden = false
            payConfirmLabel.text = "Payment will be finalized."
            printStackView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        didCancel = true
        removeAnimate()
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
                if !self.didCancel {
                    if let payVC = self.parent as? PaymentDetailsViewController {
                        payVC.performSegue(withIdentifier: "PaymentSummarySegue", sender: payVC)
                    }
                }
                
                self.view.removeFromSuperview()
            }
        })
    }
    
    //Get Touch ID
    func ConfirmWithTouchID(laContext: LAContext)->(Bool, NSError?){
        var error: NSError?
        var didSucceed = false
        guard laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return (didSucceed, error)
        }
        
        laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with your fingerprint now.", reply: { (success, error) -> Void in
            
            if( success ) {
                didSucceed = success
                
                //Show success prompt
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        self.printStackView.isHidden = true
                        self.payConfirmLabel.text = "Authentication success. Please proceed."
                        self.confirmButton.isHidden = false
                    })
                }
                
            }
            else{
                
                // Check if there is an error
                if error != nil {
                    didSucceed = false
                    
                    //Show failure prompt
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.25, animations: { () -> Void in
                            self.printStackView.isHidden = true
                            self.payConfirmLabel.text = "Authentication failure. Reason: \(error!.localizedDescription)"
                        })
                    }
                }
                
            }
        })
        
        return (didSucceed, error)
    }

    func loadTheme() {
        
        if currentTheme!.name! == "Light" {
            //Background and Tint
            popupView.backgroundColor = currentTheme!.highlight!
            self.view.tintColor = currentTheme!.primary!
            
            //Labels
            
            payConfirmLabel.textColor = currentTheme!.primary!
            payTitle.textColor = currentTheme!.primary!
            
            //Buttons
            confirmButton.backgroundColor = currentTheme!.primary!
            confirmButton.setTitleColor(currentTheme!.highlight!, for: .normal)
            cancelButton.backgroundColor = currentTheme!.primary!
            cancelButton.setTitleColor(currentTheme!.highlight!, for: .normal)
        }
        else {
            //Background and Tint
            popupView.backgroundColor = currentTheme!.primary!
            self.view.tintColor = currentTheme!.highlight!
            
            //Labels
            
            payConfirmLabel.textColor = currentTheme!.highlight!
            payTitle.textColor = currentTheme!.highlight!
            
            //Buttons
            confirmButton.backgroundColor = currentTheme!.highlight!
            confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
            cancelButton.backgroundColor = currentTheme!.highlight!
            cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
        }
    }
}
