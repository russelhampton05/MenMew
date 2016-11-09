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
    
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var locationTitle: UILabel!
    
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

        //Display current user information
        if let user = FIRAuth.auth()?.currentUser {
            
            emailButton.setTitle(user.email, for: .normal)
            passwordButton.setTitle(String(repeating: "*", count: user.email!.characters.count), for: .normal)
            nameButton.setTitle(user.displayName, for: .normal)
            
            nameTitle.text = currentUser!.name!
            locationTitle.text = "At " + restaurantName!
            
            if currentUser!.image != nil {
                profilePhoto.getImage(urlString: currentUser!.image!, circle: true)
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
        
        //Upload image to user's profile on Firebase
        UserManager.uploadImage(user: currentUser!, image: pickedImage.circle!)
        
        //Update current user with new profile image
        UserManager.getImageURL(user: currentUser!) {
            url in
            
            self.newImageURL = url
        }
        
        dismiss(animated: true, completion: nil)
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
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
