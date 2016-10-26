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

        var idList: [String] = []
        idList.append("ee3004f1cd774bba9afb9ab1c12dd567")
        idList.append("4200522c6b0349d8965b3bc32fa0f823")
        
        MenuItemManager.GetMenuItem(ids: idList) {
            items in
            
            var orderList: [(name: String, price: Double)] = []
            
            if items[0].desc != nil {
                for item in items {
                    orderList.append((name: item.desc!, price: item.price!))
                }
            }
            
            self.orderList = orderList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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

        cell.textLabel!.text = orderList![indexPath.row].name
        cell.detailTextLabel!.text = "$" + String(orderList![indexPath.row].price)

        return cell
    }
 

}
