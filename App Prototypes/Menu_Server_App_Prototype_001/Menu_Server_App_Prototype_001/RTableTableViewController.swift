//
//  RTableTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import UserNotificationsUI

class RTableTableViewController: UITableViewController {
    
    //Reference
    let ref = FIRDatabase.database().reference().child("Tickets")
    
    //Variables
    var restaurant: Restaurant?
    var location: String?
    var segueIndex: Int?
    let formatter = DateFormatter()
    var ticketList: [Ticket] = []
    var ticketIDList: [String] = []
    let requestIdentifier = "Request"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.title = restaurant!.title!
        
        initializeTickets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentServer!.notifications {
            initializeNotificationObserver()
        }
        else {
            deinitializeObservers()
        }
        
        loadTheme()
        tableView.reloadData()
    }
    
    func initializeTickets() {
        //Observe for updates
        ref.observe(.value, with:{(FIRDataSnapshot) in
            var ticketList: [Ticket] = []
            var ticketIDList: [String] = []
            for item in FIRDataSnapshot.children {
                let ticket = Ticket(snapshot: item as! FIRDataSnapshot)
                
                let snapshotItem = item as! FIRDataSnapshot
                let snapshotValue = snapshotItem.value as! [String: AnyObject]
                let menuItems = snapshotValue["itemsOrdered"] as? NSDictionary
                
                
                //I'm assuming this is pass by reference, so the ticket passed in should be changed when this is done
                
                //Also this is intentionally async to prevent UI Drag.
                if menuItems != nil{
                    TicketManager.PopulateTicketItemsAsync(ticket: ticket, items: menuItems!)
                    
                    
                    if ticket.restaurant_ID == self.restaurant!.restaurant_ID! {
                        if ticket.tableNum != nil {
                            if currentServer!.tables!.contains(ticket.tableNum!) {
                                ticketList.append(ticket)
                                ticketIDList.append(ticket.message_ID!)
                            }
                        }
                    }
                }
                else {
                    
                    if ticket.restaurant_ID == self.restaurant!.restaurant_ID! {
                        if ticket.tableNum != nil {
                            if currentServer!.tables!.contains(ticket.tableNum!) {
                                ticketList.append(ticket)
                                ticketIDList.append(ticket.message_ID!)
                            }
                        }
                    }
                }
                
                
            }
            
            //Initialize date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
            //Sort tickets by datetime
            ticketList.sort() {dateFormatter.date(from: $0.timestamp!)! > dateFormatter.date(from: $1.timestamp!)!}
            
            self.ticketList = ticketList
            self.ticketIDList = ticketIDList
            self.tableView.reloadData()
            
        }){(error) in
            print(error.localizedDescription)}
    }
    
    func deinitializeObservers() {
        let messageRef = FIRDatabase.database().reference().child("Messages")
        messageRef.removeAllObservers()
    }
    
    @IBAction func initializeNotificationObserver() {
        let messageRef = FIRDatabase.database().reference().child("Messages")
        
        messageRef.observe(.value, with:{(FIRDataSnapshot) in
            
            for item in FIRDataSnapshot.children {
                
                let message = Message(snapshot: item as! FIRDataSnapshot)
                
                if self.ticketIDList.contains(message.message_ID!) {
                    if message.serverMessage != "nil" {
                        let content = UNMutableNotificationContent()
                        content.title = "Server Alert"
                        content.body = message.serverMessage!
                        content.sound = UNNotificationSound.default()
                        
                        
                        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
                        let request = UNNotificationRequest(identifier: self.requestIdentifier, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().delegate = self
                        UNUserNotificationCenter.current().add(request){(error) in
                            
                            if (error != nil){
                                
                                print(error!.localizedDescription)
                            }
                        }
                        
                        MessageManager.WriteServerMessage(id: message.message_ID!, message: "nil")
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ticketList.count == 0 {
            return 1
        }
        else {
            return ticketList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! RTableCell
        
        //Theme
        cell.backgroundColor = currentTheme!.primary!
        cell.tintColor = currentTheme!.highlight!
        cell.tableLabel.textColor = currentTheme!.highlight!
        cell.ticketLabel.textColor = currentTheme!.highlight!
        cell.statusLabel.textColor = currentTheme!.highlight!
        cell.tableLabel.textColor = currentTheme!.highlight!
        cell.dateLabel.textColor = currentTheme!.highlight!
        
        //Get updated information regarding status
        if ticketList.count > 0 {
            tableView.isUserInteractionEnabled = true
            cell.tableLabel.text = "Table " + ticketList[indexPath.row].tableNum!
            cell.ticketLabel.text = "Ticket " + ticketList[indexPath.row].desc!
            cell.statusLabel.text = ticketList[indexPath.row].status!
            
            //Format date to more human-readable result
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let currentDate = formatter.date(from:ticketList[indexPath.row].timestamp!)
            
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            
            
            //Interaction
            let bgView = UIView()
            bgView.backgroundColor = currentTheme!.highlight!
            cell.selectedBackgroundView = bgView
            cell.tableLabel.highlightedTextColor = currentTheme!.primary!
            cell.ticketLabel.highlightedTextColor = currentTheme!.primary!
            cell.statusLabel.highlightedTextColor = currentTheme!.primary!
            cell.tableLabel.highlightedTextColor = currentTheme!.primary!
            cell.dateLabel.highlightedTextColor = currentTheme!.primary!
            
            cell.dateLabel.text = formatter.string(from: currentDate!)
        }
        
        else {
            cell.tableLabel.text = "No active tables assigned."
            cell.dateLabel.text = ""
            cell.statusLabel.text = ""
            cell.ticketLabel.text = ""
            tableView.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = indexPath.row
        performSegue(withIdentifier: "TableDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableDetailSegue" {
            let tableDetailVC = segue.destination as! TableDetailViewController
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            tableDetailVC.ticket = ticketList[segueIndex!]
            currentTicket = ticketList[segueIndex!]
        }
    }
    
    @IBAction func unwindToTableList(_ sender: UIStoryboardSegue) {
        if sender.source is TableDetailViewController {
            
            //Update states and date for order fulfillment
            ticketList[segueIndex!].paid = true
            
            //Update timestamp
            let date = NSDate()
            let currentDate = formatter.string(from: date as Date)
            ticketList[segueIndex!].timestamp = currentDate
            
            //RestaurantManager.UpdateTicket(ticket: ticketList[segueIndex!], restaurant: restaurant)
            tableView.reloadData()
        }
    }
    
    func loadTheme() {
        //Background and Tint
        self.view.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
    }
}

extension RTableTableViewController: UNUserNotificationCenterDelegate {
    
    
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
