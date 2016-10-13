//
//  RestaurantViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/16/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

//might have to decide if this class is even actually worth keeping.
//The only reason it would be worth having still is if we wanted real time swapping of
//menus. That logic for deciding which menu would go here.

class RestaurantViewController: UIViewController {
    
    /*
    var restaurantTitle: String?
    var location: String?
    var tableNum: Int?
    var dataDictionary: [[String: Any]]?
    var categoryArray = [(name: String, desc: String)]()
    var menuGroup = [MenuItem]()
    var menuArray = [[MenuItem]]()
 
 
    var connectionURL: URL?
 
    */
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    
    var menu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        

        menu = MenuManager.GetMenu(id: "fac4b7243c8d47d69a309fb7471d21b9") //get this from QR eventually
        
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
        let mainMenuVC = segue.destination as! MainMenuViewController
        
        mainMenuVC.menu = self.menu
        
    }
}
    /*
    func parseJSONData() {
        
        URLSession.shared.dataTask(with: connectionURL!, completionHandler: {(data, response, error) in
            if error != nil {
                //Error
                print(error)
            } else {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    
                    if let categories = jsonData["category"] as? [[String: Any]] {
                        
                        if let restaurantName = jsonData["name"] as? String {
                            self.restaurantTitle = restaurantName
                        }
                        
                        if let restaurantLocation = jsonData["location"] as? String {
                            self.location = restaurantLocation
                        }
                        
                        if let restaurantTableNum = jsonData["table"] as? Int {
                            self.tableNum = restaurantTableNum
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.restaurantLabel.text = self.restaurantTitle!
                            self.tableLabel.text = "Table " + String(self.tableNum!)
                        })
                        
                        
                        for var category in categories {
                            
                            self.categoryArray.append((name: category["cat_name"] as! String, desc: category["cat_desc"] as! String))
                            
                            let items = category["item"] as! [[String: Any]]
                            
                            for item in items {
                                
                                let newMenuItem = MenuItem(title: item["name"] as! String, price: item["price"] as! Double, image: item["image"] as! String, desc: item["desc"] as! String)
                                
                                self.menuGroup.append(newMenuItem)
                            }
                            
                            self.menuArray.append(self.menuGroup)
                            self.menuGroup.removeAll()
                        }
                    }
                    
                    self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
                    
                } catch let error as NSError {
                    //Error
                    print(error)
                }
            }
        }).resume()
        */
   
