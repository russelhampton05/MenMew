//
//  OrderTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/4/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    //Variables
    var orderList: [(name: String, price: Double)]?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return orderList!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)

        cell.textLabel!.text = orderList![indexPath.row].name
        cell.detailTextLabel!.text = "$" + String(orderList![indexPath.row].price)

        return cell
    }
 

}
