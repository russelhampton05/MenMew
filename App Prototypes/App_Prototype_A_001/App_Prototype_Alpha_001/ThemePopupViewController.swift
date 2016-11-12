//
//  ThemePopupViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/11/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class ThemePopupViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var themeTitle: UILabel!
    @IBOutlet var theme1View: UIView!
    @IBOutlet var theme2View: UIView!
    @IBOutlet var theme3View: UIView!
    @IBOutlet var theme4View: UIView!
    
    @IBOutlet var popupView: UIView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var theme1GestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var theme2GestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var theme3GestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var theme4GestureRecognizer: UITapGestureRecognizer!
    
    
    //Variables
    var newTheme: Theme?
    var oldTheme: Theme?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.showAnimate()
        
        themeTitle.text = currentUser!.theme!
        oldTheme = currentTheme
        
        initializeGestureRecognizers()
        loadCircles()
        loadTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        currentUser!.theme = themeTitle.text
        UserManager.setTheme(user: currentUser!, theme: themeTitle.text!)
        
        removeAnimate()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        currentTheme = oldTheme
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
                if let parent = self.parent as? ProfileViewController {
                    parent.themeButton.setTitle(currentUser!.theme, for: .normal)
                    parent.reloadTheme()
                }
                self.view.removeFromSuperview()
            }
        })
    }
    
    
    //Theme press function
    func themeTapped(selectedTheme: UITapGestureRecognizer) {
        
        if selectedTheme == theme1GestureRecognizer {
            newTheme = Theme.init(type: "Salmon")
            themeTitle.text = "Salmon"
        }
        else if selectedTheme == theme2GestureRecognizer {
            newTheme = Theme.init(type: "Light")
            themeTitle.text = "Light"
        }
        else if selectedTheme == theme3GestureRecognizer {
            newTheme = Theme.init(type: "Midnight")
            themeTitle.text = "Midnight"
        }
        else if selectedTheme == theme4GestureRecognizer {
            newTheme = Theme.init(type: "Slate")
            themeTitle.text = "Slate"
        }
        
        currentTheme = newTheme
        loadTheme()
        
    }
    
    
    //Initialize tap gestures on theme buttons
    func initializeGestureRecognizers() {
        theme1GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(selectedTheme:)))
        theme2GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(selectedTheme:)))
        theme3GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(selectedTheme:)))
        theme4GestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(selectedTheme:)))
        
        theme1View.isUserInteractionEnabled = true
        theme2View.isUserInteractionEnabled = true
        theme3View.isUserInteractionEnabled = true
        theme4View.isUserInteractionEnabled = true
        
        theme1View.addGestureRecognizer(theme1GestureRecognizer)
        theme2View.addGestureRecognizer(theme2GestureRecognizer)
        theme3View.addGestureRecognizer(theme3GestureRecognizer)
        theme4View.addGestureRecognizer(theme4GestureRecognizer)
    }
    
    //Set theme buttons to be circles
    func loadCircles() {
        theme1View.layer.cornerRadius = theme1View.frame.size.width/2
        theme1View.clipsToBounds = true
        
        theme2View.layer.cornerRadius = theme2View.frame.size.width/2
        theme2View.clipsToBounds = true
        
        theme3View.layer.cornerRadius = theme3View.frame.size.width/2
        theme3View.clipsToBounds = true
        
        theme4View.layer.cornerRadius = theme4View.frame.size.width/2
        theme4View.clipsToBounds = true
    }

    func loadTheme() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            //Background and Tint
            self.view.tintColor = currentTheme!.invert!
            self.popupView.backgroundColor = currentTheme!.secondary!
            
            //Labels
            self.themeLabel.textColor = currentTheme!.invert!
            self.themeTitle.textColor = currentTheme!.invert!
            
            //Views
            self.theme1View.backgroundColor = UIColor(red: 255, green: 106, blue: 92)
            self.theme2View.backgroundColor = UIColor(red: 255, green: 141, blue: 43)
            self.theme3View.backgroundColor = UIColor(red: 55, green: 30, blue: 96)
            self.theme4View.backgroundColor = UIColor(red: 27, green: 27, blue: 27)
            
            //Buttons
            
            if currentTheme!.name! == "Salmon" {
                self.confirmButton.backgroundColor = currentTheme!.invert!
                self.confirmButton.setTitleColor(currentTheme!.highlight!, for: .normal)
                self.cancelButton.backgroundColor = currentTheme!.invert!
                self.cancelButton.setTitleColor(currentTheme!.highlight!, for: .normal)
            }
            else {
                self.confirmButton.backgroundColor = currentTheme!.highlight!
                self.confirmButton.setTitleColor(currentTheme!.primary!, for: .normal)
                self.cancelButton.backgroundColor = currentTheme!.highlight!
                self.cancelButton.setTitleColor(currentTheme!.primary!, for: .normal)
            }
            
        })
    }
}
