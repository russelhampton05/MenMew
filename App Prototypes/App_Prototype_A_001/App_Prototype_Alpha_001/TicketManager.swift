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
    
    static func GetTicket(id: String, restaurant: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        
        let ticket = Ticket()
        
        ref.child(id).observe(.value, with: {(FIRDataSnapshot) in
        ref.child(id).observeSingleEvent(of: .value, with: {(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            
            if value?["restaurant"] as? String == restaurant {
                ticket.ticket_ID = id
                ticket.user_ID = value?["user"] as? String
                ticket.restaurant_ID = value?["restaurant"] as? String
                ticket.tableNum = value?["tableNum"] as? String
                ticket.timestamp = value?["timestamp"] as? String
                ticket.paid = value?["paid"] as! Bool
                ticket.desc = value?["desc"] as? String
            
            
                //ItemsOrdered is the array of items ordered for the table
                let menuItems = value?["itemsOrdered"] as? NSDictionary
            
                var itemArray: [String] = []
                var quantityArray: [Int] = []
                for item in (menuItems?.allKeys)! {
                    itemArray.append(item as! String)
                    quantityArray.append(menuItems?.value(forKey: item as! String) as! Int)
                }
            
                let semItem = DispatchGroup.init()
                semItem.enter()
                
                MenuItemManager.GetMenuItem(ids: itemArray) {
                    items in
                
                    var orderedArray: [MenuItem] = []
                
                    //Build the array of tuples
                    for index in 0...items.count-1 {
                        orderedArray.append(items[index])
                    }
                
                    ticket.itemsOrdered = orderedArray
                
                    semItem.leave()
                }
            
                semItem.notify(queue: DispatchQueue.main, execute: {
                    completionHandler(ticket) })
                }
            else {
                completionHandler(ticket)
            }
            
        }){(error) in
            print(error.localizedDescription)}
    }
    
    
    static func GetTicket(ids: [String], restaurant: String, completionHandler: @escaping (_ tickets: [Ticket]) -> ()) {
        var tickets: [Ticket] = []
        
        let semTicket = DispatchGroup.init()
        
        for id in ids {
            var newTicket: Ticket?
            
            semTicket.enter()
            
            GetTicket(id: id, restaurant: restaurant) {
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
