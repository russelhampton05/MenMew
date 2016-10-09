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
    static let menuRef = FIRDatabase.database().reference().child("Menus")
    static let menuItemRef = FIRDatabase.database().reference().child("MenuItems")
    static let menuGroupRef = FIRDatabase.database().reference().child("MenuGroups")
    static func GetMenu(id: String)-> Menu{
        
        var menu = Menu()
        
        do{
            
            menuRef.child(id).observeSingleEvent(of: .value, with:{(snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                
            }){(error) in
                print(error.localizedDescription)
            }
            
        }catch{
            //not sure
        }
        return menu
    }
}

