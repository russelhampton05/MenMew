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
        
        //Observe for updates
        ref.observe(.value, with:{(FIRDataSnapshot) in
            var ticketList: [Ticket] = []
            for item in FIRDataSnapshot.children {
                let ticket = Ticket(snapshot: item as! FIRDataSnapshot)
                
                let value = item as? NSDictionary
                let menuItems = value?["itemsOrdered"] as? NSDictionary
                
                
                //I'm assuming this is pass by reference, so the ticket passed in should be changed when this is done
                
                //Also this is intentionally async to prevent UI Drag.
                TicketManager.PopulateTicketItemsAsync(ticket: ticket, items: menuItems!)
                
                    if ticket.restaurant_ID == self.restaurant!.restaurant_ID! {
                        if ticket.tableNum != nil {
                            if currentServer!.tables!.contains(ticket.tableNum!) {
                                ticketList.append(ticket)
                            }
                        }
                    
                }
            }
            
            //Initialize date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
            //Sort tickets by datetime
            ticketList.sort() {dateFormatter.date(from: $0.timestamp!)! > dateFormatter.date(from: $1.timestamp!)!}
            
            self.ticketList = ticketList
            self.tableView.reloadData()
            
        }){(error) in
            print(error.localizedDescription)}
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
        if ticketList.count == 0 {
            return 1
        }
        else {
            return ticketList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! RTableCell
        
        //Get updated information regarding status
        if ticketList.count > 0 {
            tableView.isUserInteractionEnabled = true
            cell.tableLabel.text = "Table " + ticketList[indexPath.row].tableNum!
            cell.ticketLabel.text = "Ticket " + ticketList[indexPath.row].desc!
            cell.statusLabel.text = ticketList[indexPath.row].status!
            
            //Format date to more human-readable result
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let currentDate = formatter.date(from:ticketList[indexPath.row].timestamp!)
            
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            
            cell.dateLabel.text = formatter.string(from: currentDate!)
        }
        
        else {
            cell.tableLabel.text = "No active tables assigned."
            cell.dateLabel.text = ""
            cell.statusLabel.text = ""
            cell.ticketLabel.text = ""
            tableView.isUserInteractionEnabled = false
        }
        
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
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
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
