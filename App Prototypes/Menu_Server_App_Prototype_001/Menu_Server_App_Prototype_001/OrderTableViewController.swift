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
    var orderList: [MenuItem]?

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

        if orderList == nil {
            return 0
        }
        else {
            return orderList!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)

        cell.textLabel!.text = orderList![indexPath.row].title
        
        let price = orderList![indexPath.row].price!
        cell.detailTextLabel!.text = "$" + String(format: "%.2f", price)

        return cell
    }
 

}
