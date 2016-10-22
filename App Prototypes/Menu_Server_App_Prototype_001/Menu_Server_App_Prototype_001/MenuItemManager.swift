//
//  MenuItemManager.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Russel Hampton on 10/22/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class MenuItemManager{
    
    static let ref = FIRDatabase.database().reference().child("MenuItems")
    
    
    
    static func GetMenuItem(id: String, completionHandler: @escaping (_ item: MenuItem) -> ()) {
        let item = MenuItem()
        
        ref.child(id).observeSingleEvent(of: .value, with:{(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            item.title = value?["name"] as? String
            item.image = value?["image"] as? String
            item.desc = value?["desc"] as? String
            item.price = value?["price"] as? Double
        }){(error) in
            print(error.localizedDescription)
        }
        
        
        completionHandler(item)
        
    }
    static func GetMenuItem(ids: [String], completionHandler: @escaping (_ items: [MenuItem]) -> ()) {
        var items :[MenuItem] = []
        
        let sem1 = DispatchGroup.init()
        
        for id in ids{
            print("Initiating request for item id " + id)
            var newItem: MenuItem?
            
            sem1.enter()
            GetMenuItem(id: id) {
                item in
                
                print("Finished request for item id " + id)
                newItem = item
                items.append(newItem!)
                
                sem1.leave()
            }
            
        }
        
        sem1.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests for menu items")
            completionHandler(items) })
    }
}
