//
//  PaymentViewController.swift
//  App_Prototype_Alpha_001
//
//  Created by Jon Calanio on 10/23/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

//Payment model here for now
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

class PaymentViewController: UIViewController {
    
    //Variables
    var currentPayment: Payment?
    var paymentList: [Payment]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "UnwindToPaymentsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentListSegue" {
            let paymentVC = segue.destination as! PaymentTableViewController
            
            
            paymentVC.paymentList = paymentList!
        }
        else if segue.identifier == "AddPaymentSegue" {
            
        }
    }
}
