//
//  Models.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation
func testFunc(){
    
}

class User{
    
    var ID: String
    var otherInformation: String?
    
    init(id: String, otherInformation: String? = nil){
        self.ID = id
        self.otherInformation = otherInformation
        
    }
    
    
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



