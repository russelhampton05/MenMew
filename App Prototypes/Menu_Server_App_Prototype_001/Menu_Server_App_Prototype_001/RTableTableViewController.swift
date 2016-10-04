//
//  RTableTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

struct Table {
    var tableNum: Int
    var clientList: [String]
    var orderList: [(name: String, price: Double)]
    var category: String
    var ticket: String
    var fulfilled: Bool
}

class RTableTableViewController: UITableViewController {

    //Variables
    var restaurant: String?
    var location: String?
    var segueIndex: Int?
   
    //Dummy Data
    var tableList = [Table]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70

        self.title = restaurant!
        
        loadTables(restaurant: restaurant!)
    }
    
    //Dummy Function to load Different Table Lists depending on Restaurant
    func loadTables(restaurant: String) {
        
        if restaurant == "RJ's Steakhouse" {
            let table12 = Table(tableNum: 12, clientList: ["John Doe", "Ana Smith"], orderList: [], category: "Ordering", ticket: "A-12",fulfilled: false)
            let table22 = Table(tableNum: 22, clientList: [], orderList: [], category: "Available", ticket: "A-22", fulfilled: false)
            let table7 = Table(tableNum: 7, clientList: ["Drake Jones", "Talia Majeti", "Erik Hansson"], orderList: [(name: "New York Strip", price: 21.75), (name: "Pork Chop", price: 15.75), (name: "Margarita", price: 6.40)], category: "Ready to Serve", ticket: "A-7", fulfilled: false)
            
            tableList = [table7, table12, table22]
        }
        else if restaurant == "P.F. Chang's" {
            
            let table11 = Table(tableNum: 11, clientList: ["Jack Finch", "Taylor Miles"], orderList: [(name: "Garlic Noodles", price: 7.50), (name: "Crispy Honey Shrimp", price: 15.95), (name: "Hot Tea", price: 2.25)], category: "Refill Requested", ticket: "RZ224", fulfilled: false)
            let table13 = Table(tableNum: 13, clientList: [], orderList: [], category: "Available", ticket: "HR32E", fulfilled: false)
            let table7 = Table(tableNum: 7, clientList: [], orderList: [], category: "Available", ticket: "A8REE", fulfilled: false)
            tableList = [table11, table13, table7]
        }
        else if restaurant == "Cafe 101" {
            let table3 = Table(tableNum: 3, clientList: ["Mika Sugihara"], orderList: [], category: "Ordering", ticket: "C-3A", fulfilled: false)
            let table4 = Table(tableNum: 4, clientList: [], orderList: [],  category: "Available", ticket: "G-4E", fulfilled: false)
            let table8 = Table(tableNum: 8, clientList: ["Kim Stark"], orderList: [(name: "Taro Milk Tea", price: 4.40)], category: "Orders Pending", ticket: "S-8A", fulfilled: false)
            
            tableList = [table8, table3, table4]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! RTableCell
        
        cell.tableLabel.text = "Table " + String(tableList[indexPath.row].tableNum)
        cell.ticketLabel.text = "Ticket #" + tableList[indexPath.row].ticket
        cell.statusLabel.text = tableList[indexPath.row].category
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = indexPath.row
        performSegue(withIdentifier: "TableDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableDetailSegue" {
            let tableDetailVC = segue.destination as! TableDetailViewController
            
            tableDetailVC.table = tableList[segueIndex!]
        }
    }
}
