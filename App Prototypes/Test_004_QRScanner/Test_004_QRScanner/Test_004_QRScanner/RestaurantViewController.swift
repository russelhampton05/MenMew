//
//  RestaurantViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/16/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    var restaurant: String?
    var tableNum: String?

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        restaurantLabel.text = restaurant!
        tableLabel.text = tableNum!
        
        delay(5.0) {
            //Segue
            self.performSegueWithIdentifier("MainMenuSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func delay(time: Double, closure: () -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mainMenu = segue.destinationViewController as! MainMenuViewController
        
        mainMenu.restaurant = restaurant
        
    }
}
