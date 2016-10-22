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
    
    init() {
        
    }
    
    init(name: String, email: String, password: String, payment: [Payment]) {
        self.name = name
        self.email = email
        self.password = password
        self.payment = payment
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
    
    var ticket_ID: String?
    var tableNum: String?
    var desc: String?
    var users: [User]? = []
    var itemsOrdered: [MenuItem]?
    var currPrice: Double?
    
    init() {
        
    }
    
    init(ticket_ID: String, tableNum: String, desc: String, users: [User]?, itemsOrdered: [MenuItem]?) {
        self.ticket_ID = ticket_ID
        self.tableNum = tableNum
        self.desc = desc
        self.users = users
        self.itemsOrdered = itemsOrdered
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
