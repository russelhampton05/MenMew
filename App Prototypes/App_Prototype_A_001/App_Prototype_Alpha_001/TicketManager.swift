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
    
    
    static func UpdatePayTicket(ticket: Ticket, isPaid: Bool ){
        ref.child(ticket.ticket_ID!).updateChildValues(["paid": isPaid])
        ref.child(ticket.ticket_ID!).child("tip").setValue(ticket.tip)
        
        //Update in Users
        UserManager.ref.child(ticket.user_ID!).child("tickets").child(ticket.ticket_ID!).setValue(true)
    }
    static func GetTicket(id: String, restaurant: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        
        var ticket = Ticket()
        
        //ref.child(id).observe(.value, with: {(FIRDataSnapshot) in
        ref.child(id).observeSingleEvent(of: .value, with: {(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            
            if value?["restaurant"] as? String == restaurant {
                
                ticket = Ticket(value)
                
                //ItemsOrdered is the array of items ordered for the table
                let menuItems = value?["itemsOrdered"] as? NSDictionary
            
                var itemArray: [String] = []
                var quantityArray: [Int] = []
                if menuItems != nil {
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
                    ticket.itemsOrdered = []
                    completionHandler(ticket)
                }

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
