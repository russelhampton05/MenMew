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
        self.navigationController?.isNavigationBarHidden = true
        
        restaurantLabel.text = restaurant!
        tableLabel.text = tableNum!
        
        delay(2.0) {
            //Segue
            self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func delay(_ time: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainMenu = segue.destination as! MainMenuViewController
        
        mainMenu.restaurant = restaurant
        
    }
}
