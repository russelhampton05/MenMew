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
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("MenuCell")) as UITableViewCell!
        
        cell?.textLabel!.text = categoryArray[(indexPath as NSIndexPath).row].name
        cell?.detailTextLabel!.text = categoryArray[(indexPath as NSIndexPath).row].desc
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = bgView
        cell?.textLabel?.highlightedTextColor = self.view.backgroundColor
        cell?.detailTextLabel?.highlightedTextColor = self.view.backgroundColor
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = (indexPath as NSIndexPath).row
        self.performSegue(withIdentifier: "CategoryDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func  numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetailSegue" {
            let menuVC = segue.destination as! MenuDetailsViewController
            
            menuVC.categoryTitle = categoryArray[segueIndex!].name
            menuVC.menuArray = menuArray[segueIndex!]
            menuVC.orderArray = orderArray
            menuVC.restaurantName = restaurant!
        }
        else if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! UITableViewController
        }
        
    }
    
    func reloadDetails(_ sourceArray: [(title: String, price: String)], sourceRestaurant: String){
        orderArray = sourceArray
        restaurant = sourceRestaurant
    }
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? MenuDetailsViewController {
            orderArray = sourceVC.orderArray!
        }
    }

}
