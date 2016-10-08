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
    var rest_id : String
    var title : String
    var cover_picture : String?
    var menu_groups : [MenuItem] = []
    init(id:String, title:String, cover_picture:String?, groups: [MenuItem]){
        self.rest_id = id
        self.title = title
    
        self.cover_picture = cover_picture
        self.menu_groups = groups
    }
    convenience init(id:String, title:String, groups: [MenuItem] ) {
        self.init(id:id, title:title, cover_picture:nil, groups:groups)
    }
}


class MenuItem {
    //will eventually point to an actual item (if we care to implement that, possibly not)
    //for now just UI facing fields and those needed for ordering/pricing
    enum CookType{
        case rare
        case medium
        case well_done
    }
    var cook_type: [CookType]?
    var title: String
    var price: Double
    var sides: [String]?
    var image: String
    var desc: String
    convenience init(title:String, price:Double, image: String, desc: String, sides:[String]?){
        self.init(title : title, price : price, image : image, desc: desc, sides:sides, cook_type: nil)
    }
     init(title:String, price:Double, image: String, desc: String, sides:[String]?,cook_type:[CookType]?) {
        self.cook_type = cook_type
        self.title = title
        self.image = image
        self.price = price
        self.sides = sides
        self.desc = desc
    }
    convenience init(title:String, price:Double, image: String, desc: String, cook_type: [CookType]?){
        self.init(title : title, price : price, image : image, desc: desc, sides:nil, cook_type: cook_type)
    }

}



