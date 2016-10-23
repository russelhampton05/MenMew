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
    
    static func AddUser(user: User) {
        guard user.name != nil else {

            return
        }
        
        //Add user
    }
    
    static func AddUser(id: String, otherStuff: String? = nil){
        guard let otherStuff = otherStuff else {
            UserManager.ref.child(id).setValue(["otherStuff": ""])
            return
        }
        
        UserManager.ref.child(id).setValue(["otherStuff": otherStuff])
        
    }
    
    static func GetUser(id: String, completionHandler: @escaping (_ user: User) -> ()) {
        
        let user = User(id: id)

        UserManager.ref.child(id).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary

            user.name = value?["name"] as? String
            //Get most recent ticket
            let tickets = value?["tickets"] as? NSDictionary
            var currentTicketID: String?
            
            for item in (tickets?.allKeys)! {
                if tickets?.value(forKey: item as! String) as! Bool == false {
                    currentTicketID = item as? String
                }
            }
            
            TicketManager.GetTicket(id: currentTicketID!) {
                ticket in
                
                user.ticket = ticket
                
                completionHandler(user)
            }
            
        }) {(error) in
            print(error.localizedDescription)}
        
    }
    
    static func CreateTicket(user: User, restaurant: String, completionHandler: @escaping (_ ticket: Ticket) -> ()) {
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
                ticket = Ticket()
            }
            
        }){(error) in
            print(error.localizedDescription)}

    }
    
    static func CompleteTicket(user: User, ticket: String) {
        UserManager.ref.child(String(user.ID)).child("tickets").child(String(ticket)).setValue(true)
    }
    
}
