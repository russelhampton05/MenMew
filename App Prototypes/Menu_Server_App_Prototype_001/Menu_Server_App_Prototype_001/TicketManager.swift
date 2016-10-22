//
//  TicketManager.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/22/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class TicketManager {
    //This class handles ticket statuses that the app UI can use to display and update 
    //order information for each table.
    
    static let ref = FIRDatabase.database().reference().child("Tickets")
    
    static func GetTicket(id: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        
        let ticket = Ticket()
        
        ref.child(id).observe(.value, with: {(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            
            ticket.ticket_ID = value?["ticket_ID"] as? String
            ticket.tableNum = value?["tableNum"] as? String
            ticket.desc = value?["desc"] as? String
            
            //Users is an array of users registered in the system
            let users = value?["users"] as? NSDictionary
            var userArray: [String] = []
            for item in (users?.allKeys)! {
                if ((users?.value(forKey: item as! String) as! Bool) == true) {
                    userArray.append(item as! String)
                }
            }
            
            
            //UserManager needs to be created
            //Same process as in MenuItem and MenuGroup managers
            UserManager.GetUser(ids: userArray) {
                items in
                
                ticket.users = users
            }
            
            //ItemsOrdered is the array of items ordered for the table
            let menuItems = value?["menuItems"] as? NSDictionary
            var itemArray: [String] = []
            for item in (menuItems?.allKeys)! {
                if ((menuItems?.value(forKey: item as! String) as! Bool) == true) {
                    itemArray.append(item as! String)
                }
            }
            
            MenuItemManager.GetMenuItem(ids: itemArray) {
                items in
                
                ticket.itemsOrdered = items
            }
            
            //Current price is calculated via the sum + tax of the currently ordered items
            var currPrice = 0.0
            for item in ticket.itemsOrdered! {
                currPrice += item.price!
            }
            
            ticket.currPrice = currPrice
            
            completionHandler(ticket)
            
        }){(error) in
            print(error.localizedDescription)
        }
    }
	
    
    static func GetTicket(ids: [String], completionHandler: @escaping (_ tickets: [Ticket]) -> ()) {
        var tickets: [Ticket] = []
        
        let semTicket = DispatchGroup.init()
        
        for id in ids {
            var newTicket: Ticket?
            
            semTicket.enter()
            
            GetTicket(id: id) {
                ticket in
                
                newTicket = ticket
                
                tickets.append(newTicket!)
                
                semTicket.leave()
            }
        }
        
        semTicket.notify(queue: DispatchQueue.main, execute: {
            completionHandler(tickets) })
    }
}
