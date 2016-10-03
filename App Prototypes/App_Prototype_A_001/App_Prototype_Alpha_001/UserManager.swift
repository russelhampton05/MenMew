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
    static func AddUser(user: User){
        let ref = FIRDatabase.database().reference()
        guard let otherStuff = user.otherInformation else {
            ref.child("users").child(user.ID).setValue(["otherStuff": ""])
            return
        }
        ref.setValue("users")
        ref.child("users").child(user.ID).setValue(["otherStuff": user.otherInformation])
    }
    static func AddUser(id: String, otherStuff: String? = nil){
        let ref = FIRDatabase.database().reference()
        guard let otherStuff = otherStuff else {
            ref.child("users").child(id).setValue(["otherStuff": ""])
            return
        }
        ref.child("users").child(id).setValue(["otherStuff": otherStuff])
        
    }
}
