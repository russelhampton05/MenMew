//
//  AppSettingsViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 11/21/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet var settingsLine: UIView!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var themeButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var themeDesc: UILabel!
    
    //Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTheme()
        
        themeButton.setTitle(currentTheme!.name!, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Instantiate the theme popup
    func initiateThemePopup() {
        let themePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemePopup") as! ThemePopupViewController
        
        self.addChildViewController(themePopup)
        self.view.addSubview(themePopup.view)
        themePopup.didMove(toParentViewController: self)
    }
    
    //Button Actions
    @IBAction func themeButtonPressed(_ sender: Any) {
        initiateThemePopup()
    }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UnwindToSettingsSegue", sender: self)
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.secondary!
        self.view.tintColor = currentTheme!.invert!
        
        //Labels
        settingsLabel.textColor = currentTheme!.invert!
        settingsLine.backgroundColor = currentTheme!.invert!
        themeLabel.textColor = currentTheme!.invert!
        themeDesc.textColor = currentTheme!.invert!
        
        //Buttons
        themeButton.setTitleColor(currentTheme!.invert!, for: .normal)

        
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
