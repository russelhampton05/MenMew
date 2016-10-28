//
//  UserManager.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

///this class needs love! Needs to be updated to look like the Menu Manager / Ticket Manager classes
//also need to add gathering of tickets
//should only grab ticket ids that show up with value FALSE (unpaid) under users->userid->tickets->ticketid: FALSE. Shouldn't be more than one by design (one per rest id)
//Ticket population can't happen until rest id is found!

class UserManager{
    
    static let ref = FIRDatabase.database().reference().child("Users")
    
    static func AddUser(user: User){
        
        //Create new user entry on database
        UserManager.ref.child(user.ID).child("name").setValue(user.name)
        UserManager.ref.child(user.ID).child("email").setValue(user.email)
        
        return
    }
    
    static func GetUser(id: String, completionHandler: @escaping (_ user: User) -> ()) {
        
        let user = User(id: id, email: nil, name: nil, ticket: nil)
        
        UserManager.ref.child(id).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            user.name = value?["name"] as? String
            user.email = value?["email"] as? String
            
            
            //Defer ticket retrieval to a separate function
            user.ticket = nil
            
            completionHandler(user)
            
        }) {(error) in
            print(error.localizedDescription)}
        
    }
    
    static func GetTicket(user: User, restaurant: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        
        var currentTicket = Ticket()
        
        UserManager.ref.child(user.ID).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            
            //Get tickets
            var tickets = value?["tickets"] as? NSDictionary
            //var currentTicketID: String?
            var openTickets: [String] = []
            if tickets != nil {
                
                for item in (tickets?.allKeys)! {
                    if tickets?.value(forKey: item as! String) as! Bool == false {
                        openTickets.append((item as? String)!)
                    }
                }
                
                let semTicket = DispatchGroup.init()
                semTicket.enter()
                
                for openTicket in openTickets {
                    
                    
                    TicketManager.GetTicket(id: openTicket, restaurant: restaurant)	{
                        ticket in
                        
                        currentTicket = ticket
                        
                        if currentTicket.restaurant_ID == restaurant {
                            semTicket.leave()
                        }
                    }
                }
                
                semTicket.notify(queue: DispatchQueue.main, execute: {
                    completionHandler(currentTicket)
                })
                
            }
            else {
                tickets = nil
                completionHandler(currentTicket)
            }
            
            
        }) {(error) in
            print(error.localizedDescription)}
        
    }
    
    static func CreateTicket(user: User, ticket: Ticket?, restaurant: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        var currentTicket = Ticket()
        
        if ticket != nil {
            currentTicket = ticket!
            
            GetTicket(user: user, restaurant: restaurant) {
                ticket in
                
                if ticket.ticket_ID == currentTicket.ticket_ID {
                    
                    //Set the ticket
                    SetTicket(user: user, ticket: currentTicket) {
                        completed in
                        
                        if completed {
                            completionHandler(ticket)
                        }
                    }
                }
                else {
                    completionHandler(currentTicket)
                }
            }
        }
        else {
            //Otherwise, create a new ticket entry by generating a UID
            let uuid = UUID().uuidString
            currentTicket.ticket_ID = uuid
            
            completionHandler(currentTicket)
        }
    }
    
    static func SetTicket(user: User, ticket: Ticket, completionHandler: @escaping (_ completed: Bool) -> ()) {
        UserManager.ref.child(user.ID).child("tickets").child(ticket.ticket_ID!).setValue(false)
        TicketManager.ref.child(ticket.ticket_ID!).child("timestamp").setValue(ticket.timestamp)
        
        var itemFreq: [String:Int] = [:]
        
        for item in ticket.itemsOrdered! {
            itemFreq[item.item_ID!] = (itemFreq[item.item_ID!] ?? 0) + 1
        }
        
        for (key, value) in itemFreq {
            TicketManager.ref.child(ticket.ticket_ID!).child("itemsOrdered").child(key).setValue(value)
        }
        
        completionHandler(true)
    }
    
    static func CompleteTicket(user: User, ticket: String) {
        UserManager.ref.child(String(user.ID)).child("tickets").child(String(ticket)).setValue(true)
    }
    
}