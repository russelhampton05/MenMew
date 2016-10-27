//
//  Models.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase
func testFunc(){
    
}

class User{
    
    var ID: String
    var name: String?
    var email: String?
    var ticket: Ticket?
    init(id: String, email: String?, name: String?, ticket:Ticket?){
        self.ID = id
        self.email = email
        self.name = name
        self.ticket = ticket
    }
}
//need to look at maybe changing this
struct Details {
    var sides: [String]
    var cookType: [String]
}
class Menu{
    var rest_id : String?
    var title : String?
    var cover_picture : String?
    var menu_groups : [MenuGroup]? = []
    init(id:String, title:String, cover_picture:String?, groups: [MenuGroup]){
        self.rest_id = id
        self.title = title
        
        self.cover_picture = cover_picture
        self.menu_groups = groups
    }
    init(){
        
    }
    convenience init(id:String, title:String, groups: [MenuGroup] ) {
        self.init(id:id, title:title, cover_picture:nil, groups:groups)
    }
}

class MenuGroup{
    var cover_picture: String?
    var desc: String?
    var title: String?
    var items: [MenuItem]?
    init(){
        
    }
    init(desc: String,items: [MenuItem], title: String?, cover_picture:String?){
        self.cover_picture = cover_picture
        self.desc = desc
        self.title = title
        self.items = items
    }
    convenience init(desc: String,items: [MenuItem], title: String?){
        self.init(desc:desc,items:items, title:title, cover_picture:nil)
    }
    convenience init(desc: String,items: [MenuItem], cover_picture:String?) {
        self.init(desc:desc,items:items, title:nil, cover_picture:cover_picture)
    }
    convenience init(desc: String,items: [MenuItem]) {
        self.init(desc:desc, items:items, title:nil, cover_picture:nil)
    }
}
//menu item objects and menus are for UI purposes only.
//Menu item will have a member called "item", which will tie it in to the actaul
//details necessary for order tracking.

class MenuItem {
    //will eventually point to an actual item (if we care to implement that, possibly not)
    //for now just UI facing fields and those needed for ordering/pricing
    
    var item_ID: String?
    var title: String?
    var price: Double?
    //var sides: [String]?
    var image: String?
    var desc: String?
    
    init(){
        
    }
    init(item_ID: String?, title:String, price:Double, image: String, desc: String) {
        
        self.item_ID = item_ID
        self.title = title
        self.image = image
        self.price = price
        //  self.sides = sides
        self.desc = desc
    }
    //convenience init(title:String, price:Double, image: String, desc: String){
    // self.init(title : title, price : price, image : image, desc: desc, sides:nil)
    //}
    
}

class Restaurant {
    var restaurant_ID: String?
    var title: String?
    var location: String?
    
    //We can also reference tables and servers here
    
    init() {
        self.restaurant_ID = ""
        self.title = ""
        self.location = ""
    }
    
    init(restaurant_ID: String, title: String, location: String?) {
        self.restaurant_ID = restaurant_ID
        self.title = title
        self.location = location
    }
}

    
class Ticket {
    
    var ticket_ID: String?
    var user_ID: String?
    var restaurant_ID: String?
    var tableNum: String?
    var timestamp: String?
    var paid: Bool?
    var itemsOrdered: [MenuItem]?
    var desc: String?
    
    init() {
        
        self.ticket_ID = ""
        self.user_ID = ""
        self.restaurant_ID = ""
        self.tableNum = ""
        self.paid = false
        self.itemsOrdered = []
        self.desc = ""
    }
    
    init(ticket_ID: String, user_ID: String, restaurant_ID: String, tableNum: String, timestamp: String, paid: Bool, itemsOrdered:[MenuItem]?, desc: String?) {
        self.ticket_ID = ticket_ID
        self.user_ID = user_ID
        self.restaurant_ID = restaurant_ID
        self.tableNum = tableNum
        self.timestamp = timestamp
        self.paid = paid
        self.itemsOrdered = itemsOrdered
        self.desc = desc
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.ticket_ID = snapshot.key
        self.user_ID = snapshotValue["user"] as? String
        self.restaurant_ID = snapshotValue["restaurant"] as? String

        self.tableNum = String(describing: snapshotValue["table"] as! Int)
        self.timestamp = snapshotValue["timestamp"] as? String
        
        self.paid = false

        self.desc = snapshotValue["desc"] as? String
        
        
        //let menuItems = value?["itemsOrdered"] as? NSDictionary
        
        
        MenuItemManager.GetMenuItem(ids: snapshotValue["itemsOrdered"]?.allKeys as! [String]) {
            items in
            
            self.itemsOrdered = items;
        }

        
        //ItemsOrdered is the array of items ordered for the table
      //  let menuItems = snapshotValue["itemsOrdered"] as? NSDictionary
    }
}


