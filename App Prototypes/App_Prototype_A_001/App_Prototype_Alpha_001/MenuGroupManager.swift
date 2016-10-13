//
//  MenuGroupManager.swift
//  App_Prototype_Alpha_001
//
//  Created by Guest User on 10/10/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase


class MenuGroupManager{
    //i'm not sure if making this static is really the best option or if we should just make a ref
    //inside the function. From the documentation it doesn't change much behind the scenes.
    
    static let ref = FIRDatabase.database().reference().child("MenuGroups")
    
    
    
    static func GetMenuGroup(id: String)->MenuGroup{
        let group = MenuGroup()
        
        
        ref.child(id).observeSingleEvent(of: .value, with:{(snapshot) in
            let value = snapshot.value as? NSDictionary
            group.cover_picture = value?["cover_picture"] as? String
            group.desc = value?["desc"] as? String
            group.title = value?["title"] as? String
            let group_items = value?["items"] as? NSDictionary
            var items: [String] = []
            for item in (group_items?.allKeys)!{
                if ((group_items?.value(forKey: item as! String) as? String) == "true"){
                    items.append(item as! String)
                }
            }
            group.items = MenuItemManager.GetMenuItem(ids:items)
            
        }){(error) in
            print(error.localizedDescription)
        }
        
        
        return group
        
    }
    static func GetMenuGroup(ids: [String]) -> [MenuGroup]{
        var groups :[MenuGroup] = []
        for id in ids{
            groups.append(GetMenuGroup(id: id))
        }
        return groups
    }
    
}
