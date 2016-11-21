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
    @IBOutlet var touchIDLabel: UILabel!
    @IBOutlet var touchIDSwitch: UISwitch!
    @IBOutlet var notificationsLabel: UILabel!
    @IBOutlet var notificationsSwitch: UISwitch!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var themeDesc: UILabel!
    @IBOutlet var touchIDDesc: UILabel!
    @IBOutlet var notificationsDesc: UILabel!
    
    //Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTheme()
        
        themeButton.setTitle(currentTheme!.name!, for: .normal)
        touchIDSwitch.isOn = currentUser!.touchEnabled
        notificationsSwitch.isOn = currentUser!.notifications
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
    
    @IBAction func touchIDSwitchPressed(_ sender: Any) {
        currentUser!.touchEnabled = touchIDSwitch.isOn
        UserManager.UpdateTouchIDPreference(user: currentUser!, pref: touchIDSwitch.isOn)
    }
    
    @IBAction func notificationsSwitchPressed(_ sender: Any) {
        currentUser!.notifications = notificationsSwitch.isOn
        UserManager.UpdateNotificationPreference(user: currentUser!, pref: notificationsSwitch.isOn)
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
        touchIDLabel.textColor = currentTheme!.invert!
        notificationsLabel.textColor = currentTheme!.invert!
        themeDesc.textColor = currentTheme!.invert!
        touchIDDesc.textColor = currentTheme!.invert!
        notificationsDesc.textColor = currentTheme!.invert!
        
        //Buttons
        themeButton.setTitleColor(currentTheme!.invert!, for: .normal)
        touchIDSwitch.thumbTintColor = currentTheme!.invert!
        notificationsSwitch.thumbTintColor = currentTheme!.invert!
        touchIDSwitch.onTintColor = UIColor.lightGray
        notificationsSwitch.onTintColor = UIColor.lightGray
        
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
