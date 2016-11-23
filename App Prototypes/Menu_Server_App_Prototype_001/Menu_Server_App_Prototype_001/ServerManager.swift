//
//  ServerManager.swift
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
//should only grab ticket ids that show up with value FALSE (unpaid) under servers->serverid->tickets->ticketid: FALSE. Shouldn't be more than one by design (one per rest id)
//Ticket population can't happen until rest id is found!

class ServerManager {
    
    static let ref = FIRDatabase.database().reference().child("Servers")
    
    static func AddServer(server: Server){
        
        //Create new server entry on database
        ServerManager.ref.child(server.ID).child("name").setValue(server.name)
        ServerManager.ref.child(server.ID).child("email").setValue(server.email)
        
        return
    }
    
    static func GetServer(id: String, completionHandler: @escaping (_ server: Server) -> ()) {
        
        let server = Server(id: id, name: nil, email: nil, restaurants: nil, tables: nil, theme: nil, image: nil, notifications: true)
        
        ServerManager.ref.child(id).observe(.value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            server.name = value?["name"] as? String
            server.email = value?["email"] as? String
            server.theme = value?["theme"] as? String
            server.image = value?["image"] as? String
            server.notifications = value?["notifications"] as! Bool
            
            let tickets = value?["tickets"] as? NSDictionary
            let restaurants = value?["restaurants"] as? NSDictionary
            let tables = value?["tables"] as? NSDictionary

            if(server.theme == nil || (server.theme?.characters.count)! < 1)
            {
                server.theme = "Salmon"
            }
            //Get list of restaurants
            var restList: [String] = []
            if restaurants != nil {
                for item in (restaurants?.allKeys)! {
                    if restaurants?.value(forKey: item as! String) as! Bool == true {
                        restList.append((item as? String)!)
                    }
                }
                
                server.restaurants = restList
            }
            
            //Get list of tables
            var tableList: [String] = []
            if tables != nil {
                for item in (tables?.allKeys)! {
                    if tables?.value(forKey: item as! String) as! Bool == true {
                        tableList.append((item as? String)!)
                    }
                }
                
                server.tables = tableList
            }
            
            completionHandler(server)
            
        }) {(error) in
            print(error.localizedDescription)}
        
    }
    
    static func uploadImage(server: Server, image: UIImage, completionHandler: @escaping (_ done: Bool) -> ()) {
        
        //Initialize storage reference
        let data = UIImagePNGRepresentation(image)
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        let userPhotosRef = storageRef.child("UserPhotos")
        let userRef = userPhotosRef.child(server.ID)
        let imageRef = userRef.child("profile.jpg")
        
        let uploadTask = imageRef.put(data!, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            else {
                //Replace previous image reference
                let newImageURL: String = metadata!.downloadURL()!.absoluteString
                ref.child(server.ID).child("image").setValue(newImageURL)
                
                completionHandler(true)
            }
        }
        
    }
    
    static func getImageURL(server: Server, completionHandler: @escaping (_ url: String) -> ()) {
        
        UserManager.ref.child(server.ID).observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            
            let imgURL = value?["image"] as? String
            
            completionHandler(imgURL!)
        })
    }
    
    //Update theme
    static func setTheme(server: Server, theme: String) {
        ref.child(server.ID).child("theme").setValue(theme)
    }
    
    //Update name
    static func UpdateUserName(server: Server, name: String) {
        ref.child(server.ID).child("name").setValue(name)
    }
}
