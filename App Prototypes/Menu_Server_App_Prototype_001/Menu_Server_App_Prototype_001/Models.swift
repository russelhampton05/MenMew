//
//  Models.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/22/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var email: String?
    var password: String?
    var payment: [Payment]?
    var ticket: Ticket?
    
    init() {
        
    }
    
    init(name: String, email: String, password: String, payment: [Payment], ticket: Ticket?) {
        self.name = name
        self.email = email
        self.password = password
        self.payment = payment
        self.ticket = ticket
    }
}

class Payment {
    
    var name: String?
    var type: String?
    
    //Unsure if actual CC information is needed
    
    init () {
    }
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

class Ticket {
    
    var user_ID: String?
    var restaurant_ID: String?
    var tableNum: String?
    var timestamp: NSDate?
    var paid: Bool?
    var itemsOrdered: [(item: MenuItem, quantity: Int)]?
    var desc: String?
    
    init() {
    }
    
    init(user_ID: String, restaurant_ID: String, tableNum: String, timestamp: NSDate, paid: Bool, itemsOrdered: [(item: MenuItem, quantity: Int)]?, desc: String?) {
        self.user_ID = user_ID
        self.restaurant_ID = restaurant_ID
        self.tableNum = tableNum
        self.timestamp = timestamp
        self.paid = paid
        self.itemsOrdered = itemsOrdered
        self.desc = desc
    }
}


class MenuItem {
    
    var title: String?
    var price: Double?
    //var sides: [String]?
    var image: String?
    var desc: String?
    
    init(){
        
    }
    init(title:String, price:Double, image: String, desc: String) {
        
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
