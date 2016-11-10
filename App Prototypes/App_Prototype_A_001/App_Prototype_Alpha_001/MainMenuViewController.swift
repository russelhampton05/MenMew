//
//  MainMenuViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/17/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import UserNotificationsUI
import Firebase

class MainMenuViewController: UITableViewController {
    
    //IBOutlets
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var ordersButton: UIBarButtonItem!
    @IBOutlet weak var restaurantLabel: UINavigationItem!

    //Variables
    var orderArray: [(title: String, price: Double)] = []
    let requestIdentifier = "Request"
    var menu: Menu?
    var ticket: Ticket?
    var segueIndex: Int?
    var menuArray = [[MenuItem]]()
    var categoryArray = [(name: String, desc: String)]()
    var restaurant: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        restaurantLabel.title = menu?.title
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Check for existing orders
        if ticket != nil && ticket!.itemsOrdered!.count > 0 {
            ordersButton.isEnabled = true
        }
        else {
            ordersButton.isEnabled = false
        }
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        initializeNotificationObserver()
        loadTheme()
    }
    
    func initializeNotificationObserver() {
        let messageRef = FIRDatabase.database().reference().child("Messages")
        
        messageRef.observe(.value, with:{(FIRDataSnapshot) in
            
            for item in FIRDataSnapshot.children {
                
                let message = Message(snapshot: item as! FIRDataSnapshot)
                //let messageItem = item as? NSDictionary
                //let serverMessage = messageItem?["server"] as? String
                
                if message.userMessage != "nil" && message.message_ID == self.ticket!.message_ID! {
                    let content = UNMutableNotificationContent()
                    content.title = "User Alert"
                    content.body = message.userMessage!
                    content.sound = UNNotificationSound.default()
                    
                    
                    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
                    let request = UNNotificationRequest(identifier: self.requestIdentifier, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().delegate = self
                    UNUserNotificationCenter.current().add(request){(error) in
                        
                        if (error != nil){
                            
                            print(error!.localizedDescription)
                        }
                    }
                    
                    MessageManager.WriteUserMessage(id: message.message_ID!, message: "nil")
                }
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("MenuCell")) as UITableViewCell!
        
        cell?.textLabel!.text = menu?.menu_groups?[(indexPath as NSIndexPath).row].title
        cell?.detailTextLabel!.text = menu?.menu_groups?[(indexPath as NSIndexPath).row].desc
        
        cell?.backgroundColor = currentTheme!.bgColor!
        cell?.textLabel!.textColor = currentTheme!.hlColor!
        cell?.detailTextLabel!.textColor = currentTheme!.hlColor!

        let bgView = UIView()
        bgView.backgroundColor = currentTheme!.hlColor!
        cell?.selectedBackgroundView = bgView
        cell?.textLabel?.highlightedTextColor = currentTheme!.bgColor!
        cell?.detailTextLabel?.highlightedTextColor = currentTheme!.bgColor!
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = (indexPath as NSIndexPath).row
        self.performSegue(withIdentifier: "CategoryDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return categoryArray.count
        if menu?.menu_groups != nil {
            return (menu?.menu_groups?.count)!
        }
        else {
            return 0
        }
    }
    
    override func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetailSegue" {
            let menuVC = segue.destination as! MenuDetailsViewController
            menuVC.menu = menu!
            menuVC.menu_group = menu?.menu_groups![segueIndex!]
            menuVC.ticket = self.ticket
            menuVC.restaurantName = menu?.title
            //menuVC.currentTable = currentTable!
        }
        else if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController

        }
        else if segue.identifier == "OrderSummarySegue" {
            let orderVC = segue.destination as! SummaryViewController
            
            orderVC.ticket = ticket!
        }
    }
    
 
    //Unwind Segues
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        self.navigationController?.isNavigationBarHidden = false
        
        if let sourceVC = sender.source as? MenuDetailsViewController {
            ticket = sourceVC.ticket
            
            if (ticket?.itemsOrdered?.count)! > 0 {
                ordersButton.isEnabled = true
            }
        }
        else if let sourceVC = sender.source as? OrderConfirmationViewController {
            ticket = sourceVC.ticket
            
            if (ticket?.itemsOrdered?.count)! > 0 {
                ordersButton.isEnabled = true
            }
        }
        else if let sourceVC = sender.source as? SummaryViewController {
            ticket = sourceVC.ticket
            
            ordersButton.isEnabled = false
        }
        else if let sourceVC = sender.source as? PaymentSummaryViewController {
            ticket = sourceVC.ticket
            
            if ticket!.paid! {
                ordersButton.isEnabled = false
                
                ticket = nil
            }
        }
    }

    @IBAction func ordersButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "OrderSummarySegue", sender: self)
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.bgColor!
        self.view.tintColor = currentTheme!.hlColor!
        tableView.backgroundColor = currentTheme!.bgColor!
        
        //Navigation
        UINavigationBar.appearance().backgroundColor = currentTheme!.bgColor!
        UINavigationBar.appearance().tintColor = currentTheme!.hlColor!
        self.navigationController?.navigationBar.barTintColor = currentTheme!.bgColor!
        self.navigationController?.navigationBar.tintColor = currentTheme!.hlColor!
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: currentTheme!.hlColor!, NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)]
        
        //Labels
        
        //Buttons
    }
}

extension MainMenuViewController: UNUserNotificationCenterDelegate {
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier {
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
