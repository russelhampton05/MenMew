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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Display current user information
        if let user = FIRAuth.auth()?.currentUser {
            
            //Eventually a user model will have more data such as payment information
            emailButton.setTitle(user.email, for: .normal)
            passwordButton.setTitle(String(repeating: "*", count: user.email!.characters.count), for: .normal)
            nameButton.setTitle(user.displayName, for: .normal)
            paymentButton.setTitle("VISA", for: .normal)
            
            nameTitle.text = user.displayName
            locationTitle.text = restaurantName!
            
            if user.photoURL != nil {
                let imageData = try? Data(contentsOf: user.photoURL!)
                profilePhoto.image = UIImage(data: imageData!)
            }
            
        }
        else {
            
        }
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
}
