//
//  RestaurantViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/16/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase


//might have to decide if this class is even actually worth keeping.
//The only reason it would be worth having still is if we wanted real time swapping of
//menus. That logic for deciding which menu would go here.

class RestaurantViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var loadingTitle: UILabel!
    
    //Variables
    var menu: Menu?
    var counter: Int = 0
    var menuID : String?
    //var currentTable: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.restaurantLabel.isHidden = true
        self.tableLabel.isHidden = true
        
        //Check for user and restaurant IDs to load tickets
        loadRestaurantInformation()
        
        loadTheme()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func delay(_ time: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainMenuSegue" {
            let mainMenuVC = segue.destination as! MainMenuViewController
            
            mainMenuVC.menu = self.menu
            //mainMenuVC.currentTable = self.currentTable!
            mainMenuVC.ticket = currentUser!.ticket!
        }
        else if segue.identifier == "QRReturnSegue" {
            let qrVC = segue.destination as! QRViewController
        }
    }
    
    func printError() {
        let errorPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(errorPopup)
        self.view.addSubview(errorPopup.view)
        errorPopup.didMove(toParentViewController: self)
        errorPopup.addMessage(context: "QRError")
    }
    
    func loadUserInformation() {
        //Check Firebase for user
        
        //This needs love! Check to see if logged in user exists, if he doesn't MAKE a new user in our
        //FB for him.
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                UserManager.GetUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                    user in
                    
                    currentUser = user
                    
                    self.loadRestaurantInformation()
                }
                
            } else {
                // No user is signed in.
            }
        }
    }
    
    func loadTicketInformation() {
        UserManager.GetTicket(user: currentUser!, restaurant: (menu?.rest_id!)!) {
            ticket in
            
            //Assign current ticket and table
            if ticket.ticket_ID != nil {
                
                UserManager.UpdateTicketTable(user: currentUser!, ticket: ticket.ticket_ID!, table: currentTable!)
                ticket.tableNum = currentTable!
                currentUser!.ticket = ticket
                
                self.restaurantLabel.text = self.menu!.title!
                self.tableLabel.text = "Table " + currentTable!
                
                
                //Transition animation
                let fadeTransition = CATransition()
                fadeTransition.duration = 1.0
                fadeTransition.type = kCATransitionFade
                self.restaurantLabel.layer.add(fadeTransition, forKey: "fadeText")
                self.tableLabel.layer.add(fadeTransition, forKey: "fadeText")
                
                self.restaurantLabel.isHidden = false
                self.tableLabel.isHidden = false
                
                
            }
            
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
            }
            
        }
    }
    
    func loadRestaurantInformation() {
        MenuManager.GetMenu(id: menuID!) {
            menu in
            
            self.menu = menu
            
            if menu.menu_groups == nil {
                self.printError()
            }
            else {
                currentRestaurant =  menu
                
                self.loadTicketInformation()
            }
        }
    }
    
    func loadTheme() {
        //Background and Tint
        self.view.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
        
        //Navigation
        UINavigationBar.appearance().backgroundColor = currentTheme!.primary!
        UINavigationBar.appearance().tintColor = currentTheme!.highlight!
        self.navigationController?.navigationBar.barTintColor = currentTheme!.primary!
        self.navigationController?.navigationBar.tintColor = currentTheme!.highlight!
        
        //Labels
        self.restaurantLabel.textColor = currentTheme!.highlight!
        self.tableLabel.textColor = currentTheme!.highlight!
        loadingTitle.textColor = currentTheme!.highlight!
        
        //Buttons
    }
}
