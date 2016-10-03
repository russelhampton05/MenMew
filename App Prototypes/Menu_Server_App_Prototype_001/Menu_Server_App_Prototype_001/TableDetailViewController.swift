//
//  TableDetailViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Variables
    var table: Table?
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumLabel: UILabel!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var customersTableView: UITableView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableNumLabel.text = "Table #" + String(table!.tableNum)
        ticketLabel.text = "Ticket " + table!.ticket
        statusLabel.text = table!.category
        
        customersTableView.delegate = self
        customersTableView.dataSource = self
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        
        
        customersTableView.reloadData()
        ordersTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.customersTableView {
            count = table!.clientList.count
        }
        else if tableView == self.ordersTableView {
            count = table!.orderList.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.customersTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
            
            cell!.textLabel!.text = table!.clientList[indexPath.row]
        }
        else if tableView == self.ordersTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
            
            cell!.textLabel!.text = table!.orderList[indexPath.row].name
            cell!.detailTextLabel!.text = "$ " + String(table!.orderList[indexPath.row].price)
        }
        
        return cell!
    }
    
}
