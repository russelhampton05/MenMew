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
    
    static let ref = FIRDatabase.database().reference().child("users")
    
    static func AddUser(user: User) {
        guard user.otherInformation != nil else {
            UserManager.ref.child(user.ID).setValue(["otherStuff": ""])
            return
        }
        
        UserManager.ref.child(String(user.ID)).setValue(["otherStuff": user.otherInformation])
    }
    
    static func AddUser(id: String, otherStuff: String? = nil){
        guard let otherStuff = otherStuff else {
            UserManager.ref.child(id).setValue(["otherStuff": ""])
            return
        }
        
        UserManager.ref.child(id).setValue(["otherStuff": otherStuff])
        
    }
    
    static func GetUser(id: String) {
        var test: String?
        UserManager.ref.child("123").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let otherstuff = value?["otherStuff"] as! String
            test = otherstuff
        }) {(error) in
            print(error.localizedDescription)
            test = error.localizedDescription}
        
    }
    
    static func CreateTicket(user: User, restaurant: String) -> Ticket {
        var ticket = Ticket()
        ref.child(user.ID).child("tickets").observe(.value, with: {(FIRDataSnapshot) in
            if FIRDataSnapshot.value as! Bool == false {
                FIRDatabase.database().reference().child("tickets").child(FIRDataSnapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value?["restaurant"] as! String == restaurant {
                        TicketManager.GetTicket(id: FIRDataSnapshot.key) {
                            retrievedTicket in
                            ticket = retrievedTicket
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                // Create new ticket
            }
            
        }){(error) in
            print(error.localizedDescription)}
        return ticket
    }
    
    static func CompleteTicket(user: User, ticket: String) {
        UserManager.ref.child(String(user.ID)).child("tickets").child(String(ticket)).setValue(true)
    }
    
}
