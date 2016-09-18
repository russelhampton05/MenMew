//
//  MainMenuViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/17/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

struct MenuItem {
    var title: String
    var price: String
    var image: String
    var desc: String
}


class MainMenuViewController: UITableViewController{
    var segueIndex: Int?
    var test: String = ""
    @IBOutlet var menuButton: UIBarButtonItem!

    var orderArray: [(title: String, price: String)] = []
    let transition = CircleTransition()
    var menuArray = [[MenuItem(title: "Omelette", price: "12.50", image: "b_01", desc: "Scrambled eggs with your choice of meats and vegetables."), MenuItem(title: "Eggs Benedict", price: "14.00", image: "b_02", desc: "Classic poached eggs over ham and bacon on French toast."), MenuItem(title: "Pancakes", price: "8.95", image: "b_03", desc: "Classic buttermilk pancakes.")],
                         [MenuItem(title: "Crawfish Bucket", price: "15.50", image: "l_01", desc: "Cajun-style crawfish cooked fresh."), MenuItem(title: "Pork Chop", price: "13.25", image: "l_02", desc: "Grilled pork sirloin."), MenuItem(title: "Roast Chicken", price: "16.65", image: "l_03", desc: "Oven roasted and seasoned with our spices.")],
                         [MenuItem(title: "New York Strip", price: "21.95", image: "s_01", desc: "Classic strip steak served with reduction sauce."), MenuItem(title: "Meatloaf", price: "18.50", image: "s_02", desc: "Homemade goodness, elevated."), MenuItem(title: "Salmon Steak", price: "8.95", image: "s_03", desc: "Fresh Alaskan catch.")],
                        [MenuItem(title: "Margarita", price: "6.65", image: "d_01", desc: "Classic Mexican beverage."), MenuItem(title: "Bloody Mary", price: "9.00", image: "d_02", desc: "Sumptuous vodka cocktail."), MenuItem(title: "Orange Juice", price: "3.95", image: "d_03", desc: "Pure squeezed oranges for maximum taste.")]]
    
    var categoryArray: [(name: String, desc: String)] = [(name: "Breakfast", desc: "The best way to start your day."), (name: "Lunch", desc: "Dine in with our delectable entrees."), (name: "Specials", desc: "Our signature dishes."), (name: "Drinks", desc: "The best refreshments.")]
    var restaurant: String?
    @IBOutlet weak var restaurantLabel: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantLabel.title = restaurant
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.sectionHeaderHeight = 70
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(("MenuCell")) as UITableViewCell!
        
        cell.textLabel!.text = categoryArray[indexPath.row].name
        cell.detailTextLabel!.text = categoryArray[indexPath.row].desc
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        segueIndex = indexPath.row
        self.performSegueWithIdentifier("CategoryDetailSegue", sender: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func  numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CategoryDetailSegue" {
            let menuVC = segue.destinationViewController as! MenuDetailsViewController
            
            menuVC.categoryTitle = categoryArray[segueIndex!].name
            menuVC.menuArray = menuArray[segueIndex!]
            menuVC.orderArray = orderArray
            menuVC.restaurantName = restaurant!
        }
        else if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destinationViewController as! UITableViewController
        }
        
    }
    
    func reloadDetails(sourceArray: [(title: String, price: String)], sourceRestaurant: String){
        orderArray = sourceArray
        restaurant = sourceRestaurant
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? MenuDetailsViewController {
            orderArray = sourceVC.orderArray!
        }
    }

}
