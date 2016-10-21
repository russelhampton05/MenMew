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
    
    
    static func GetMenu(id: String, completionHandler: @escaping (_ menu: Menu) -> ()) {
        let menu = Menu()
        
        print("Main menu ref: ")
        print(ref)
        
        ref.child(id).observeSingleEvent(of: .value, with: {(FIRDataSnapshot) in
            
            let value = FIRDataSnapshot.value as? NSDictionary
            menu.rest_id = id
            menu.title = value?["title"] as? String
            menu.cover_picture = value?["cover_picture"] as? String
            let menu_groups = value?["menu_groups"] as? NSDictionary
            var groups: [String] = []
            for group in (menu_groups?.allKeys)! {
                
                if ((menu_groups?.value(forKey: group as! String) as! Bool) == true) {
                    groups.append(group as! String)
                }
            }
            
            MenuGroupManager.GetMenuGroup(ids: groups) {
                groups in
                
                menu.menu_groups = groups
                
                print("Finished building menu")
                completionHandler(menu)
            }
            
            
            
            }, withCancel: {(Error) in
                    print(Error.localizedDescription)
                })
        
    }

}




		
