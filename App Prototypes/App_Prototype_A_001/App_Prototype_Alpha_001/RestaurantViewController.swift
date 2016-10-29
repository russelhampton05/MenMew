//
//  RestaurantViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/16/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase


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
    


    //IBOutlets

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    
    var menu: Menu?
    var counter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //Check for user and restaurant IDs to load tickets
        loadRestaurantInformation()
        
        //get this from QR eventually
        
        
        //Call on JSON Parsing
      //  parseJSONData()

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
        if segue.identifier == "MainMenuSegue" {
            let mainMenuVC = segue.destination as! MainMenuViewController
        
            mainMenuVC.menu = self.menu
            mainMenuVC.ticket = currentUser!.ticket
        }
        else if segue.identifier == "QRReturnSegue" {
            let qrVC = segue.destination as! QRViewController
        }
    }
    
    func printError() {
        let errorPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        self.addChildViewController(errorPopup)
        self.view.addSubview(errorPopup.view)
        errorPopup.didMove(toParentViewController: self)
        errorPopup.addMessage(context: "QRError")
    }
    
    func loadUserInformation() {
        //Check Firebase for user
        
        //This needs love! Check to see if logged in user exists, if he doesn't MAKE a new user in our
        //FB for him.
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                UserManager.GetUser(id: (FIRAuth.auth()?.currentUser?.uid)!) {
                    user in
                    
                    currentUser = user
                    
                    self.loadRestaurantInformation()
                }
                
            } else {
                // No user is signed in.
            }
        }
    }
    
    func loadTicketInformation(completionHandler: @escaping (_ ticket: Ticket) -> ()) {
        let ref = FIRDatabase.database().reference().child("Tickets")
        
        ref.observe(.value, with: {(FIRDataSnapshot) in
            
            for item in FIRDataSnapshot.children {
                
                let ticket = Ticket(snapshot: item as! FIRDataSnapshot)
                
                if !(ticket.paid!) && ticket.restaurant_ID! == self.menu?.rest_id! {
                    currentUser!.ticket = ticket
                    
                    completionHandler(ticket)
                    
                    break
                }
                
            }
            
        }){(error) in
            print(error.localizedDescription)}
        
        
    }
    
    func loadRestaurantInformation() {
        MenuManager.GetMenu(id: "fac4b7243c8d47d69a309fb7471d21b9") {
            menu in
            
            self.menu = menu
            
            if menu.menu_groups == nil {
                self.printError()
            }
            else {
                currentRestaurant = "fac4b7243c8d47d69a309fb7471d21b9"
                self.loadTicketInformation() {
                    ticket in
                    
                    self.counter += 1
                    
                    if self.counter == 1 {
                        self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
                    }
                }
            }
        }
    }
}
    /*
=======
    
    //JSON parsing method, may be changed/replaced
>>>>>>> master
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
 
 
 //Get most recent ticket
 var tickets = value?["tickets"] as? NSDictionary
 var currentTicketID: String?
 
 if tickets != nil {
 
 for item in (tickets?.allKeys)! {
 if tickets?.value(forKey: item as! String) as! Bool == false {
 currentTicketID = item as? String
 }
 }
 
 
 TicketManager.GetTicket(id: currentTicketID!)	{
 ticket in
 
 currentTicket = ticket
 
 completionHandler(currentTicket)
 }
 }
 else {
 tickets = nil
 completionHandler(currentTicket)
 }

 
 ref.child(user.ID).child("tickets").observe(.value, with: {(FIRDataSnapshot) in
 if FIRDataSnapshot.value as! Bool == false {
 FIRDatabase.database().reference().child("tickets").child(FIRDataSnapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
 let value = snapshot.value as? NSDictionary
 if value?["restaurant"] as! String == restaurant {
 TicketManager.GetTicket(id: FIRDataSnapshot.key, restaurant: restaurant) {
 retrievedTicket in
 ticket = retrievedTicket
 
 completionHandler(ticket)
 }
 }
 }) { (error) in
 print(error.localizedDescription)
 }
 } else {
 ticket = Ticket()
 }
 
 }){(error) in
 print(error.localizedDescription)}
 
 
 UserManager.GetTicket(user: currentUser!, restaurant: "fac4b7243c8d47d69a309fb7471d21b9") {
 ticket in
 
 if ticket != nil {
 currentUser!.ticket = ticket
 
 self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
 }
 }
        */



