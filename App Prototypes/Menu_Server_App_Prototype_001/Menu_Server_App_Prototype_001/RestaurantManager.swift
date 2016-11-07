//
//  RestaurantManager.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/26/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class RestaurantManager {
    static let ref = FIRDatabase.database().reference().child("Menus")
    
    static func GetRestaurant(id: String, completionHandler: @escaping (_ restaurant: Restaurant) -> ()) {
        let restaurant = Restaurant()
        
        ref.child(id).observe(.value, with: {(FIRDataSnapshot) in
            let value = FIRDataSnapshot.value as? NSDictionary
            
            restaurant.restaurant_ID = id
            restaurant.title = value?["title"] as? String
            restaurant.location = value?["location"] as? String
            
            completionHandler(restaurant)
        }) {(error) in
            print(error.localizedDescription)}
    }
    
    static func GetRestaurant(ids: [String], completionHandler: @escaping (_ restaurants: [Restaurant]) -> ()) {
        var restaurants: [Restaurant] = []
        
        let semRest = DispatchGroup.init()
        
        for id in ids {
            var newRestaurant: Restaurant?
            
            semRest.enter()
            
            GetRestaurant(id: id) {
                restaurant in
                
                newRestaurant = restaurant
                
                restaurants.append(newRestaurant!)
                
                semRest.leave()
            }
        }
        
        semRest.notify(queue: DispatchQueue.main, execute: {
            completionHandler(restaurants) })
    }
}
