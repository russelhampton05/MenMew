//
//  OrderConfirmationViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 9/20/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    var orderArray: [(title: String, price: String)]?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToDetailSegue", sender: self)
    }
    
}
