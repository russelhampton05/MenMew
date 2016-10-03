//
//  Models.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation


class User{
    
    var ID: String
    var otherInformation: String?
    
    init(id: String, otherInformation: String? = nil){
        self.ID = id
        self.otherInformation = otherInformation
        
    }
}
