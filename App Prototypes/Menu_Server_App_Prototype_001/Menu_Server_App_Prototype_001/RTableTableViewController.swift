//
//  RTableTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/3/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import Firebase

class RTableTableViewController: UITableViewController {
    
    //Reference
    let ref = FIRDatabase.database().reference().child("Tickets")
    //Variables
    var restaurant: Restaurant?
    var location: String?
    var segueIndex: Int?
    let formatter = DateFormatter()
    var ticketList: [Ticket] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        self.title = restaurant!.title!
        
        //loadTickets(restaurant: restaurant!.restaurant_ID!)
        
        //Observe for updates
        ref.observe(.value, with:{(FIRDataSnapshot) in
            var newTickets: [Ticket] = []
            for item in FIRDataSnapshot.children {
                let ticket = Ticket(snapshot: item as! FIRDataSnapshot)
                
                //Filter according to assigned tables
                var tableList: [String] = ["12", "15", "22", "8"]
                if tableList.contains(ticket.tableNum!) {
                    newTickets.append(ticket)
                }
                
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            print(dateFormatter.date(from: newTickets[0].timestamp!)!)
            
            //Sort tickets by datetime
            newTickets.sort() {dateFormatter.date(from: $0.timestamp!)! > dateFormatter.date(from: $1.timestamp!)!}
            
            self.ticketList = newTickets
            self.tableView.reloadData()
            
        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    //Load tickets based on selected restaurant
    //For now, only loads all tickets (not filtered)
    func loadTickets(restaurant: String) {
        let semTicket = DispatchGroup.init()
        semTicket.enter()
        RestaurantManager.GetRestaurantTickets(restaurant: restaurant) {
            tickets in
            
            self.ticketList = tickets
            semTicket.leave()
        }
        
        semTicket.notify(queue: DispatchQueue.main, execute: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! RTableCell
        
        //Get updated information regarding status
        
        
        cell.tableLabel.text = "Table " + ticketList[indexPath.row].tableNum!
        cell.ticketLabel.text = "Ticket " + ticketList[indexPath.row].desc!
        
        if ticketList[indexPath.row].paid! {
            cell.statusLabel.text = "Fulfilled"
        }
        else if !(ticketList[indexPath.row].paid!) {
            cell.statusLabel.text = "Open"
        }

        cell.dateLabel.text = ticketList[indexPath.row].timestamp!
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueIndex = indexPath.row
        performSegue(withIdentifier: "TableDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableDetailSegue" {
            let tableDetailVC = segue.destination as! TableDetailViewController
            
            tableDetailVC.ticket = ticketList[segueIndex!]
        }
    }
    
    @IBAction func unwindToTableList(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? TableDetailViewController {
            
            //Update states and date for order fulfillment
            ticketList[segueIndex!].paid = true
            
            //Update timestamp
            let date = NSDate()
            var currentDate = formatter.string(from: date as Date)
            ticketList[segueIndex!].timestamp = currentDate
            
            //RestaurantManager.UpdateTicket(ticket: ticketList[segueIndex!], restaurant: restaurant)
            tableView.reloadData()
        }
    }
    
    func getStatus() {
        
    }
}
