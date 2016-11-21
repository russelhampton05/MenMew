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
    
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var themeLabel: UIStackView!
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
    
    
   
    @IBAction func themeButtonPressed(_ sender: AnyObject){       initiateThemePopup()
    }
    func initiateThemePopup() {
        let themePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemePopup") as! ThemePopupViewController
        
        self.addChildViewController(themePopup)
        self.view.addSubview(themePopup.view)
        themePopup.didMove(toParentViewController: self)
    }

    func loadTheme() {
        
//        //Background and Tint
//        self.view.backgroundColor = currentTheme!.secondary!
//        self.view.tintColor = currentTheme!.invert!
//        
//        //Labels
//        profileLabel.textColor = currentTheme!.invert!
//        nameTitle.textColor = currentTheme!.invert!
//        locationTitle.textColor = currentTheme!.invert!
//        emailLabel.textColor = currentTheme!.invert!
//        passwordLabel.textColor = currentTheme!.invert!
//        nameLabel.textColor = currentTheme!.invert!
//        themeLabel.textColor = currentTheme!.invert!
//        profileLine.backgroundColor = currentTheme!.invert!
//        touchLabel.textColor = currentTheme!.invert!
//        
//        //Buttons
//        emailButton.setTitleColor(currentTheme!.invert!, for: .normal)
//        passwordButton.setTitleColor(currentTheme!.invert!, for: .normal)
//        nameButton.setTitleColor(currentTheme!.invert!, for: .normal)
//        themeButton.setTitleColor(currentTheme!.invert!, for: .normal)
//        touchToggle.thumbTintColor = currentTheme!.invert!
//        
//        if currentTheme!.name! == "Salmon" {
//            confirmButton.backgroundColor = currentTheme!.invert!
//            confirmButton.setTitleColor(currentTheme!.highlight!, for: .normal)
//        }
//        else {
//            confirmButton.backgroundColor = currentTheme!.invert!
//            confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
//        }
        
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
    func reloadTheme() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.loadTheme()
        })
    }
    
    
}
extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width/3, size.height/3), height: min(size.width/3, size.height/3))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
