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
        
        var menu = Menu()
        
        do{
          
            
            ref.child(id).observeSingleEvent(of: .value, with:{(snapshot) in
                let value = snapshot.value as? NSDictionary
                menu.rest_id = id
                menu.title = value?["title"] as! String
                menu.cover_picture = value?["cover_picture"] as! String
                var menu_groups = value?["items"] as? NSDictionary
                
                
                
            }){(error) in
                print(error.localizedDescription)
            }
            
        }catch{
            //not sure
        }
        return menu
    }
    
    
}

