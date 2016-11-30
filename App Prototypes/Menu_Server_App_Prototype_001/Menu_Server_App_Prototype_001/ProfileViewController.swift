//
//  ProfileViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/28/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //IBOutlets
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var passwordButton: UIButton!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var locationTitle: UILabel!
    
    @IBOutlet weak var preferencesLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var profileLine: UIView!
    
    
    
    //Variables
    var restaurantName: String?
    let imagePicker = UIImagePickerController()
    let context = CIContext()
    var newImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize gesture recognizer for profile image
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.addGestureRecognizer(tapGestureRecognizer)
        
        //Initialize image picker delegate
        imagePicker.delegate = self
        
        loadUser()
        loadTheme()
        
    }
    
    func loadUser() {
        //Display current user information
        if let user = FIRAuth.auth()?.currentUser {
            
            emailButton.setTitle(user.email, for: .normal)
            passwordButton.setTitle(String(repeating: "*", count: user.email!.characters.count), for: .normal)
            nameButton.setTitle(user.displayName, for: .normal)
            
            nameTitle.text = currentServer!.name!
            nameButton.setTitle(currentServer!.name!, for: .normal)
            locationTitle.text = "On Duty"
            
            if currentServer!.image != nil {
                profilePhoto.getImage(urlString: currentServer!.image!, circle: false)
            }
            
        }
        else {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Button press functions
    func imageTapped(img: Any) {
        //Open the photo gallery
        self.confirmButton.isEnabled = false
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
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
    
    
    //Profile image load
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePhoto.image = pickedImage.circle
        
        //Transition animation
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.5
        fadeTransition.type = kCATransitionFade
        self.confirmButton.layer.add(fadeTransition, forKey: "fadeText")
        self.preferencesLabel.layer.add(fadeTransition, forKey: "fadeText")
        
        self.confirmButton.isHidden = true
        self.preferencesLabel.isHidden = false
        
        //Upload image to user's profile on Firebase
        ServerManager.uploadImage(server: currentServer!, image: pickedImage.circle!) {
            done in
            
            //Update current user with new profile image
            ServerManager.getImageURL(server: currentServer!) {
                url in
                
                self.newImageURL = url
                
                //Transition animation
                let fadeTransition = CATransition()
                fadeTransition.duration = 0.5
                fadeTransition.type = kCATransitionFade
                self.confirmButton.layer.add(fadeTransition, forKey: "fadeText")
                self.preferencesLabel.layer.add(fadeTransition, forKey: "fadeText")
                
                self.confirmButton.isHidden = false
                self.preferencesLabel.isHidden = true
                
                self.confirmButton.isEnabled = true
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.confirmButton.isEnabled = true
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
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.invert!
        
        //Labels
        profileLabel.textColor = currentTheme!.invert!
        nameTitle.textColor = currentTheme!.invert!
        locationTitle.textColor = currentTheme!.invert!
        emailLabel.textColor = currentTheme!.invert!
        passwordLabel.textColor = currentTheme!.invert!
        nameLabel.textColor = currentTheme!.invert!
        profileLine.backgroundColor = currentTheme!.invert!
        preferencesLabel.textColor = currentTheme!.invert!
        
        
        //Buttons
        emailButton.setTitleColor(currentTheme!.invert!, for: .normal)
        passwordButton.setTitleColor(currentTheme!.invert!, for: .normal)
        nameButton.setTitleColor(currentTheme!.invert!, for: .normal)
        
        
        if currentTheme!.name! == "Salmon" {
            confirmButton.backgroundColor = currentTheme!.invert!
            confirmButton.setTitleColor(currentTheme!.highlight!, for: .normal)
        }
        else {
            confirmButton.backgroundColor = currentTheme!.invert!
            confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
        }
        
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
