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

class UserManager{
    
    static let ref = FIRDatabase.database().reference().child("users")
    
    static func AddUser(user: User){
        
        guard let otherStuff = user.otherInformation else {
            UserManager.ref.child(user.ID).setValue(["otherStuff": ""])
            return
        }
        
        
        UserManager.ref.child("123").setValue(["otherStuff": user.otherInformation])
    }
    static func AddUser(id: String, otherStuff: String? = nil){
        guard let otherStuff = otherStuff else {
            UserManager.ref.child(id).setValue(["otherStuff": ""])
            return
        }
        UserManager.ref.child(id).setValue(["otherStuff": otherStuff])
        
    }
    static func GetUser(id: String){
        var test: String?
        UserManager.ref.child("123").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let otherstuff = value?["otherStuff"] as! String
            test = otherstuff
        }) {(error) in
            print(error.localizedDescription)
            test = error.localizedDescription}
        
    }
    
}
