//
//  MenuManager.swift
//  App_Prototype_Alpha_001
//
//  Created by russel w h on 10/7/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class MenuManager{
    static let ref = FIRDatabase.database().reference().child("Menus")
    
    
    
    
    static func GetMenu(id: String)-> Menu{
        
        let menu = Menu()
        
        ref.child(id).observeSingleEvent(of: .value, with:{(snapshot) in
            let value = snapshot.value as? NSDictionary
            menu.rest_id = id
            menu.title = value?["title"] as? String
            menu.cover_picture = value?["cover_picture"] as? String
            let menu_groups = value?["menu_groups"] as? NSDictionary
            var groups: [String] = []
            for group in (menu_groups?.allKeys)!{
                if ((menu_groups?.value(forKey: group as! String) as? String) == "true"){
                    groups.append(group as! String)
                }
            }
            menu.menu_groups = MenuGroupManager.GetMenuGroup(ids: groups)
            
            
            
        }){(error) in
            print(error.localizedDescription)
        }
        
        return menu
    }
    
}




