//
//  ProfileViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var passwordButton: UIButton!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var paymentButton: UIButton!
    @IBOutlet var profilePhoto: UIImageView!
    
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var locationTitle: UILabel!
    
    var restaurantName: String?
    var currentPayment: Payment?
    var paymentList: [Payment] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Display current user information
        if let user = FIRAuth.auth()?.currentUser {
            
            //Eventually a user model will have more data such as payment information
            //Test payment
            if currentPayment == nil {
                currentPayment = Payment(name: "XXXX-1234", type: "VISA")
            }
            
            emailButton.setTitle(user.email, for: .normal)
            passwordButton.setTitle(String(repeating: "*", count: user.email!.characters.count), for: .normal)
            nameButton.setTitle(user.displayName, for: .normal)
            paymentButton.setTitle(currentPayment!.name, for: .normal)
            
            nameTitle.text = user.displayName
            locationTitle.text = restaurantName!
            
            if user.photoURL != nil {
                let imageData = try? Data(contentsOf: user.photoURL!)
                profilePhoto.image = UIImage(data: imageData!)
            }
            
        }
        else {
            
        }
        
        
        //Dummy data for payments
        //Test data
        paymentList.append(Payment(name: "XXXX-1234", type: "VISA"))
        paymentList.append(Payment(name: "XXXX-4567", type: "MasterCard"))
        paymentList.append(Payment(name: "jdoe@gmail.com", type: "PayPal"))
        paymentList.append(Payment(name: "XX23ARW2", type: "Rewards Card"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //Button press functions
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToSettingsSegue", sender: self)
    }
    
    @IBAction func emailButtonPressed(_ sender: AnyObject) {
        initiatePopup(input: "Email")
    }
    
    @IBAction func passwordButtonPressed(_ sender: AnyObject) {
        initiatePopup(input: "Password")
    }

    @IBAction func nameButtonPressed(_ sender: AnyObject) {
        initiatePopup(input: "Name")
    }
    
    @IBAction func paymentButtonPressed(_ sender: AnyObject) {
    }
    
    //Instantiate the popup
    func initiatePopup(input: String) {
        
        let updatePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdatePopup") as! ProfilePopupViewController
        
        updatePopup.condition = input
        updatePopup.dataItem = input
        
        self.addChildViewController(updatePopup)
        self.view.addSubview(updatePopup.view)
        updatePopup.didMove(toParentViewController: self)
    }
    
    //Segue to payment page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentSegue" {
            let paymentVC = segue.destination as! PaymentViewController
            
            paymentVC.currentPayment = currentPayment
            paymentVC.paymentList = paymentList
        }
    }
    
    //Unwind Segue
    @IBAction func unwindToPayments(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? PaymentViewController {
            currentPayment = sourceVC.currentPayment
            
            paymentButton.setTitle(currentPayment!.name, for: .normal)
        }
    }
}
