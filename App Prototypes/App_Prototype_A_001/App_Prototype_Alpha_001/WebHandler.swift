//
//  WebHandler.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/22/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import Foundation

class WebHandler{
    let urlBase: String
    init()
    {
        //One class to build the request and params
        //one class to take that request and make a NSURLsession and get a response
        //  this class will return json
        //class that made the request does something with this json
        //EXAMPLE:
        //class UserGetter{
        // hasA webHandler
        // func BuildRequest()
        // webHandler.MakeRequest(request)
        // functions for returning, updating, editing, deleting go in here
        // ??? FUCK
        
        urlBase = "some value"
        let url = URL(fileURLWithPath: urlBase)
        //Need to have a dictionary of end points / params
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "GET" //need a list of these guys too
        
        //let task = NSURLSession.shared().dataTaskWithRequest(request)
        //{
            
            
        //}
        //is the task keep alive? cookies?
        

        
        
    }
    
}
