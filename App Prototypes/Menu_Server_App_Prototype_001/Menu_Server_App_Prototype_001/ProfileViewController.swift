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
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let user = FIRAuth.auth()?.currentUser {
            usernameLabel.text = user.email
            passwordLabel.text = "*******"
            nameLabel.text = user.displayName
            paymentLabel.text = "VISA"
        }
        else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToSettingsSegue", sender: self)
    }
}
