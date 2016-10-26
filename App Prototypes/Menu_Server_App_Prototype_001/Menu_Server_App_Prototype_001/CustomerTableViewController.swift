//
//  CustomerTableViewController.swift
//  Menu_Server_App_Prototype_001
//
//  Created by Jon Calanio on 10/4/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class CustomerTableViewController: UITableViewController {

    //Variables
    var customerList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserManager.GetUser(id: "S3Yyp2BRfSNCjgfW48hsS96B2Of1") {
            user in
            
            var userList: [String] = []
            userList.append(user.name!)
            self.customerList = userList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if customerList == nil {
            return 0
        }
        else {
            return customerList!.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)

        cell.textLabel!.text = customerList![indexPath.row]

        return cell
    }
}
