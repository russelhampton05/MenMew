    //
//  MenuDetailsViewController.swift
//  Test_003_TableViews
//
//  Created by Jon Calanio on 9/11/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

    var imageCache = NSMutableDictionary()

class MenuDetailsViewController: UITableViewController {
    
    var menu: Menu?
    //var orderArray: [(title: String, price: Double)]?
    var selectedIndexPath : IndexPath?
    var ordered: Bool = false
    var ticket : Ticket?
    var menu_group:MenuGroup?
    var categoryArray = [(name: String, desc: String)]()
    var categoryTitle: String?
    var restaurantName: String?
    //var currentTable: String?
    var curentCell: MenuCell?
    var indexPaths : Array<IndexPath> = []
    
    
    //IBOutlets
    @IBOutlet var categoryLabel: UINavigationItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var categoryTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UIFont(name: "HelveticaNeue", size: 12) {
           UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
           // ticket = Ticket() //incase shit blows up
        }	

        categoryLabel.title = menu_group!.title
        
        if  ticket == nil {
            doneButton.isEnabled = false
        }
        else if ticket?.itemsOrdered != nil {
            if (ticket?.itemsOrdered?.count)! > 0 && ordered == false {
                doneButton.isEnabled = true
            }
        }
        else {
            doneButton.isEnabled = false
        }
        
        initializeGestureRecognizers()
        loadTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.showTotal()
        }
    }
    
    func initializeGestureRecognizers() {
        categoryTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuTapped(gesture:)))
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.addGestureRecognizer(categoryTapGestureRecognizer)
    }
    
    func menuTapped(gesture: UITapGestureRecognizer) {
        showTotal()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return only one section (1 copy of table)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Populate table with cells and their data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MenuCell
        
        cell.foodTitle.text = menu_group?.items![(indexPath as NSIndexPath).row].title
        cell.foodPrice.text = (NSString(format: "$%.2f", (menu_group?.items![(indexPath as NSIndexPath).row].price!)!) as String)
        cell.foodDesc.text = menu_group?.items![(indexPath as NSIndexPath).row].desc

        cell.foodImage.getImage(urlString: (menu_group?.items![(indexPath as NSIndexPath).row].image)!, circle: false)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menu_group?.items!.count)!
    }

    //Check for selected items in the table via index paths
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let previousIndexPath = selectedIndexPath
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        
        else {
            selectedIndexPath = indexPath
        }
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //Enable the cell to observe frame change
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MenuCell).watchFrameChanges()
        curentCell = cell as? MenuCell
    }
    
    //Disable the cell to observe frame change
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MenuCell).ignoreFrameChanges()
    }
    
    //Return the cell's height based on the selected index
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return MenuCell.expandedHeight
        }
        else {
            return MenuCell.normalHeight
        }
    }
    
    func closeCell() {
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = nil
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
        
        selectedIndexPath = previousIndexPath
    }
    
    //Display the popup menu choices modal
    @IBAction func addMenuItem(_ sender: AnyObject) {
        
        //Real condition will be checking if the menu item allows for extra menu choices
        if menu_group?.title == "Memes" {
            let detailPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuPopup") as! MenuDetailPopupViewController
            
            //Here, in production the choices will be loaded from Firebase
            
            let tempSides = ["Rice Pilaf", "Corn on a Cob", "Coleslaw", "Hash browns"]
            let tempCookStyles = ["Rare", "Medium Rare", "Medium Well", "Well Done"]
            //i never deleted a "Details" So I'm not sure what's going on here. Or maybe I did? Who knows.
            let tempDetails = Details(sides: tempSides, cookType: tempCookStyles)
            
            
            detailPopup.menuItem = menu_group?.items![(selectedIndexPath! as NSIndexPath).row].title
            detailPopup.showMenuDetails(details: tempDetails)
            self.addChildViewController(detailPopup)
            detailPopup.view.frame = self.view.frame
            detailPopup.view.frame.origin.y = tableView.contentOffset.y
            self.view.addSubview(detailPopup.view)
            detailPopup.didMove(toParentViewController: self)
            
            tableView.isScrollEnabled = false

        }
        else {
            addOrder(self)
        }
    }
    
    
    //Display the popup confirmation modal
    @IBAction func addOrder(_ sender: AnyObject) {
        
        if ticket == nil {
            UserManager.CreateTicket(user: currentUser!, ticket: nil, restaurant: menu!.rest_id!) {
                ticket in
                
                UserManager.UpdateTicketTable(user: currentUser!, ticket: ticket.ticket_ID!, table: currentTable!)
                
                currentUser!.ticket = ticket
                self.ticket = ticket
            }
        }
        
        if doneButton.isEnabled == false {
            doneButton.isEnabled = true
        }
        
        let confirmPopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Popup") as! PopupViewController
        
        addToOrder(item: (menu_group?.items![(selectedIndexPath! as NSIndexPath).row])!)
        
        confirmPopup.menuItem = menu_group?.items![(selectedIndexPath! as NSIndexPath).row].title
        self.addChildViewController(confirmPopup)
        confirmPopup.view.frame = self.view.frame
        confirmPopup.view.frame.origin.y = tableView.contentOffset.y
        self.view.addSubview(confirmPopup.view)
        confirmPopup.didMove(toParentViewController: self)
        confirmPopup.addMessage(context: "AddMenuItem")
        
        closeCell()
        
        
        UserManager.UpdateTicketStatus(user: currentUser!, ticket: ticket!.ticket_ID!, status: "Ordering")
        
        tableView.isScrollEnabled = false
    }
    
    //Add the order to a summary array
    func addToOrder(item: MenuItem) {
        self.ticket?.itemsOrdered?.append(item)
    }

    
    //Segues for Back and Done Button Presses
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmOrder" {
            
            //Disable cell observers
            self.curentCell?.ignoreFrameChanges()
            
            let summaryTable = segue.destination as! SummaryViewController
            
            summaryTable.ticket = ticket!
        }
        else if segue.identifier == "ReturnMainSegue" {
            let mainVC = segue.destination as! MainMenuViewController

            mainVC.ticket = ticket
            mainVC.menu = menu
        }
    }

    //Back Button for Unwind Segue to Main Menu
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        for i in 0...(menu_group?.items?.count)!-1 {
            let cell = tableView.visibleCells[i] as! MenuCell
            cell.ignoreFrameChanges()
        }   
        
        self.performSegue(withIdentifier: "ReturnMainSegue", sender: self)
    }
    
    //Unwind Segue for Order Summary
    @IBAction func unwindToMenuDetails(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? OrderConfirmationViewController {
            ticket = sourceVC.ticket!

            self.navigationController?.isNavigationBarHidden = false
            
            if ticket?.itemsOrdered?.count == 0 {
                doneButton.isEnabled = false
            }
        }
        else if let sourceVC = sender.source as? SummaryViewController {
            ticket = sourceVC.ticket
            
            if ticket?.itemsOrdered?.count == 0 {
                doneButton.isEnabled = false
            }
        }
    }
    
    func loadTheme() {
        
        //Background and Tint
        self.view.backgroundColor = currentTheme!.primary!
        self.view.tintColor = currentTheme!.highlight!
        tableView.backgroundColor = currentTheme!.primary!
        
        //Navigation
        UINavigationBar.appearance().backgroundColor = currentTheme!.primary!
        UINavigationBar.appearance().tintColor = currentTheme!.highlight!
        self.navigationController?.navigationBar.barTintColor = currentTheme!.primary!
        self.navigationController?.navigationBar.tintColor = currentTheme!.highlight!
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: currentTheme!.highlight!, NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)]
        
        //Labels
        
        //Buttons
    }
    
    func showTotal() {
        
        let runningTotal = calculateTotal()
        
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.5
        fadeTransition.type = kCATransitionFade
        
        navigationController?.navigationBar.layer.add(fadeTransition, forKey: "fadeText")
        self.categoryLabel.title = "Current Total: $" + String(format: "%.2f", runningTotal)
        
        
        let delay = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.navigationController?.navigationBar.layer.add(fadeTransition, forKey: "fadeText")
            self.categoryLabel.title = self.menu_group!.title
        }
    }
    
    func calculateTotal() -> Double {
        var currTotal = 0.0
        if ticket?.itemsOrdered != nil {
            if (ticket?.itemsOrdered?.count)! > 0 {
                for item in ticket!.itemsOrdered! {
                    currTotal += item.price!
                }
            }
            
            let tax = currTotal*currentRestaurant!.tax!
            
            currTotal = currTotal + tax
        }
        
        return currTotal
    }
    
    }
    extension UIImageView {
        func getImage(urlString: String, circle: Bool) {
            
            self.image = nil
            
            if let img = imageCache.value(forKey: urlString) as? UIImage{
                self.image = img
            }
            else{
                let session = URLSession.shared
                let task = session.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if(error == nil){
                        
                        if let img = UIImage(data: data!) {
                            imageCache.setValue(img, forKey: urlString)    // Image saved for cache
                            DispatchQueue.main.async(execute: {
                                self.image = img
                                
                                if circle {
                                    self.image = img.circle
                                }
                            })
                        }
                        
                        
                    }
                })
                task.resume()
            }
        }
    }
    
