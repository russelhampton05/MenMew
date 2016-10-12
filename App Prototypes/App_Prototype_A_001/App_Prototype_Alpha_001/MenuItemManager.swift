//
//  MenuItemManager.swift
//  App_Prototype_Alpha_001
//
//  Created by Guest User on 10/10/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class MenuItemManager{
    
    static let ref = FIRDatabase.database().reference().child("MenuItems")
    
    
    
    static func GetMenuItem(id: String)->MenuItem{
        let item = MenuItem()
        
        ref.child(id).observeSingleEvent(of: .value, with:{(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            item.desc = value?["desc"] as? String
            item.image = value?["image"] as? String
            item.title = value?["title"] as? String
            item.price = Double(value?["price"] as! String)
        }){(error) in
            print(error.localizedDescription)
        }
        
        
        return item
        
    }
    static func GetMenuItem(ids: [String]) -> [MenuItem]{
        var items :[MenuItem] = []
        for id in ids{
            items.append(GetMenuItem(id: id))
        }
        return items
    }
}
