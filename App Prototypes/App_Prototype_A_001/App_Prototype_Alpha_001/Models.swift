//
//  Models.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
import Firebase

class User{
    
    var ID: String
    var name: String?
    var email: String?
    var ticket: Ticket?
    var image: String?
    var theme: String?
    var touchEnabled = false
    init(id: String, email: String?, name: String?, ticket: Ticket?, image: String?, theme: String?){
        self.ID = id
        self.email = email
        self.name = name
        self.ticket = ticket
        self.image = image
        self.theme = theme
    }
    convenience init(id: String, email: String?, name: String?, ticket: Ticket?, image: String?, theme: String?, touchEnabled: Bool){
        self.init( id: id, email: email, name: name, ticket: ticket, image: image, theme: theme)
        self.touchEnabled = touchEnabled
        
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

//Ticket Class
class Ticket {
    
    var ticket_ID: String?
    var user_ID: String?
    var restaurant_ID: String?
    var tableNum: String?
    var timestamp: String?
    var paid: Bool?
    var itemsOrdered: [MenuItem]?
    
    var desc: String?
    var confirmed: Bool?
    var status: String?
    var total: Double?
    var tip: Double?
    var message_ID: String?
    
    
    init() {
        self.message_ID = ""
        self.ticket_ID = ""
        self.user_ID = ""
        self.restaurant_ID = ""
        self.tableNum = ""
        self.paid = false
        self.itemsOrdered = []
        self.desc = ""
        self.confirmed = false
        self.status = "Ordering"
        self.total = 0.0
        self.tip = 0.0
    }
    
    init(ticket_ID: String, user_ID: String, restaurant_ID: String, tableNum: String, timestamp: String, paid: Bool, itemsOrdered:[MenuItem]?, desc: String?, confirmed: Bool?, status: String?, total: Double?, tip: Double?, message_ID: String?) {
        self.ticket_ID = ticket_ID
        self.user_ID = user_ID
        self.restaurant_ID = restaurant_ID
        self.tableNum = tableNum
        self.timestamp = timestamp
        self.paid = paid
        self.itemsOrdered = itemsOrdered
        self.desc = desc
        self.confirmed = confirmed
        self.status = status
        self.total = total
        self.tip = tip
        self.message_ID = message_ID
        if self.message_ID == nil{
            self.message_ID = ""
        }
    }
    
    func generateMessageGUID(){
        let id = UUID().uuidString.lowercased()
        self.message_ID = id.replacingOccurrences(of: "-", with: "")
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.ticket_ID = snapshot.key
        self.user_ID = snapshotValue["user"] as? String
        self.restaurant_ID = snapshotValue["restaurant"] as? String
        
        self.tableNum =  snapshotValue["table"] as? String
        self.timestamp = snapshotValue["timestamp"] as? String
        
        self.paid = snapshotValue["paid"] as? Bool
        
        self.desc = snapshotValue["desc"] as? String
        self.confirmed = snapshotValue["confirmed"] as? Bool
        self.status = snapshotValue["status"] as? String
        self.total = snapshotValue["total"] as? Double
        self.tip = snapshotValue["tip"] as? Double
        
        if snapshotValue["message"] != nil{
            self.message_ID = snapshotValue["message"] as? String
        }
        else{
            self.message_ID = ""
        }
//        MenuItemManager.GetMenuItem(ids: snapshotValue["itemsOrdered"]?.allKeys as! [String]) {
//            items in
//            self.itemsOrdered = items;
//        }
        
        
        //ItemsOrdered is the array of items ordered for the table
        //  let menuItems = snapshotValue["itemsOrdered"] as? NSDictionary
    }
}

//Message Class
class Message {
    var message_ID: String?
    var serverMessage: String?
    var userMessage: String?
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.message_ID = snapshot.key
        self.serverMessage = snapshotValue["server"] as? String
        self.userMessage = snapshotValue["user"] as? String
    }
}

//Theme Class
class Theme {
    var name: String?
    var primary: UIColor?
    var secondary: UIColor?
    var highlight: UIColor?
    var invert: UIColor?
    
    init(type: String) {
        if type == "Salmon" {
            name = "Salmon"
            primary = UIColor(red: 255, green: 106, blue: 92)
            secondary = UIColor(red: 255, green: 255, blue: 255)
            highlight = UIColor(red: 255, green: 255, blue: 255)
            invert = UIColor(red: 255, green: 106, blue: 92)
        }
        else if type == "Light" {
            name = "Light"
            primary = UIColor(red: 255, green: 255, blue: 255)
            secondary = UIColor(red: 255, green: 255, blue: 255)
            highlight = UIColor(red: 255, green: 141, blue: 43)
            invert = UIColor(red: 255, green: 141, blue: 43)
        }
        else if type == "Midnight" {
            name = "Midnight"
            primary = UIColor(red: 55, green: 30, blue: 96)
            secondary = UIColor(red: 18, green: 3, blue: 42)
            highlight = UIColor(red: 255, green: 255, blue: 255)
            invert = UIColor(red: 255, green: 255, blue: 255)
        }
        else if type == "Slate" {
            name = "Slate"
            primary = UIColor(red: 27, green: 27, blue: 27)
            secondary = UIColor(red: 20, green: 20, blue: 20)
            highlight = UIColor(red: 255, green: 255, blue: 255)
            invert = UIColor(red: 255, green: 255, blue: 255)
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
