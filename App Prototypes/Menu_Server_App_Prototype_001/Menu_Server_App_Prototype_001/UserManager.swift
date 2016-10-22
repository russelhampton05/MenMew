//
//  UserManager.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/22/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class UserManager {
    //This class handles user information, which also adopts the current ticket
    //in use when logged into the restaurants.
    
    static let ref = FIRDatabase.database().reference().child("Users")
    
    static func GetUser(id: String, completionHandler: @escaping (_ user: User) -> ()) {
        
        let user = User()
        
        ref.child(id).observe(.value, with: {(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            
            user.name = value?["name"] as? String
            user.email = value?["email"] as? String
            user.password = value?["password"] as? String
            //No idea how the payment is structured yet so no data assignment for now
            
            //Get the ticket associated with the user
            let ticketID = value?["ticket"] as? String
            TicketManager.GetTicket(id: ticketID!) {
                ticket in
                
                user.ticket = ticket
                
                completionHandler(user)
            }
            
            
        }){(error) in
            print(error.localizedDescription)}
    }
    
}
