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
import FirebaseStorage

///this class needs love! Needs to be updated to look like the Menu Manager / Ticket Manager classes
//also need to add gathering of tickets
//should only grab ticket ids that show up with value FALSE (unpaid) under users->userid->tickets->ticketid: FALSE. Shouldn't be more than one by design (one per rest id)
//Ticket population can't happen until rest id is found! 

class UserManager{
    
    static let ref = FIRDatabase.database().reference().child("Users")
    
    
    //used for creation / updating
    static func UpdateUser(user: User){
        
        //Create new user entry on database
        UserManager.ref.child(user.ID).child("name").setValue(user.name)
        UserManager.ref.child(user.ID).child("email").setValue(user.email)
        UserManager.ref.child(user.ID).child("theme").setValue(user.theme)
        UserManager.ref.child(user.ID).child("image").setValue(user.image)
        UserManager.ref.child(user.ID).child("touchEnabled").setValue(user.touchEnabled)
        
    }
    
    static func GetUser(id: String, completionHandler: @escaping (_ user: User) -> ()) {
        
        let user = User(id: id, email: nil, name: nil, ticket: nil, image: nil, theme: nil)

        UserManager.ref.child(id).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary

            user.name = value?["name"] as? String
            user.email = value?["email"] as? String
            user.image = value?["image"] as? String
            user.theme = value?["theme"] as? String
            user.touchEnabled = value?["touchEnabled"] as! Bool
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
            let tickets = value?["tickets"] as? NSDictionary

            var openTickets: [String] = []
            if tickets != nil {
                
                for item in (tickets?.allKeys)! {
                    if tickets?.value(forKey: item as! String) as! Bool == false {
                        openTickets.append((item as? String)!)
                    }
                }
                
                let semTicket = DispatchGroup.init()
                
                if openTickets.count > 0 {
                    for openTicket in openTickets {
                        
                        semTicket.enter()
                        
                        TicketManager.GetTicket(id: openTicket, restaurant: restaurant)	{
                            ticket in
                            
                            
                            if ticket.restaurant_ID == restaurant {
                                currentTicket = ticket
                                
                                semTicket.leave()
                            }
                                
                            else {
                                CreateTicket(user: user, ticket: nil, restaurant: restaurant) {
                                    ticket in
                                    
                                    currentTicket = ticket
                                    
                                    semTicket.leave()
                                }
                            }
                        }
                    }
                }
                else {
                    CreateTicket(user: user, ticket: nil, restaurant: restaurant) {
                        ticket in
                        
                        currentTicket = ticket
                    }
                }
                semTicket.notify(queue: DispatchQueue.main, execute: {
                    completionHandler(currentTicket)
                })
                
            }
            else {
                CreateTicket(user: user, ticket: nil, restaurant: restaurant) {
                    ticket in
                    
                    completionHandler(ticket)
                }
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
                    SetTicket(user: user, ticket: currentTicket, toRemove: nil) {
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
            var uuid = UUID().uuidString.lowercased()
            uuid = uuid.replacingOccurrences(of: "-", with: "")

            currentTicket.user_ID = user.ID
            currentTicket.tableNum = ""
            currentTicket.restaurant_ID = restaurant
            currentTicket.ticket_ID = uuid
            currentTicket.desc = UserManager.randomString(length: 6)
            currentTicket.status = "Ordering"
            currentTicket.confirmed = false
            currentTicket.paid = false
            currentTicket.tip = 0.0
            currentTicket.total = 0.0
            currentTicket.generateMessageGUID()
            MessageManager.CreateTicketAsync(id: currentTicket.message_ID!)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let currentDate = Date()
            
            currentTicket.timestamp = formatter.string(from: currentDate)
            
            SetTicket(user: user, ticket: currentTicket, toRemove: nil) {
                completed in
                
                if completed {
                    completionHandler(currentTicket)
                }
            }
        }
    }
    
    //Update ticket status
    static func UpdateTicketStatus(user: User, ticket: String, status: String) {
        TicketManager.ref.child(ticket).child("status").setValue(status)
    }
    
    //Update table number
    static func UpdateTicketTable(user: User, ticket: String, table: String) {
        TicketManager.ref.child(ticket).child("table").setValue(table)
    }
    
    //Update TouchID preference
    static func UpdateTouchIDPreference(user: User, pref: Bool) {
        ref.child(user.ID).child("touchEnabled").setValue(pref)
    }
    
    //Update name
    static func UpdateUserName(user: User, name: String) {
        ref.child(user.ID).child("name").setValue(name)
    }
    
    static func SetTicket(user: User, ticket: Ticket, toRemove: [String]?, completionHandler: @escaping (_ completed: Bool) -> ()) {
        
        //Update user details
        UserManager.ref.child(user.ID).child("tickets").child(ticket.ticket_ID!).setValue(false)
        
        //Update restaurant, table information
        TicketManager.ref.child(ticket.ticket_ID!).child("restaurant").setValue(ticket.restaurant_ID)
        TicketManager.ref.child(ticket.ticket_ID!).child("desc").setValue(ticket.desc)
        TicketManager.ref.child(ticket.ticket_ID!).child("table").setValue(ticket.tableNum)
        TicketManager.ref.child(ticket.ticket_ID!).child("user").setValue(ticket.user_ID)
        
        //Update timestamp, confirmed and status
        TicketManager.ref.child(ticket.ticket_ID!).child("timestamp").setValue(ticket.timestamp)
        TicketManager.ref.child(ticket.ticket_ID!).child("confirmed").setValue(ticket.confirmed)
        TicketManager.ref.child(ticket.ticket_ID!).child("status").setValue(ticket.status)
        
        //Update current total
        TicketManager.ref.child(ticket.ticket_ID!).child("paid").setValue(ticket.paid)
        TicketManager.ref.child(ticket.ticket_ID!).child("tip").setValue(ticket.tip)
        TicketManager.ref.child(ticket.ticket_ID!).child("total").setValue(ticket.total)
        
        //Update message id
        TicketManager.ref.child(ticket.ticket_ID!).child("message").setValue(ticket.message_ID)
        
        
        var itemFreq: [String:Int] = [:]
        
        for item in ticket.itemsOrdered! {
            itemFreq[item.item_ID!] = (itemFreq[item.item_ID!] ?? 0) + 1
        }
        
        if toRemove != nil {
            for item in toRemove! {
                TicketManager.ref.child(ticket.ticket_ID!).child("itemsOrdered").child(item).setValue(nil)
            }
        }
        
        
        for (key, value) in itemFreq {
            TicketManager.ref.child(ticket.ticket_ID!).child("itemsOrdered").child(key).setValue(value)
        }
        

        
        completionHandler(true)
    }
    
    static func uploadImage(user: User, image: UIImage, completionHandler: @escaping (_ done: Bool) -> ()) {
        
        //Initialize storage reference
        let data = UIImagePNGRepresentation(image)
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        let userPhotosRef = storageRef.child("UserPhotos")
        let userRef = userPhotosRef.child(user.ID)
        let imageRef = userRef.child("profile.jpg")
        
        let uploadTask = imageRef.put(data!, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            else {
                //Replace previous image reference
                let newImageURL: String = metadata!.downloadURL()!.absoluteString
                ref.child(user.ID).child("image").setValue(newImageURL)
                
                completionHandler(true)
            }
        }
        
    }
    
    static func getImageURL(user: User, completionHandler: @escaping (_ url: String) -> ()) {
        
        UserManager.ref.child(user.ID).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            
            let imgURL = value?["image"] as? String
            
            completionHandler(imgURL!)
        })
    }
    
    static func setTheme(user: User, theme: String) {
        ref.child(user.ID).child("theme").setValue(theme)
    }
    
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
   
}
